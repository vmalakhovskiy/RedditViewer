//
//  ImageCache.swift
//  RedditViewer
//
//  Created by Vitaliy Malakhovskiy on 5/31/17.
//  Copyright © 2017 Vitalii Malakhovskyi. All rights reserved.
//

import Foundation

// MARK: Protocol

protocol ImageCache {
    func cachedResponse(for request: URLRequest) -> CachedURLResponse?
    func storeCachedResponse(_ cachedResponse: CachedURLResponse, for request: URLRequest)
}

// MARK: Implementation

extension URLCache: ImageCache {}
