//
//  RedditApiService.swift
//  RedditViewer
//
//  Created by Vitaliy Malakhovskiy on 6/6/17.
//  Copyright © 2017 Vitalii Malakhovskyi. All rights reserved.
//

import Foundation

// MARK: Protocol

protocol RedditApiService {
    func request(token: RedditApiToken, with completion: @escaping (Data?, URLResponse?, Error?) -> ()) -> Cancellable
}

// MARK: Implementation

class RedditApiServiceImpl: RedditApiService {
    private let session: URLSession
    private let predefinedResponse: (Data?, URLResponse?, Error?)?

    init(
        session: URLSession = .shared,
        predefinedResponse: (Data?, URLResponse?, Error?)? = nil
    ) {
        self.session = session
        self.predefinedResponse = predefinedResponse
    }

    func request(token: RedditApiToken, with completion: @escaping (Data?, URLResponse?, Error?) -> ()) -> Cancellable {
        if let response = predefinedResponse {
            completion(response.0, response.1, response.2)
            return EmptyCancellable()
        }
        guard let url = constructUrl(from: token) else {
            return EmptyCancellable()
        }

        let task: URLSessionDataTask = session.dataTask(with: url, completionHandler: completion)
        task.resume()
        return task
    }

    private func constructUrl(from token: RedditApiToken) -> URL? {
        var components = URLComponents()
        components.scheme = token.scheme
        components.host = token.host
        components.path = token.path
        if token.parameters.isNotEmpty {
            components.queryItems = token.parameters.map(URLQueryItem.init)
        }
        return components.url
    }
}

// MARK: Factory

class RedditApiServiceFactory {
    static func `default`() -> RedditApiService {
        return RedditApiServiceImpl(session: .shared, predefinedResponse: nil)
    }
}
