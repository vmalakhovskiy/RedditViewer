//
//  ImagePreviewModel.swift
//  RedditViewer
//
//  Created by Vitaliy Malakhovskiy on 6/1/17.
//  Copyright © 2017 Vitalii Malakhovskyi. All rights reserved.
//

import XCTest
@testable import RedditViewer

class ImagePreviewModelTests: XCTestCase {
    var imageDownloader: FakeImageDownloader!
    var photosAlbumSaver: FakePhotosAlbumSaver!
    var sourceImageUrl: String!
    var thumbnailImage: UIImage!
    var storedImage: UIImage!
    var fallbackImage: UIImage!
    var sut: ImagePreviewModel!

    override func setUp() {
        super.setUp()
        sourceImageUrl = .random()
        thumbnailImage = .random()
        storedImage = .random()
        fallbackImage = .random()
        imageDownloader = FakeImageDownloader()
        photosAlbumSaver = FakePhotosAlbumSaver()
        sut = ImagePreviewModelImpl(imageDownloader: imageDownloader, sourceImageUrl: sourceImageUrl, photosAlbumSaver: photosAlbumSaver, storedImage: storedImage, fallbackImage: fallbackImage)
    }

    func testGetSourceImage_returnsDownloadedImage_ifExists() {
        let downloadedImage = UIImage.random()
        imageDownloader.predefinedImage = downloadedImage
        var receivedImage: UIImage?

        sut.getSourceImage { img in
            receivedImage = img
        }

        XCTAssertEqual(receivedImage, downloadedImage)
    }

    func testGetSourceImage_returnsFallbackImage_ifImageDoesNotExists() {
        imageDownloader.predefinedImage = nil
        var receivedImage: UIImage?

        sut.getSourceImage { img in
            receivedImage = img
        }

        XCTAssertEqual(receivedImage, fallbackImage)
    }

    func testSaveSourceImageToCameraRoll_returnsError_ifFailedToSaveToPhotosAlbum() {
        photosAlbumSaver.predefinedError = NSError.random()
        var receivedError: NSError?

        sut.saveSourceImageToCameraRoll { err in
            receivedError = err
        }
        XCTAssertNotNil(receivedError)
    }

    func testSaveSourceImageToCameraRoll_returnsNoImageError_ifThereIsNoStoredImage() {
        sut = ImagePreviewModelImpl(imageDownloader: imageDownloader, sourceImageUrl: sourceImageUrl, photosAlbumSaver: photosAlbumSaver, storedImage: nil)
        var receivedError: NSError?

        sut.saveSourceImageToCameraRoll { err in
            receivedError = err
        }

        XCTAssertEqual(receivedError?.code, 666)
    }

    func testSaveSourceImageToCameraRoll_DoesNotReturnsError_ifImageSuccesfullySaved() {
        sut = ImagePreviewModelImpl(imageDownloader: imageDownloader, sourceImageUrl: sourceImageUrl, photosAlbumSaver: photosAlbumSaver, storedImage: UIImage.random())
        var receivedError: NSError?

        sut.saveSourceImageToCameraRoll { err in
            receivedError = err
        }

        XCTAssertNil(receivedError)
    }
}
