//
//  FakeImageDownloader.swift
//  RedditViewer
//
//  Created by Vitaliy Malakhovskiy on 6/1/17.
//  Copyright © 2017 Vitalii Malakhovskyi. All rights reserved.
//

import Foundation
import UIKit
@testable import RedditViewer

class FakeImageDownloader: ImageDownloader {
    var passedUrl: URL?
    var predefinedImage: UIImage?

    func downloadImage(with url: URL, completion: ((UIImage?) -> ())?) -> Cancellable {
        passedUrl = url
        completion?(predefinedImage)
        return EmptyCancellable()
    }
}
