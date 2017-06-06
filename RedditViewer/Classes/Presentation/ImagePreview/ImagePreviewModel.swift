//
//  ImagePreviewModel.swift
//  RedditViewer
//
//  Created by Vitaliy Malakhovskiy on 6/1/17.
//  Copyright © 2017 Vitalii Malakhovskyi. All rights reserved.
//

import Foundation
import UIKit

// MARK: Protocol

protocol ImagePreviewModel {
    var sourceImageUrl: String { get }
    func getSourceImage(with completion: ((UIImage?) -> ())?)
    func cancelImageDownloadingIfNeeded()
    func saveSourceImageToCameraRoll(with completion: ((NSError?) -> ())?)
}

// MARK: Implementation

class ImagePreviewModelImpl: ImagePreviewModel {
    private let imageDownloader: ImageDownloader
    private let photosAlbumSaver: PhotosAlbumSaver
    private var storedImage: UIImage?
    private let fallbackImage: UIImage
    private var currentDownloadOperation: Cancellable?
    let sourceImageUrl: String

    init(imageDownloader: ImageDownloader, sourceImageUrl: String, photosAlbumSaver: PhotosAlbumSaver, storedImage: UIImage?, fallbackImage: UIImage = #imageLiteral(resourceName: "EmptyImage")) {
        self.imageDownloader = imageDownloader
        self.sourceImageUrl = sourceImageUrl
        self.photosAlbumSaver = photosAlbumSaver
        self.storedImage = storedImage
        self.fallbackImage = fallbackImage
    }

    func getSourceImage(with completion: ((UIImage?) -> ())?) {
        if let url = URL(string: sourceImageUrl) {
            currentDownloadOperation = imageDownloader.downloadImage(with: url) { [weak self] image in
                guard let strongSelf = self else { return }
                strongSelf.currentDownloadOperation = nil
                strongSelf.storedImage = image
                completion?(image ?? strongSelf.fallbackImage)
            }
        } else {
            completion?(nil)
        }
    }

    func cancelImageDownloadingIfNeeded() {
        currentDownloadOperation?.cancel()
    }

    func saveSourceImageToCameraRoll(with completion: ((NSError?) -> ())?) {
        if let image = storedImage {
            photosAlbumSaver.saveImageToCameraRoll(image: image) { [weak self] error in
                guard let strongSelf = self else { return }
                if let error = error {
                    let returnError = strongSelf.internalError(withUnderlying: error)
                    completion?(returnError)
                } else {
                    completion?(nil)
                }
            }
        } else {
            completion?(internalError())
        }
    }

    private func internalError(withUnderlying error: Error? = nil) -> NSError {
        return NSError(
            domain: "com.vm.redditViewer",
            code: 666,
            userInfo: [
                NSLocalizedDescriptionKey: "Failed to save image to photos album",
                NSLocalizedRecoverySuggestionErrorKey: "Internal error",
                NSUnderlyingErrorKey: error ?? NSNull()
            ]
        )
    }
}

// MARK: Factory

class ImagePreviewModelFactory {
    static func `default`(sourceImageUrl: String) -> ImagePreviewModel {
        return ImagePreviewModelImpl(
            imageDownloader: ImageDownloaderFactory.default(),
            sourceImageUrl: sourceImageUrl,
            photosAlbumSaver: PhotosAlbumSaverFactory.default(),
            storedImage: nil
        )
    }
}
