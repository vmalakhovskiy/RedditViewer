//
//  FakeImageCache.swift
//  RedditViewer
//
//  Created by Vitaliy Malakhovskiy on 5/31/17.
//  Copyright © 2017 Vitalii Malakhovskyi. All rights reserved.
//

import Foundation
@testable import RedditViewer

class FakeImageCache: ImageCache {
    private var storedCachedResponses = [URLRequest: CachedURLResponse]()

    func cachedResponse(for request: URLRequest) -> CachedURLResponse? {
        return storedCachedResponses[request]
    }

    func storeCachedResponse(_ cachedResponse: CachedURLResponse, for request: URLRequest) {
        storedCachedResponses[request] = cachedResponse
    }
}
