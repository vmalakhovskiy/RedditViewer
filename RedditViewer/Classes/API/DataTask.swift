//
//  DataTask.swift
//  RedditViewer
//
//  Created by Vitaliy Malakhovskiy on 5/31/17.
//  Copyright © 2017 Vitalii Malakhovskyi. All rights reserved.
//

import Foundation

// MARK: Protocol

protocol DataTask: Cancellable {
    func resume()
}

// MARK: Implementation

struct EmptyDataTask: DataTask {
    func resume() {}
    func cancel() {}
}
extension URLSessionDataTask: DataTask {}
