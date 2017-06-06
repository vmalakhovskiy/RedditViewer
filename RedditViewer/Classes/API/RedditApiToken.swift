//
//  RedditApiToken.swift
//  RedditViewer
//
//  Created by Vitaliy Malakhovskiy on 6/6/17.
//  Copyright © 2017 Vitalii Malakhovskyi. All rights reserved.
//

import Foundation

// MARK: Protocol

protocol TargetType {
    var host: String { get }
    var scheme: String { get }
    var parameters: [String: String?] { get }
    var path: String { get }
}

// MARK: Implementation

enum RedditApiToken {
    case topReddits(String?)
}

extension RedditApiToken: TargetType {
    var scheme: String {
        return "https"
    }

    var host: String {
        return "www.reddit.com"
    }

    var path: String {
        return "/top.json"
    }

    var parameters: [String : String?] {
        switch self {
        case .topReddits(let after): return ["count": "50", "after": after]
        }
    }
}

extension RedditApiToken: Equatable {}

func == (lhs: RedditApiToken, rhs: RedditApiToken) -> Bool {
    switch (lhs, rhs) {
    case let (.topReddits(left), .topReddits(right)): return left == right
    }
}
