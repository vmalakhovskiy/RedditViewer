//
//  RedditsListCell.swift
//  RedditViewer
//
//  Created by Vitaliy Malakhovskiy on 5/28/17.
//  Copyright © 2017 Vitalii Malakhovskyi. All rights reserved.
//

import UIKit

class RedditsListCell: UITableViewCell {
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var supportingInfoLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var commentsCountLabel: UILabel!
    @IBOutlet weak var thumbnailImageActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var magnifyingGlassImageView: UIImageView!
    @IBOutlet weak var magnifyingGlassVerticalCenterConstarint: NSLayoutConstraint!

    private var imageDownloadOperation: Cancellable?
    private static let magnifyingGlassBottomOffset: CGFloat = 5

    override func awakeFromNib() {
        super.awakeFromNib()
        titleLabel.textColor = CommonAppearance.titleTextColor
        supportingInfoLabel.textColor = CommonAppearance.supportingInfoTextColor
        scoreLabel.textColor = CommonAppearance.supportingInfoTextColor
        commentsCountLabel.textColor = CommonAppearance.supportingInfoTextColor
        thumbnailImageActivityIndicator.color = CommonAppearance.supportingInfoTextColor
    }

    func populate(with viewData: RedditsListCellViewData) {
        thumbnailImageActivityIndicator.startAnimating()
        imageDownloadOperation = viewData.getThumbnailImage { image in
            DispatchQueue.main.async { [weak self] in
                guard let strongSelf = self else { return }
                strongSelf.thumbnailImageActivityIndicator.stopAnimating()
                strongSelf.thumbnailImageView.image = image
                strongSelf.magnifyingGlassImageView.isHidden = !viewData.hasLargeImage
                if let imageSize = strongSelf.thumbnailImageView.aspectFitImageSize() {
                    strongSelf.magnifyingGlassVerticalCenterConstarint.constant = imageSize.height / 2 + RedditsListCell.magnifyingGlassBottomOffset
                }
            }
        }
        titleLabel.text = viewData.title
        supportingInfoLabel.attributedText = viewData.supportingInfo
        commentsCountLabel.text = viewData.commentsCount
        scoreLabel.text = viewData.score
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        thumbnailImageView.image = nil
        imageDownloadOperation?.cancel()
        imageDownloadOperation = nil
        magnifyingGlassImageView.isHidden = true
    }

    static var reuseIdentifier: String {
        return "RedditsListCell"
    }
}
