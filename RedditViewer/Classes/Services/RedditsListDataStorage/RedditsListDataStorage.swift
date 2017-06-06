//
//  RedditsListDataStorage.swift
//  RageOn
//
//  Created by Vitaliy Malakhovskiy on 3/21/17.
//  Copyright © 2017 . All rights reserved.
//

import Foundation

// MARK: Protocol

protocol RedditsListDataStorage {
    func save(reddits: [Reddit])
    func safe(after: String)
    func getReddits() -> [Reddit]
    func getAfter() -> String?
    func cleanupData()
}

// MARK: Implementation

class RedditsListDataStorageImpl: RedditsListDataStorage {
    private let userDefaults: UserDefaults
    static let redditsStorageKey = "Reddits"
    static let afterStorageKey = "After"

    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }

    func save(reddits: [Reddit]) {
        userDefaults.set(reddits.map { $0.dictionaryRepresentation() }, forKey: RedditsListDataStorageImpl.redditsStorageKey)
        userDefaults.synchronize()
    }

    func safe(after: String) {
        userDefaults.set(after, forKey: RedditsListDataStorageImpl.afterStorageKey)
        userDefaults.synchronize()
    }

    func getReddits() -> [Reddit] {
        guard let reddits = userDefaults.object(forKey: RedditsListDataStorageImpl.redditsStorageKey) as? [[AnyHashable: Any]] else {
            return []
        }
        return reddits
            .map(Reddit.init)
            .flatMap { $0 }
    }

    func getAfter() -> String? {
        return userDefaults.string(forKey: RedditsListDataStorageImpl.afterStorageKey)
    }

    func cleanupData() {
        userDefaults.removeObject(forKey: RedditsListDataStorageImpl.redditsStorageKey)
        userDefaults.removeObject(forKey: RedditsListDataStorageImpl.afterStorageKey)
        userDefaults.synchronize()
    }
}

// MARK: Factory

class RedditsListDataStorageFactory {
    static func `default`() -> RedditsListDataStorage {
        return RedditsListDataStorageImpl()
    }
}
