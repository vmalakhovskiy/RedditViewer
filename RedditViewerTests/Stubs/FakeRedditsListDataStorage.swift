//
//  FakeRedditsListDataStorage.swift
//  RedditViewer
//
//  Created by Vitaliy Malakhovskiy on 6/4/17.
//  Copyright © 2017 Vitalii Malakhovskyi. All rights reserved.
//

import Foundation
@testable import RedditViewer

class FakeRedditsListDataStorage: RedditsListDataStorage {
    var reddits = [Reddit]()
    var after: String?

    func save(reddits: [Reddit]) {
        self.reddits = reddits
    }

    func safe(after: String) {
        self.after = after
    }

    func getReddits() -> [Reddit] {
        return reddits
    }

    func getAfter() -> String? {
        return after
    }

    func cleanupData() {
        reddits = []
    }
}
