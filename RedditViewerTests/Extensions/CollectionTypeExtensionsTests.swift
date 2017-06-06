//
//  CollectionTypeExtensionsTests.swift
//  RageOn
//
//  Created by Alexander Voronov on 2/23/17.
//  Copyright © 2017 RageOn. All rights reserved.
//

import XCTest
@testable import RedditViewer

class CollectionTypeExtensionsTests: XCTestCase {
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
