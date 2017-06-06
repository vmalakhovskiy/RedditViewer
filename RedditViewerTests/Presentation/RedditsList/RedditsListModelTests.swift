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

    func testViewData_returnsIncrementedViewData_ifMoreDataExists() {
        let requestManager = FakeRedditApiRequestManager()
        let reddits = [Reddit].random()

        let sut = RedditsListModelImpl(apiManager: requestManager, reddits: reddits, after: String.random())

        XCTAssertEqual(sut.viewData.count, reddits.count + 1)
    }

    func testViewData_returnsViewDataByAppendingLoadingViewData_ifMoreDataExists() {
        let requestManager = FakeRedditApiRequestManager()
        let reddits = [Reddit].random()

        let sut = RedditsListModelImpl(apiManager: requestManager, reddits: reddits, after: String.random())

        let isLoadMore: Bool
        if case .loadMore? = sut.viewData.last {
            isLoadMore = true
        } else {
            isLoadMore = false
        }
        XCTAssert(isLoadMore)
    }

    func testViewData_returnsViewDataWithoutAppendingLoadingViewData_ifNoMoreDataExists() {
        let requestManager = FakeRedditApiRequestManager()
        let reddits = [Reddit].random()

        let sut = RedditsListModelImpl(apiManager: requestManager, reddits: reddits)

        let isReddit: Bool
        if case .reddit(_)? = sut.viewData.last {
            isReddit = true
        } else {
            isReddit = false
        }
        XCTAssert(isReddit)
    }

    func testViewData_returnsUnincrementedViewData_ifNoMoreDataExists() {
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

    func testFetchTopReddits_doesntFetchReddits_ifAnyFetchOperationExists() {
        let requestManager = FakeRedditApiRequestManager()
        let sut = RedditsListModelImpl(apiManager: requestManager, predefinedFetchOperation: EmptyCancellable())

        sut.fetchTopReddits(with: nil)

        XCTAssertEqual(requestManager.fetchTopRedditsCalled, false)
    }

    func testFetchMoreTopReddits_passCorrectAfterParameter_storedFromLastFetch() {
        let after = String.random()
        let requestManager = FakeRedditApiRequestManager()
        let sut = RedditsListModelImpl(apiManager: requestManager, after: after)

        sut.fetchMoreTopReddits(with: nil)

        XCTAssertEqual(requestManager.passedAfter, after)
        XCTAssertNotNil(after)
    }

    func testFetchMoreTopReddits_doesntFetchReddits_ifAnyFetchOperationExists() {
        let requestManager = FakeRedditApiRequestManager()
        let sut = RedditsListModelImpl(apiManager: requestManager, predefinedFetchOperation: EmptyCancellable())

        sut.fetchMoreTopReddits(with: nil)

        XCTAssertEqual(requestManager.fetchTopRedditsCalled, false)
    }

    func testFetchMoreTopReddits_appendsLocallyStoredRedditsWithReceived_ifAny() {
        let requestManager = FakeRedditApiRequestManager()
        requestManager.predefinedReddits = [.random()]
        let sut = RedditsListModelImpl(apiManager: requestManager, reddits: [.random(), .random()])

        sut.fetchMoreTopReddits(with: nil)

        XCTAssertEqual(sut.viewData.count, 3)
    }

    func testFetchMoreTopReddits_doesNotAppendsLocallyStoredRedditsWithReceived_ifErrorOccures() {
        let requestManager = FakeRedditApiRequestManager()
        requestManager.predefinedReddits = [.random()]
        requestManager.predefinedError = NSError(domain: "", code: 0, userInfo: nil)
        let sut = RedditsListModelImpl(apiManager: requestManager, reddits: [.random(), .random()])

        sut.fetchMoreTopReddits(with: nil)

        XCTAssertEqual(sut.viewData.count, 2)
    }

    func testFetchMoreTopReddits_returnsError_ifAny() {
        let error = NSError.random()
        let requestManager = FakeRedditApiRequestManager()
        requestManager.predefinedError = error
        let sut = RedditsListModelImpl(apiManager: requestManager)
        var receivedError: NSError?

        sut.fetchMoreTopReddits { progress in
            if case let .failure(err) = progress {
                receivedError = err
            }
        }

        XCTAssertEqual(error, receivedError)
    }
}
