//
//  RedditViewerTests.swift
//  RedditViewerTests
//
//  Created by Vitaliy Malakhovskiy on 5/25/17.
//  Copyright © 2017 Vitalii Malakhovskyi. All rights reserved.
//

import XCTest
@testable import RedditViewer

class FakeApiService: RedditApiService {
    var passedToken: RedditApiToken?

    func request(token: RedditApiToken, with completion: @escaping (Data?, URLResponse?, Error?) -> ()) -> Cancellable {
        passedToken = token
        return EmptyCancellable()
    }
}

class RedditApiRequestManagerTests: XCTestCase {
    func createSut(with service: RedditApiService) -> RedditApiRequestManager {
        return RedditApiRequestManagerImpl(apiService: service)
    }

    func createSut(with responseDictionary: [String: Any]) -> RedditApiRequestManager {
        let service = RedditApiServiceImpl(predefinedResponse: (try? JSONSerialization.data(withJSONObject: responseDictionary, options: []), nil, nil))
        return createSut(with: service)
    }

    func testFetchTopReddits_returnsEmptyReddits_fromInvalidResponse() {
        let sut = createSut(with: [:])

        var receivedReddits = [Reddit.random()]

        let _ = sut.fetchTopReddits(after: nil) { reddits, _, _ in
            receivedReddits = reddits
        }

        XCTAssertEqual(receivedReddits.count, 0)
    }

    func testFetchTopReddits_returnsParsedReddits_fromValidResponse() {
        let sut = createSut(with: [
            "data": [
                "children": [
                    [
                        "data": randomRedditDictionary()
                    ],
                    [
                        "data": randomRedditDictionary()
                    ],
                    [
                        "data": randomRedditDictionary()
                    ]
                ]
            ]
        ])
        var receivedReddits = [Reddit]()

        let _ = sut.fetchTopReddits(after: nil) { reddits, _, _ in
            receivedReddits = reddits
        }

        XCTAssertEqual(receivedReddits.count, 3)
    }

    func testFetchTopReddits_returnsEmptyAfter_fromInvalidResponse() {
        let sut = createSut(with: [:])

        var receivedAfter: String? = String.random()
        let _ = sut.fetchTopReddits(after: nil) { _, after, _ in
            receivedAfter = after
        }

        XCTAssertNil(receivedAfter)
    }

    func testFetchTopReddits_returnsCorrectAfter_fromValidResponse() {
        let after = String.random()
        let sut = createSut(with: [
            "data": [
                "children": [
                    [
                        "data": randomRedditDictionary()
                    ]
                ],
                "after": after
            ]
        ])
        var receivedAfter: String? = nil

        let _ = sut.fetchTopReddits(after: nil) { _, aft, _ in
            receivedAfter = aft
        }

        XCTAssertEqual(receivedAfter, after)
    }

    func testFetchTopReddits_returnsError_ifOccured() {
        let error = NSError.random()
        let service = RedditApiServiceImpl(predefinedResponse: (nil, nil, error))
        let sut = RedditApiRequestManagerImpl(apiService: service)
        var receivedError: NSError? = nil

        let _ = sut.fetchTopReddits(after: nil) { _, _, err in
            receivedError = err as NSError?
        }

        XCTAssertEqual(receivedError, error)
    }

    func testFetchTopReddits_passCorrectTokenParameter_ifAfterParameterIsNil() {
        let service = FakeApiService()
        let sut = createSut(with: service)

        let _ = sut.fetchTopReddits(after: nil, with: nil)

        XCTAssertEqual(service.passedToken, RedditApiToken.topReddits(nil))
    }

    func testFetchTopReddits_passCorrectTokenParameter_ifAfterParameterIsNotNil() {
        let after = String.random()
        let service = FakeApiService()
        let sut = createSut(with: service)

        let _ = sut.fetchTopReddits(after: after, with: nil)

        XCTAssertEqual(service.passedToken, RedditApiToken.topReddits(after))
    }
}
