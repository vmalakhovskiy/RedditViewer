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

        let sut = RedditsListModelImpl(apiManager: FakeRedditApiRequestManager(), reddits: reddits, storage: FakeRedditsListDataStorage())

        XCTAssertEqual(sut.viewData.count, 0)
    }

    func testViewData_returnsIncrementedViewData_ifMoreDataExists() {
        let requestManager = FakeRedditApiRequestManager()
        let reddits = [Reddit].random()

        let sut = RedditsListModelImpl(apiManager: requestManager, reddits: reddits, after: String.random(), storage: FakeRedditsListDataStorage())

        XCTAssertEqual(sut.viewData.count, reddits.count + 1)
    }

    func testViewData_returnsViewDataByAppendingLoadingViewData_ifMoreDataExists() {
        let requestManager = FakeRedditApiRequestManager()
        let reddits = [Reddit].random()

        let sut = RedditsListModelImpl(apiManager: requestManager, reddits: reddits, after: String.random(), storage: FakeRedditsListDataStorage())

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

        let sut = RedditsListModelImpl(apiManager: requestManager, reddits: reddits, storage: FakeRedditsListDataStorage())

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

        let sut = RedditsListModelImpl(apiManager: requestManager, reddits: reddits, storage: FakeRedditsListDataStorage())

        XCTAssertEqual(sut.viewData.count, reddits.count)
    }

    func testFetchTopReddits_passCorrectNilAfterParameter_ifNoRedditsStored() {
        let requestManager = FakeRedditApiRequestManager()
        let sut = RedditsListModelImpl(apiManager: requestManager, storage: FakeRedditsListDataStorage())

        sut.fetchTopReddits(with: nil)

        XCTAssertEqual(requestManager.passedAfter, nil)
    }

    func testFetchTopReddits_passCorrectAfterParameter() {
        let requestManager = FakeRedditApiRequestManager()
        let sut = RedditsListModelImpl(apiManager: requestManager, storage: FakeRedditsListDataStorage())

        sut.fetchTopReddits(with: nil)

        XCTAssertEqual(requestManager.passedAfter, nil)
    }

    func testFetchTopReddits_storesRedditsLocally_ifAny() {
        let requestManager = FakeRedditApiRequestManager()
        requestManager.predefinedReddits = [.random(), .random(), .random(), .random(), .random()]
        let sut = RedditsListModelImpl(apiManager: requestManager, reddits: [.random(), .random()], storage: FakeRedditsListDataStorage())

        sut.fetchTopReddits(with: nil)

        XCTAssertEqual(sut.viewData.count, requestManager.predefinedReddits.count)
    }

    func testFetchTopReddits_doesNotStoresRedditsLocally_ifErrorOccures() {
        let requestManager = FakeRedditApiRequestManager()
        requestManager.predefinedReddits = [.random(), .random(), .random(), .random(), .random()]
        requestManager.predefinedError = NSError(domain: "", code: 0, userInfo: nil)
        let sut = RedditsListModelImpl(apiManager: requestManager, reddits: [.random()], storage: FakeRedditsListDataStorage())

        sut.fetchTopReddits(with: nil)

        XCTAssertEqual(sut.viewData.count, 1)
    }

    func testFetchTopReddits_doesNotStoresRedditsInStorage_ifErrorOccures() {
        let requestManager = FakeRedditApiRequestManager()
        requestManager.predefinedReddits = [.random(), .random(), .random(), .random(), .random()]
        requestManager.predefinedError = NSError(domain: "", code: 0, userInfo: nil)
        let storage = FakeRedditsListDataStorage()
        let sut = RedditsListModelImpl(apiManager: requestManager, reddits: [.random()], storage: storage)

        sut.fetchTopReddits(with: nil)

        XCTAssert(storage.reddits.isEmpty)
    }

    func testFetchTopReddits_returnsError_ifAny() {
        let error = NSError.random()
        let requestManager = FakeRedditApiRequestManager()
        requestManager.predefinedError = error
        let sut = RedditsListModelImpl(apiManager: requestManager, storage: FakeRedditsListDataStorage())
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
        let sut = RedditsListModelImpl(apiManager: requestManager, storage: FakeRedditsListDataStorage())

        sut.fetchTopReddits(with: nil)

        XCTAssert(sut.viewData.isEmpty)
    }

    func testFetchTopReddits_doesntFetchReddits_ifAnyFetchOperationExists() {
        let requestManager = FakeRedditApiRequestManager()
        let sut = RedditsListModelImpl(apiManager: requestManager, storage: FakeRedditsListDataStorage(), predefinedFetchOperation: EmptyCancellable())

        sut.fetchTopReddits(with: nil)

        XCTAssertEqual(requestManager.fetchTopRedditsCalled, false)
    }

    func testFetchTopRedditsIfNeeded_doesntFetchReddits_ifLocalRedditsNotEmpty() {
        let requestManager = FakeRedditApiRequestManager()
        let sut = RedditsListModelImpl(apiManager: requestManager, reddits: [.random()], storage: FakeRedditsListDataStorage())

        sut.fetchTopRedditsIfNeeded(with: nil)

        XCTAssertEqual(requestManager.fetchTopRedditsCalled, false)
    }

    func testFetchTopRedditsIfNeeded_fetchesReddits_ifLocalRedditsIsEmpty() {
        let requestManager = FakeRedditApiRequestManager()
        let sut = RedditsListModelImpl(apiManager: requestManager, storage: FakeRedditsListDataStorage())

        sut.fetchTopRedditsIfNeeded(with: nil)

        XCTAssertEqual(requestManager.fetchTopRedditsCalled, true)
    }

    func testFetchMoreTopReddits_passCorrectAfterParameter_storedFromLastFetch() {
        let after = String.random()
        let requestManager = FakeRedditApiRequestManager()
        let sut = RedditsListModelImpl(apiManager: requestManager, after: after, storage: FakeRedditsListDataStorage())

        sut.fetchMoreTopReddits(with: nil)

        XCTAssertEqual(requestManager.passedAfter, after)
        XCTAssertNotNil(after)
    }

    func testFetchMoreTopReddits_passCorrectAfterParameter_ifItWasLoadedFromStorage() {
        let requestManager = FakeRedditApiRequestManager()
        let storage = FakeRedditsListDataStorage()
        let after = String.random()
        storage.safe(after: after)
        let sut = RedditsListModelImpl(apiManager: requestManager, storage: storage)
        sut.loadDataFromStorage()

        sut.fetchMoreTopReddits(with: nil)

        XCTAssertEqual(requestManager.passedAfter, storage.getAfter())
    }

    func testFetchMoreTopReddits_doesntFetchReddits_ifAnyFetchOperationExists() {
        let requestManager = FakeRedditApiRequestManager()
        let sut = RedditsListModelImpl(apiManager: requestManager, storage: FakeRedditsListDataStorage(), predefinedFetchOperation: EmptyCancellable())

        sut.fetchMoreTopReddits(with: nil)

        XCTAssertEqual(requestManager.fetchTopRedditsCalled, false)
    }

    func testFetchMoreTopReddits_appendsLocallyStoredRedditsWithReceived_ifAny() {
        let requestManager = FakeRedditApiRequestManager()
        requestManager.predefinedReddits = [.random()]
        let sut = RedditsListModelImpl(apiManager: requestManager, reddits: [.random(), .random()], storage: FakeRedditsListDataStorage())

        sut.fetchMoreTopReddits(with: nil)

        XCTAssertEqual(sut.viewData.count, 3)
    }

    func testFetchMoreTopReddits_doesNotAppendsLocallyStoredRedditsWithReceived_ifErrorOccures() {
        let requestManager = FakeRedditApiRequestManager()
        requestManager.predefinedReddits = [.random()]
        requestManager.predefinedError = NSError(domain: "", code: 0, userInfo: nil)
        let sut = RedditsListModelImpl(apiManager: requestManager, reddits: [.random(), .random()], storage: FakeRedditsListDataStorage())

        sut.fetchMoreTopReddits(with: nil)

        XCTAssertEqual(sut.viewData.count, 2)
    }

    func testFetchMoreTopReddits_returnsError_ifAny() {
        let error = NSError.random()
        let requestManager = FakeRedditApiRequestManager()
        requestManager.predefinedError = error
        let sut = RedditsListModelImpl(apiManager: requestManager, storage: FakeRedditsListDataStorage())
        var receivedError: NSError?

        sut.fetchMoreTopReddits { progress in
            if case let .failure(err) = progress {
                receivedError = err
            }
        }

        XCTAssertEqual(error, receivedError)
    }

    func testImagePreviewModelForReddit_returnsNil_forIndexThatOutOfBounds() {
        let sut = RedditsListModelImpl(apiManager: FakeRedditApiRequestManager(), reddits: [.random()], storage: FakeRedditsListDataStorage())

        let model = sut.imagePreviewModelForReddit(at: 999)

        XCTAssertNil(model)
    }

    func testImagePreviewModelForReddit_returnsModel_forCorrectIndex() {
        let sut = RedditsListModelImpl(apiManager: FakeRedditApiRequestManager(), reddits: [.restrictedRandom(sourceImage: String.random())], storage: FakeRedditsListDataStorage())

        let model = sut.imagePreviewModelForReddit(at: 0)

        XCTAssertNotNil(model)
    }

    func testLoadDataFromStorage_loadsStoredReddits() {
        let storage = FakeRedditsListDataStorage()
        let reddits = [Reddit].random()
        storage.save(reddits: reddits)
        let sut = RedditsListModelImpl(apiManager: FakeRedditApiRequestManager(), storage: storage)

        sut.loadDataFromStorage()

        XCTAssertEqual(sut.viewData.count, reddits.count)
    }
}
