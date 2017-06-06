//
//  RedditsListDataStorageTests.swift
//  RedditViewer
//
//  Created by Vitaliy Malakhovskiy on 6/3/17.
//  Copyright © 2017 Vitalii Malakhovskyi. All rights reserved.
//

import Foundation
import XCTest
@testable import RedditViewer

class RedditsListDataStorageTests: XCTestCase {
    var sut: RedditsListDataStorage!
    var userDefaults: UserDefaults!
    var reddits: [Reddit]!
    var after: String!

    override func setUp() {
        reddits = .random()
        after = .random()
        userDefaults = UserDefaults.init(suiteName: "Test User Defaults")
        sut = RedditsListDataStorageImpl(userDefaults: userDefaults)
    }

    override func tearDown() {
        userDefaults.removeObject(forKey: RedditsListDataStorageImpl.redditsStorageKey)
        userDefaults.removeObject(forKey: RedditsListDataStorageImpl.afterStorageKey)
    }

    func testSaveReddits_saves_providedReddits() {
        sut.save(reddits: reddits)
        XCTAssertEqual(userDefaults.array(forKey: RedditsListDataStorageImpl.redditsStorageKey)?.count, reddits.count)
    }

    func testSaveAfter_saves_providedAfter() {
        sut.safe(after: after)
        XCTAssertEqual(userDefaults.string(forKey: RedditsListDataStorageImpl.afterStorageKey), after)
    }

    func testGetReddits_returns_savedReddits() {
        sut.save(reddits: reddits)
        XCTAssertEqual(sut.getReddits(), reddits)
    }

    func testAfter_returns_afterValue() {
        sut.safe(after: after)
        XCTAssertEqual(sut.getAfter(), after)
    }

    func testCleanupData_cleans_redditsAndAfter() {
        sut.save(reddits: reddits)
        sut.safe(after: after)
        sut.cleanupData()
        XCTAssertNil(userDefaults.object(forKey: RedditsListDataStorageImpl.redditsStorageKey))
        XCTAssertNil(userDefaults.object(forKey: RedditsListDataStorageImpl.afterStorageKey))
    }
}
