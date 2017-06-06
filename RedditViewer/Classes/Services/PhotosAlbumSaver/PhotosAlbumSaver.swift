//
//  PhotosAlbumSaver.swift
//  RedditViewer
//
//  Created by Vitaliy Malakhovskiy on 6/1/17.
//  Copyright © 2017 Vitalii Malakhovskyi. All rights reserved.
//

import UIKit

// MARK: Protocol

protocol PhotosAlbumSaver {
    func saveImageToCameraRoll(image: UIImage, with completion: ((Error?) -> ())?)
}

// MARK: Implementation

class PhotosAlbumSaverImpl: NSObject, PhotosAlbumSaver {
    private var completion: ((Error?) -> ())?

    func saveImageToCameraRoll(image: UIImage, with completion: ((Error?) -> ())?) {
        self.completion = completion
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    }

    @objc private func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        completion?(error)
        completion = nil
    }
}

// MARK: Factory

class PhotosAlbumSaverFactory {
    static func `default`() -> PhotosAlbumSaver {
        return PhotosAlbumSaverImpl()
    }
}
