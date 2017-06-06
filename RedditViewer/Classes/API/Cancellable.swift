//
//  Cancellable.swift
//  RedditViewer
//
//  Created by Vitaliy Malakhovskiy on 6/6/17.
//  Copyright © 2017 Vitalii Malakhovskyi. All rights reserved.
//

import Foundation

// MARK: Protocol

protocol Cancellable {
    func cancel()
}

// MARK: Implementation

extension URLSessionDataTask: Cancellable {}

struct EmptyCancellable: Cancellable {
    func cancel() {}
}
