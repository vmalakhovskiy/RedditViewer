//
//  RedditTests.swift
//  RedditViewer
//
//  Created by Vitaliy Malakhovskiy on 5/25/17.
//  Copyright © 2017 Vitalii Malakhovskyi. All rights reserved.
//

import Foundation
import XCTest
@testable import RedditViewer

class RedditTests: XCTestCase {
    func testInit_fails_withEmptyDictionary() {
        let dictionary = [String: Any]()

        let reddit = Reddit(with: dictionary)

        XCTAssertNil(reddit)
    }

    func testInit_fails_withInvalidDictionary() {
        let dictionary = [
            "title": NSNull(),
            "author": NSNull(),
            "created_utc": NSNull(),
            "thumbnail": NSNull(),
            "num_comments": NSNull(),
            "score": NSNull(),
            "name": NSNull()
        ]

        let reddit = Reddit(with: dictionary)

        XCTAssertNil(reddit)
    }

    func testInit_succeeds_withValidDictionary() {
        let dictionary = randomRedditDictionary()

        let reddit = Reddit(with: dictionary)

        XCTAssertNotNil(reddit)
    }

    func testInit_returnsObject_withCorrectlyParsedProperties() {
        let title = String.random()
        let author = String.random()
        let entryDateInterval = TimeInterval.random()
        let thumbnail = String.random()
        let sourceImage = String?.random()
        let commentsCount = Int.random()
        let score = Int.random()
        let name = String.random()
        let dictionary = restrictedRandomRedditDictionary(
            with: title,
            author: author,
            entryDateInterval: entryDateInterval,
            thumbnail: thumbnail,
            sourceImage: sourceImage,
            commentsCount: commentsCount,
            score: score,
            name: name
        )

        let reddit = Reddit(with: dictionary)

        XCTAssertEqual(reddit?.title, title)
        XCTAssertEqual(reddit?.author, author)
        XCTAssertEqual(reddit?.entryDateInterval, entryDateInterval)
        XCTAssertEqual(reddit?.thumbnail, thumbnail)
        XCTAssertEqual(reddit?.sourceImage, sourceImage)
        XCTAssertEqual(reddit?.commentsCount, commentsCount)
        XCTAssertEqual(reddit?.score, score)
        XCTAssertEqual(reddit?.name, name)
    }

    func testInit_ignoresSourceImageLink_thatLinksToGif() {
        let sourceImage = String.random() + ".gif" + String.random()
        let dictionary = restrictedRandomRedditDictionary(sourceImage: sourceImage)

        let reddit = Reddit(with: dictionary)

        XCTAssertNil(reddit?.sourceImage)
    }

    func testDictionaryRepresentation_returnsCorrectDictionary() {
        let reddit = Reddit.random()

        let testDictionary = restrictedRandomRedditDictionary(
            with: reddit.title,
            author: reddit.author,
            entryDateInterval: reddit.entryDateInterval,
            thumbnail: reddit.thumbnail,
            sourceImage: reddit.sourceImage,
            commentsCount: reddit.commentsCount,
            score: reddit.score,
            name: reddit.name
        )

        XCTAssert(NSDictionary(dictionary: testDictionary).isEqual(to: reddit.dictionaryRepresentation()))
    }
}

func randomRedditDictionary() -> [AnyHashable: Any] {
    return restrictedRandomRedditDictionary()
}

func restrictedRandomRedditDictionary(with
    title: String = .random(),
    author: String = .random(),
    entryDateInterval: TimeInterval = .random(),
    thumbnail: String = .random(),
    sourceImage: String? = .random(),
    commentsCount: Int = .random(),
    score: Int = .random(),
    name: String = .random()
) -> [AnyHashable: Any] {
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
