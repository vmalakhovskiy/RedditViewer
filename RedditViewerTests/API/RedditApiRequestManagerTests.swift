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

    func testFetchTopReddits_returnsNoReddits_fromInvalidResponse() {
        let sut = createSut(with: [:])

        let _ = sut.fetchTopReddits(after: nil) { reddits, _, _ in
            XCTAssertEqual(reddits.count, 0)
        }
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

        let _ = sut.fetchTopReddits(after: nil) { reddits, _, _ in
            XCTAssertEqual(reddits.count, 3)
        }
    }

    func testFetchTopReddits_returnsEmptyAfter_fromInvalidResponse() {
        let sut = createSut(with: [:])

        let _ = sut.fetchTopReddits(after: nil) { _, after, _ in
            XCTAssertNil(after)
        }
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

        let _ = sut.fetchTopReddits(after: nil) { _, receivedAfter, _ in
            XCTAssertEqual(receivedAfter, after)
        }
    }

    func testFetchTopReddits_returnsError_ifOccured() {
        let error = NSError(domain: "com.redditViewer.testError", code: 666, userInfo: nil)
        let service = RedditApiServiceImpl(predefinedResponse: (nil, nil, error))
        let sut = RedditApiRequestManagerImpl(apiService: service)

        let _ = sut.fetchTopReddits(after: nil) { _, _, receivedError in
            XCTAssertEqual(receivedError as NSError?, error)
        }
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
