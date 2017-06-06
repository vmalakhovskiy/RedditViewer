//
//  DataTaskProvider.swift
//  RedditViewer
//
//  Created by Vitaliy Malakhovskiy on 5/31/17.
//  Copyright © 2017 Vitalii Malakhovskyi. All rights reserved.
//

import Foundation

// MARK: Protocol

protocol DataTaskProvider {
    func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> ()) -> DataTask
}

// MARK: Implementation

extension URLSession: DataTaskProvider {
    func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> ()) -> DataTask {
        let task: URLSessionDataTask = dataTask(with: url, completionHandler: completionHandler)
        return task
    }
}
