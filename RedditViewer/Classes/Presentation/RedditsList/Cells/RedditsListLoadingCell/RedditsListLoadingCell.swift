//
//  RedditsListLoadingCell.swift
//  RedditViewer
//
//  Created by Vitaliy Malakhovskiy on 6/2/17.
//  Copyright © 2017 Vitalii Malakhovskyi. All rights reserved.
//

import UIKit

class RedditsListLoadingCell: UITableViewCell {

    @IBOutlet weak var loadingActivityIndicator: UIActivityIndicatorView!

    static var reuseIdentifier: String {
        return "RedditsListLoadingCell"
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        loadingActivityIndicator.color = CommonAppearance.titleTextColor
    }

    func configureAppearance() {
        loadingActivityIndicator.startAnimating()
    }
}
