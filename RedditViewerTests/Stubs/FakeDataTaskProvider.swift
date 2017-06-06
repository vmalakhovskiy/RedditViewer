//
//  FakeDataTaskProvider.swift
//  RedditViewer
//
//  Created by Vitaliy Malakhovskiy on 5/31/17.
//  Copyright © 2017 Vitalii Malakhovskyi. All rights reserved.
//

import Foundation
@testable import RedditViewer

class FakeDataTaskProvider: DataTaskProvider {
    var passedURL: URL?
    var predefinedCompletion: (Data?, URLResponse?, Error?)?

    func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> ()) -> DataTask {
        if let predefined = predefinedCompletion {
            completionHandler(predefined.0, predefined.1, predefined.2)
        }
        return EmptyDataTask()
    }
}
