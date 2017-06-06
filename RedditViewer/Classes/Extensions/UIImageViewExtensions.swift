//
//  UIImageViewExtensions.swift
//  RedditViewer
//
//  Created by Vitaliy Malakhovskiy on 6/5/17.
//  Copyright © 2017 Vitalii Malakhovskyi. All rights reserved.
//

import UIKit

extension UIImageView {
    func aspectFitImageSize() -> CGSize? {
        guard let aspectRatio = image?.size else {
            return nil
        }
        return CGSizeAspectFit(aspectRatio: aspectRatio, boundingSize: bounds.size)
    }

    private func CGSizeAspectFit(aspectRatio:CGSize, boundingSize:CGSize) -> CGSize {
        var aspectFitSize = boundingSize
        let mW = boundingSize.width / aspectRatio.width
        let mH = boundingSize.height / aspectRatio.height
        if mH < mW {
            aspectFitSize.width = mH * aspectRatio.width
        } else if mW < mH {
            aspectFitSize.height = mW * aspectRatio.height
        }
        return aspectFitSize
    }
}
