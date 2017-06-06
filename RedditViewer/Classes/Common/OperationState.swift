//
//  OperationState.swift
//  RedditViewer
//
//  Created by Vitaliy Malakhovskiy on 6/5/17.
//  Copyright © 2017 Vitalii Malakhovskyi. All rights reserved.
//

import Foundation

enum OperationState<V, E: Error> {
    case inProgress
    case success(value: V)
    case failure(error: E)
}
