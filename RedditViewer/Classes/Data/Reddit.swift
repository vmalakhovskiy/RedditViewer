//
//  Reddit.swift
//  RedditViewer
//
//  Created by Vitaliy Malakhovskiy on 5/25/17.
//  Copyright © 2017 Vitalii Malakhovskyi. All rights reserved.
//

import Foundation

struct Reddit {
    let title: String
    let author: String
    let entryDateInterval: TimeInterval
    let thumbnail: String
    let sourceImage: String?
    let commentsCount: Int
    let score: Int
    let name: String
}

extension Reddit {
    init?(with dictionary: [AnyHashable: Any]) {
        if let title = dictionary["title"] as? String,
           let author = dictionary["author"] as? String,
           let entryDateInterval = dictionary["created_utc"] as? TimeInterval,
           let thumbnail = dictionary["thumbnail"] as? String,
           let commentsCount = dictionary["num_comments"] as? Int,
           let score = dictionary["score"] as? Int,
           let name = dictionary["name"] as? String
        {
            self.title = title
            self.author = author
            self.entryDateInterval = entryDateInterval
            self.thumbnail = thumbnail
            self.commentsCount = commentsCount
            self.score = score
            self.name = name

            if let preview = dictionary["preview"] as? [String: Any],
               let images = preview["images"] as? [[String: Any]],
               let source = images.first?["source"] as? [String: Any],
               let url = source["url"] as? String {
                self.sourceImage = url.contains(".gif") ? nil : url
            } else {
                self.sourceImage = nil
            }

        } else {
            return nil
        }
    }

    func dictionaryRepresentation() -> [AnyHashable: Any] {
        var dictionary: [AnyHashable: Any] = [
            "title": title,
            "author": author,
            "created_utc": entryDateInterval,
            "thumbnail": thumbnail,
            "num_comments": commentsCount,
            "score": score,
            "name": name
        ]
        if let sourceImage = sourceImage {
            dictionary["preview"] = [
                "images": [
                    [
                        "source": [
                            "url": sourceImage
                        ]
                    ]
                ]
            ]
        }
        return dictionary
    }
}

extension Reddit: Equatable {}

func ==(lhs: Reddit, rhs: Reddit) -> Bool {
    return lhs.title == rhs.title
        && lhs.author == rhs.author
        && lhs.entryDateInterval == rhs.entryDateInterval
        && lhs.thumbnail == rhs.thumbnail
        && lhs.sourceImage == rhs.sourceImage
        && lhs.commentsCount == rhs.commentsCount
        && lhs.score == rhs.score
        && lhs.name == rhs.name
}
