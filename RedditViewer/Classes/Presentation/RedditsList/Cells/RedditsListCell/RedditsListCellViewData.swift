//
//  RedditsListCellViewData.swift
//  RedditViewer
//
//  Created by Vitaliy Malakhovskiy on 6/2/17.
//  Copyright © 2017 Vitalii Malakhovskyi. All rights reserved.
//

import Foundation
import UIKit

protocol ImageDownloader {
    func downloadImage(with url: URL, completion: ((UIImage?) -> ())?) -> Cancellable
}

class ImageDownloaderImpl: ImageDownloader {
    func downloadImage(with url: URL, completion: ((UIImage?) -> ())?) -> Cancellable {
        return EmptyCancellable()
    }
}

// MARK: Implementation

struct RedditsListCellViewData {
    fileprivate let reddit: Reddit
    private let imageDownloader: ImageDownloader
    private let calendar: Calendar

    init(reddit: Reddit, imageDownloader: ImageDownloader, calendar: Calendar) {
        self.reddit = reddit
        self.imageDownloader = imageDownloader
        self.calendar = calendar
    }

    var title: String {
        return reddit.title
    }

    var name: String {
        return reddit.name
    }

    var hasLargeImage: Bool {
        guard let sourceImageLink = reddit.sourceImage else {
            return false
        }
        return !sourceImageLink.isEmpty
    }

    var supportingInfo: NSAttributedString {
        let supportingInfoMutableString = NSMutableAttributedString(
            string: "posted \(timeAgo(since: Date(timeIntervalSince1970: reddit.entryDateInterval))) by ",
            attributes: [
                NSForegroundColorAttributeName : CommonAppearance.supportingInfoTextColor,
                NSFontAttributeName: UIFont.systemFont(ofSize: 12)
            ]
        )
        let author = NSAttributedString(
            string: "\(reddit.author)",
            attributes: [
                NSForegroundColorAttributeName : CommonAppearance.titleTextColor,
                NSFontAttributeName: UIFont.boldSystemFont(ofSize: 12)
            ]
        )
        supportingInfoMutableString.append(author)
        return supportingInfoMutableString
    }

    var commentsCount: String {
        return "\(reddit.commentsCount)"
    }

    var score: String {
        return reddit.score.formatUsingAbbrevation().lowercased()
    }

    func getThumbnailImage(with completion: @escaping (UIImage?) -> ()) -> Cancellable {
        if let image = UIImage(named: reddit.thumbnail.capitalized) {
            completion(image)
            return EmptyCancellable()
        }
        guard let url = URL(string: reddit.thumbnail) else {
            completion(nil)
            return EmptyCancellable()
        }
        return imageDownloader.downloadImage(with: url, completion: completion)
    }

    private func timeAgo(since date: Date) -> String {
        return calendar.timeAgo(since: date)
    }
}

extension RedditsListCellViewData: Equatable {}

func ==(lhs: RedditsListCellViewData, rhs: RedditsListCellViewData) -> Bool {
    return lhs.reddit == rhs.reddit
}

// MARK: Factory

class RedditsListCellViewDataFactory {
    static func `default`(reddit: Reddit) -> RedditsListCellViewData {
        return RedditsListCellViewData(reddit: reddit, imageDownloader: ImageDownloaderImpl(), calendar: Calendar.current)
    }
}
