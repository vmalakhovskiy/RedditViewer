//
//  RedditsListViewController.swift
//  RedditViewer
//
//  Created by Vitaliy Malakhovskiy on 5/28/17.
//  Copyright © 2017 Vitalii Malakhovskyi. All rights reserved.
//

import UIKit

// MARK: RedditsListViewController

class RedditsListViewController: UITableViewController {
    let model = RedditsListModelFactory.default()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationController()
        setupTableView()
        setupRefreshControl()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        model.fetchTopRedditsIfNeeded { progress in
            DispatchQueue.main.async { [weak self] in
                guard let strongSelf = self else { return }
                switch progress {
                case .inProgress:
                    let activity = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
                    activity.color = CommonAppearance.titleTextColor
                    activity.startAnimating()
                    strongSelf.tableView.backgroundView = activity
                case .success(value: let reddits): ()
                if reddits.isEmpty {
                    strongSelf.tableView.backgroundView = strongSelf.noRedditsView()
                } else {
                    strongSelf.tableView.backgroundView = nil
                }
                strongSelf.tableView.reloadData()
                case .failure(error: let error):
                    strongSelf.tableView.backgroundView = nil
                    strongSelf.showAlert(with: error)
                }
            }
        }
    }

    private func setupNavigationController() {
        navigationController?.navigationBar.barTintColor = CommonAppearance.barTintColor
    }

    private func setupTableView() {
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 150
    }

    private func setupRefreshControl() {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(reloadReddits), for: .valueChanged)
        tableView.refreshControl = refreshControl
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.viewData.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let redditListViewData = model.viewData[safe: indexPath.row] else {
            return UITableViewCell()
        }

        if let cell = tableView.dequeueReusableCell(withIdentifier: RedditsListCell.reuseIdentifier) as? RedditsListCell,
            case .reddit(let viewData) = redditListViewData
        {
            cell.populate(with: viewData)
            return cell
        } else if let cell = tableView.dequeueReusableCell(withIdentifier: RedditsListLoadingCell.reuseIdentifier) as? RedditsListLoadingCell,
            case .loadMore = redditListViewData {
            cell.configureAppearance()
            return cell
        }
        return UITableViewCell()
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let model = model.imagePreviewModelForReddit(at: indexPath.row),
            let controller: ImagePreviewViewController = storyboard?.instantiateViewController() {
            controller.model = model
            present(controller, animated: true, completion: nil)
        }
    }

    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if cell is RedditsListLoadingCell {
            model.fetchMoreTopReddits { progress in
                DispatchQueue.main.async { [weak self] in
                    guard let strongSelf = self else { return }
                    switch progress {
                    case .inProgress: ()
                    case .success: strongSelf.tableView.reloadData()
                    case .failure(error: let error): strongSelf.showAlert(with: error)
                    }
                }
            }
        }
    }

    @objc private func reloadReddits() {
        tableView.backgroundView = nil
        model.fetchTopReddits { progress in
            DispatchQueue.main.async { [weak self] in
                guard let strongSelf = self else { return }
                switch progress {
                case .inProgress: ()
                case .success(value: let reddits): ()
                if reddits.isEmpty {
                    strongSelf.tableView.backgroundView = strongSelf.noRedditsView()
                } else {
                    strongSelf.tableView.backgroundView = nil
                }
                strongSelf.refreshControl?.endRefreshing()
                strongSelf.tableView.reloadData()
                case .failure(error: let error):
                    strongSelf.refreshControl?.endRefreshing()
                    strongSelf.showAlert(with: error)
                }
            }
        }
    }

    private func showAlert(with error: NSError) {
        let alert = UIAlertController(title: error.localizedDescription, message: error.localizedFailureReason, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }


    override func decodeRestorableState(with coder: NSCoder) {
        model.loadDataFromStorage()
        super.decodeRestorableState(with: coder)
    }

    private func noRedditsView() -> UIView {
        let view = UIView()
        let imageView = UIImageView(image: #imageLiteral(resourceName: "SadReddit"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)

        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.attributedText = NSAttributedString(
            string: "No reddits to show.\nPlease, pull to refresh",
            attributes: [
                NSForegroundColorAttributeName : CommonAppearance.supportingInfoTextColor,
                NSFontAttributeName: UIFont.systemFont(ofSize: 12)
            ]
        )
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)

        NSLayoutConstraint.activate([
            NSLayoutConstraint(item: imageView, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: imageView, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: label, attribute: .top, relatedBy: .equal, toItem: imageView, attribute: .bottom, multiplier: 1, constant: 10),
            NSLayoutConstraint(item: label, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0),
            ])
        return view
    }
}

extension RedditsListViewController: UIDataSourceModelAssociation {
    func modelIdentifierForElement(at idx: IndexPath, in view: UIView) -> String? {
        if let data = model.viewData[safe: idx.row], case .reddit(let viewData) = data {
            return viewData.name
        }
        return nil
    }

    func indexPathForElement(withModelIdentifier identifier: String, in view: UIView) -> IndexPath? {
        let item = model.viewData.index { viewData in
            if case .reddit(let data) = viewData {
                return data.name == identifier
            }
            return false
        }
        if let item = item {
            return IndexPath(row: item, section: 0)
        }
        return nil
    }
}
