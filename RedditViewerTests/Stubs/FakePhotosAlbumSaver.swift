//
//  FakePhotosAlbumSaver.swift
//  RedditViewer
//
//  Created by Vitaliy Malakhovskiy on 6/1/17.
//  Copyright © 2017 Vitalii Malakhovskyi. All rights reserved.
//

import Foundation
import UIKit
@testable import RedditViewer

class FakePhotosAlbumSaver: PhotosAlbumSaver {
    var providedImage: UIImage?
    var predefinedError: Error?
    
    func saveImageToCameraRoll(image: UIImage, with completion: ((Error?) -> ())?) {
        providedImage = image
        completion?(predefinedError)
    }
}
