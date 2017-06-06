//
//  ImagePreview.swift
//  RedditViewer
//
//  Created by Vitaliy Malakhovskiy on 6/1/17.
//  Copyright © 2017 Vitalii Malakhovskyi. All rights reserved.
//

import UIKit

class ImagePreviewViewController: UIViewController {
    fileprivate static let sourceImageUrlRestorableKey = "sourceImageUrlRestorableKey"

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var sourceImageView: UIImageView!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var saveOperationActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var saveButton: UIButton!

    var model: ImagePreviewModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        restorationClass = ImagePreviewViewController.self

        activityIndicator.startAnimating()
        saveButton.isEnabled = false
        model?.getSourceImage { image in
            DispatchQueue.main.async { [weak self] in
                guard let strongSelf = self else { return }
                strongSelf.sourceImageView.image = image 
                strongSelf.activityIndicator.stopAnimating()
                strongSelf.saveButton.isEnabled = true
            }
        }
    }

    @IBAction func onCloseButtonDidTap(_ sender: UIButton) {
        model?.cancelImageDownloadingIfNeeded()
        dismiss(animated: true, completion: nil)
    }

    @IBAction func onSaveButtonDidTap(_ sender: UIButton) {
        saveOperationActivityIndicator.startAnimating()
        saveButton.isHidden = true
        closeButton.isEnabled = false
        DispatchQueue.global().async { [weak self] in
            self?.model?.saveSourceImageToCameraRoll { error in
                DispatchQueue.main.async { [weak self] in
                    guard let strongSelf = self else { return }
                    if let error = error {
                        strongSelf.showAlert(with: error)
                    }
                    strongSelf.saveOperationActivityIndicator.stopAnimating()
                    strongSelf.saveButton.isHidden = false
                    strongSelf.closeButton.isEnabled = true
                }
            }
        }
    }

    private func showAlert(with error: NSError) {
        let alert = UIAlertController(title: error.localizedDescription, message: error.localizedRecoverySuggestion, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }

    override func encodeRestorableState(with coder: NSCoder) {
        coder.encode(model?.sourceImageUrl, forKey: ImagePreviewViewController.sourceImageUrlRestorableKey)
        super.encodeRestorableState(with: coder)
    }
}

extension ImagePreviewViewController: StoryboardIdentifiable {}

extension ImagePreviewViewController: UIViewControllerRestoration {
    static func viewController(withRestorationIdentifierPath identifierComponents: [Any], coder: NSCoder) -> UIViewController? {
        if let storyboard = coder.decodeObject(forKey: UIStateRestorationViewControllerStoryboardKey) as? UIStoryboard,
           let url = coder.decodeObject(forKey: ImagePreviewViewController.sourceImageUrlRestorableKey) as? String,
           let controller: ImagePreviewViewController = storyboard.instantiateViewController() {
            controller.model = ImagePreviewModelFactory.default(sourceImageUrl: url)
            return controller
        }
        return nil
    }
}
