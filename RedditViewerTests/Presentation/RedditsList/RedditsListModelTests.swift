//
//  RedditsListModelTests.swift
//  RedditViewer
//
//  Created by Vitaliy Malakhovskiy on 5/29/17.
//  Copyright © 2017 Vitalii Malakhovskyi. All rights reserved.
//

import XCTest
@testable import RedditViewer

class RedditsListModelTests: XCTestCase {
    func testViewData_returnsEmptyViewData_ifNoRedditsStored_andNoMoreData() {
        let reddits = [Reddit]()

        let sut = RedditsListModelImpl(apiManager: FakeRedditApiRequestManager(), reddits: reddits)

        XCTAssertEqual(sut.viewData.count, 0)
    }

    func testViewData_returnsViewData_ifNoMoreDataExists() {
        let requestManager = FakeRedditApiRequestManager()
        let reddits = [Reddit].random()

        let sut = RedditsListModelImpl(apiManager: requestManager, reddits: reddits)

        XCTAssertEqual(sut.viewData.count, reddits.count)
    }

    func testFetchTopReddits_passCorrectNilAfterParameter_ifNoRedditsStored() {
        let requestManager = FakeRedditApiRequestManager()
        let sut = RedditsListModelImpl(apiManager: requestManager)

        sut.fetchTopReddits(with: nil)

        XCTAssertEqual(requestManager.passedAfter, nil)
    }

    func testFetchTopReddits_passCorrectAfterParameter() {
        let requestManager = FakeRedditApiRequestManager()
        let sut = RedditsListModelImpl(apiManager: requestManager)

        sut.fetchTopReddits(with: nil)

        XCTAssertEqual(requestManager.passedAfter, nil)
    }

    func testFetchTopReddits_storesRedditsLocally_ifAny() {
        let requestManager = FakeRedditApiRequestManager()
        requestManager.predefinedReddits = [.random(), .random(), .random(), .random(), .random()]
        let sut = RedditsListModelImpl(apiManager: requestManager, reddits: [.random(), .random()])

        sut.fetchTopReddits(with: nil)

        XCTAssertEqual(sut.viewData.count, requestManager.predefinedReddits.count)
    }

    func testFetchTopReddits_doesNotStoresRedditsLocally_ifErrorOccures() {
        let requestManager = FakeRedditApiRequestManager()
        requestManager.predefinedReddits = [.random(), .random(), .random(), .random(), .random()]
        requestManager.predefinedError = NSError(domain: "", code: 0, userInfo: nil)
        let sut = RedditsListModelImpl(apiManager: requestManager, reddits: [.random()])

        sut.fetchTopReddits(with: nil)

        XCTAssertEqual(sut.viewData.count, 1)
    }

    func testFetchTopReddits_returnsError_ifAny() {
        let error = NSError.random()
        let requestManager = FakeRedditApiRequestManager()
        requestManager.predefinedError = error
        let sut = RedditsListModelImpl(apiManager: requestManager)
        var returnedError: NSError?

        sut.fetchTopReddits { progress in
            if case let .failure(err) = progress {
                returnedError = err
            }
        }
        
        XCTAssertEqual(error, returnedError)
    }

    func testViewData_returnsViewDataWithoutAppendingLoadingViewDataAfterTopRedditsFetch_ifMoreDataExistsButNoStoredData() {
        let requestManager = FakeRedditApiRequestManager()
        requestManager.predefinedAfter = String.random()
        let sut = RedditsListModelImpl(apiManager: requestManager)

        sut.fetchTopReddits(with: nil)

        XCTAssert(sut.viewData.isEmpty)
    }
}
