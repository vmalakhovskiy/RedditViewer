//
//  RedditsListModel.swift
//  RedditViewer
//
//  Created by Vitaliy Malakhovskiy on 5/28/17.
//  Copyright © 2017 Vitalii Malakhovskyi. All rights reserved.
//

import Foundation

// MARK: Protocol

protocol RedditsListModel {
    var viewData: [RedditsListCellViewData] { get }
    func fetchTopReddits(with progressHandler: ((OperationState<[RedditsListCellViewData], NSError>) -> ())?)
}

// MARK: Implementation

class RedditsListModelImpl: RedditsListModel {
    private let apiManager: RedditApiRequestManager
    private var reddits: [Reddit] {
        didSet {
            viewData = reddits.map(RedditsListCellViewDataFactory.default)
        }
    }
    private var after: String?
    private(set) var viewData = [RedditsListCellViewData]()

    init(
        apiManager: RedditApiRequestManager,
        reddits: [Reddit] = [],
        after: String? = nil
    ) {
        self.apiManager = apiManager
        self.after = after
        self.reddits = reddits
        self.viewData = reddits.map(RedditsListCellViewDataFactory.default)
    }

    func fetchTopReddits(with progressHandler: ((OperationState<[RedditsListCellViewData], NSError>) -> ())?) {
        let _ = apiManager.fetchTopReddits(after: nil) { [weak self] reddits, after, error in
            guard let strongSelf = self else { return }
            if let error = error {
                progressHandler?(.failure(error: error as NSError))
            } else {
                strongSelf.after = after
                strongSelf.reddits = reddits
                progressHandler?(.success(value: strongSelf.viewData))
            }
        }
    }
}

// MARK: Factory

class RedditsListModelFactory {
    static func `default`() -> RedditsListModel {
        return RedditsListModelImpl(
            apiManager: RedditApiRequestManagerFactory.default()
        )
    }
}
