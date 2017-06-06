//
//  EntitiesRandomExtensions.swift
//  RedditViewer
//
//  Created by Vitaliy Malakhovskiy on 5/29/17.
//  Copyright © 2017 Vitalii Malakhovskyi. All rights reserved.
//

import Foundation
@testable import RedditViewer

extension Reddit: Random {
    static func random() -> Reddit {
        return restrictedRandom()
    }

    static func restrictedRandom(_
        title: String = .random(),
        author: String = .random(),
        entryDateInterval: TimeInterval = .random(),
        thumbnail: String = .random(),
        sourceImage: String? = .random(),
        commentsCount: Int = .random(),
        score: Int = .random(),
        name: String = .random()
    ) -> Reddit {
        return Reddit(
            title: title,
            author: author,
            entryDateInterval: entryDateInterval,
            thumbnail: thumbnail,
            sourceImage: sourceImage,
            commentsCount: commentsCount,
            score: score,
            name: name
        )
    }
}
