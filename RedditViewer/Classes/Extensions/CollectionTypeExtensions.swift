//
//  RedditsListCell.swift
//  RedditViewer
//
//  Created by Vitaliy Malakhovskiy on 5/28/17.
//  Copyright © 2017 Vitalii Malakhovskyi. All rights reserved.
//

import Foundation

extension Collection {
    var isNotEmpty: Bool {
        return !isEmpty
    }
}

extension Collection where Indices.Iterator.Element == Index {
    subscript (safe index: Index) -> Generator.Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
