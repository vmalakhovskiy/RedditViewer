//
//  ImageDownloader.swift
//  RedditViewer
//
//  Created by Vitaliy Malakhovskiy on 5/30/17.
//  Copyright © 2017 Vitalii Malakhovskyi. All rights reserved.
//

import Foundation
import UIKit

// MARK: Protocol

protocol ImageDownloader {
    func downloadImage(with url: URL, completion: ((UIImage?) -> ())?) -> Cancellable
}

// MARK: Implementation

class ImageDownloaderImpl: ImageDownloader {
    private let dataTaskProvider: DataTaskProvider
    private let imageCache: ImageCache

    init(dataTaskProvider: DataTaskProvider, imageCache: ImageCache) {
        self.dataTaskProvider = dataTaskProvider
        self.imageCache = imageCache
    }

    func downloadImage(with url: URL, completion: ((UIImage?) -> ())?) -> Cancellable {
        let request = URLRequest(url: url)
        if let response = imageCache.cachedResponse(for: request) {
            let image = UIImage(data: response.data)
            completion?(image)
            return EmptyCancellable()
        }
        let task = dataTaskProvider.dataTask(with: url) { [weak self] (data, response, error) in
            guard let strongSelf = self else {
                completion?(nil)
                return
            }
            if let data = data, let httpResponse = response as? HTTPURLResponse, 200...299 ~= httpResponse.statusCode {
                strongSelf.imageCache.storeCachedResponse(CachedURLResponse(response: httpResponse, data: data), for: request)
                completion?(UIImage(data: data))
            } else {
                completion?(nil)
            }
        }
        task.resume()
        return task
    }
}

// MARK: Factory

class ImageDownloaderFactory {
    static func `default`() -> ImageDownloader {
        let cache = URLCache(
            memoryCapacity: 128 * 1024 * 1024,
            diskCapacity: 128 * 1024 * 1024,
            diskPath: "com.vm.redditViewer.imageCache"
        )
        let config = URLSessionConfiguration.default
        config.requestCachePolicy = .returnCacheDataElseLoad
        config.urlCache = cache
        let session = URLSession(configuration: config)
        return ImageDownloaderImpl(dataTaskProvider: session, imageCache: cache)
    }
}
