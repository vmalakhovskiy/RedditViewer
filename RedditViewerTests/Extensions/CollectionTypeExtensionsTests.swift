//
//  CollectionTypeExtensionsTests.swift
//  RageOn
//
//  Created by Vitaliy Malakhovskiy on 5/28/17.
//  Copyright © 2017 Vitalii Malakhovskyi. All rights reserved.
//

import XCTest
@testable import RedditViewer

class CollectionTypeExtensionsTests: XCTestCase {
    func testIsNotEmpty_returnsTrue_whenCollectionIsNotEmpty() {
        let collection = Array(0...5)

        XCTAssert(collection.isNotEmpty)
    }

    func testIsNotEmpty_returnsFalse_whenCollectionIsEmpty() {
        let collection = [Int]()

        XCTAssertFalse(collection.isNotEmpty)
    }

    func testSafeSubscript_shouldReturnNil_whenAccessingItemByIndexOutOfBounds() {
        let collection = Array(0...5)

        let result = collection[safe: 8]

        XCTAssertNil(result)
    }

    func testSafeSubscript_shouldReturnNil_whenAccessingItemByNegativeIndex() {
        let collection = Array(0...5)

        let result = collection[safe: -8]

        XCTAssertNil(result)
    }

    func testSafeSubscript_shouldReturnItemAtIndex_whenAccessingItemByValidIndex() {
        let collection = Array(0...5)

        let result = collection[safe: 3]

        XCTAssertEqual(result, 3)
    }
}
