//
//  RedditsManager.swift
//  RedditViewer
//
//  Created by Vitaliy Malakhovskiy on 5/25/17.
//  Copyright © 2017 Vitalii Malakhovskyi. All rights reserved.
//

import Foundation

// MARK: Protocol

protocol RedditApiRequestManager {
    func fetchTopReddits(after name: String?, with completion: (([Reddit], String?, Error?) -> ())?) -> Cancellable
}

// MARK: Implementation

class RedditApiRequestManagerImpl: RedditApiRequestManager {
    private let apiService: RedditApiService

    init(apiService: RedditApiService) {
        self.apiService = apiService
    }

    func fetchTopReddits(after name: String?, with completion: (([Reddit], String?, Error?) -> ())?) -> Cancellable {
        let token = RedditApiToken.topReddits(name)
        return apiService.request(token: token) { data, response, error in
            guard
                let data = data,
                let json = try? JSONSerialization.jsonObject(with: data, options: []),
                let responseDictionary = json as? [String: Any],
                let responseDataDictionary = responseDictionary["data"] as? [String: Any],
                let rawReddits = responseDataDictionary["children"] as? [[String: Any]]
            else {
                completion?([], nil, error)
                return
            }
            let reddits = rawReddits
                .flatMap { $0["data"] as? [String: Any] }
                .flatMap(Reddit.init)
            completion?(reddits, responseDataDictionary["after"] as? String, nil)
        }
    }
}

// MARK: Factory

class RedditApiRequestManagerFactory {
    static func `default`() -> RedditApiRequestManager {
        return RedditApiRequestManagerImpl(apiService: RedditApiServiceFactory.default())
    }
}
