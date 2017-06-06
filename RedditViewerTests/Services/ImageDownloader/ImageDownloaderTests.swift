//
//  ImageDownloader.swift
//  RedditViewer
//
//  Created by Vitaliy Malakhovskiy on 5/30/17.
//  Copyright © 2017 Vitalii Malakhovskyi. All rights reserved.
//

import Foundation
import UIKit
import XCTest
@testable import RedditViewer

class ImageDownloaderTests: XCTestCase {
    var sut: ImageDownloader!
    var dataTaskProvider: DataTaskProvider!
    var imageCache: ImageCache!

    override func setUp() {
        super.setUp()
        imageCache = FakeImageCache()
        dataTaskProvider = FakeDataTaskProvider()
        sut = ImageDownloaderImpl(dataTaskProvider: dataTaskProvider, imageCache: imageCache)
    }

    private func createCachedResponseAndImage(with image: UIImage, url: URL) -> CachedURLResponse {
        return CachedURLResponse(response: URLResponse(url: url, mimeType: nil, expectedContentLength: 0, textEncodingName: nil), data: UIImagePNGRepresentation(image)!)
    }

    func testDownloadImageForUrl_returnsImageFromCache_ifImageExistsThere() {
        let url = URL(string: "www.google.com")!
        let image = UIImage.random()
        let response = createCachedResponseAndImage(with: image, url: url)
        imageCache.storeCachedResponse(response, for: URLRequest(url: url))
        var receivedImage: UIImage?

        let _ = sut.downloadImage(with: url) { img in
            receivedImage = img
        }

        XCTAssert(areImagesEqual(left: receivedImage, right: image))
    }

    func testDownloadImageForUrl_returnsDownloadedImage_ifImageDoesNotExistsInCache_andResponseDataIsNotNilAndStatusCodeIsFine() {
        let url = URL(string: "www.google.com")!
        let image = UIImage.random()
        (dataTaskProvider as! FakeDataTaskProvider).predefinedCompletion = (UIImagePNGRepresentation(image), HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil), nil)
        var receivedImage: UIImage?

        let _ = sut.downloadImage(with: url) { img in
            receivedImage = img
        }

        XCTAssert(areImagesEqual(left: receivedImage, right: image))
    }

    func testDownloadImageForUrl_returnsNil_ifImageDoesNotExistsInCache_andResponseDataIsNil() {
        let url = URL(string: "www.google.com")!
        (dataTaskProvider as! FakeDataTaskProvider).predefinedCompletion = (nil, HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil), nil)
        var receivedImage: UIImage?

        let _ = sut.downloadImage(with: url) { img in
            receivedImage = img
        }

        XCTAssertNil(receivedImage)
    }

    func testDownloadImageForUrl_returnsNil_ifImageDoesNotExistsInCache_andResponseDataIsNotNilButStatusCodeIsNotFine() {
        let url = URL(string: "www.google.com")!
        let image = UIImage.random()
        (dataTaskProvider as! FakeDataTaskProvider).predefinedCompletion = (UIImagePNGRepresentation(image), HTTPURLResponse(url: url, statusCode: 404, httpVersion: nil, headerFields: nil), nil)
        var receivedImage: UIImage?

        let _ = sut.downloadImage(with: url) { img in
            receivedImage = img
        }

        XCTAssertNil(receivedImage)
    }
}

func areImagesEqual(left: UIImage?, right: UIImage?) -> Bool {
    guard
        let lhs = left,
        let rhs = right,
        let lhsData = UIImagePNGRepresentation(lhs),
        let rhsData = UIImagePNGRepresentation(rhs)
    else {
        return false
    }
    return lhsData == rhsData
}
