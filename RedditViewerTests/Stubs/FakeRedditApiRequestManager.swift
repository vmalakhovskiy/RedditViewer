//
//  FakeRedditApiRequestManager.swift
//  RedditViewer
//
//  Created by Vitaliy Malakhovskiy on 6/1/17.
//  Copyright © 2017 Vitalii Malakhovskyi. All rights reserved.
//

import Foundation
@testable import RedditViewer

class FakeRedditApiRequestManager: RedditApiRequestManager {
    var passedAfter: String?
    var predefinedAfter: String?
    var predefinedReddits = [Reddit]()
    var predefinedError: Error?
    var fetchTopRedditsCalled = false

    func fetchTopReddits(after name: String?, with completion: (([Reddit], String?, Error?) -> ())?) -> Cancellable {
        passedAfter = name
        fetchTopRedditsCalled = true
        completion?(predefinedReddits, predefinedAfter, predefinedError)
        return EmptyCancellable()
    }
}
