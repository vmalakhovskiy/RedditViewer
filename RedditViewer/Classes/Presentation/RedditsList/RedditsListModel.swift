//
//  RedditsListModel.swift
//  RedditViewer
//
//  Created by Vitaliy Malakhovskiy on 5/28/17.
//  Copyright © 2017 Vitalii Malakhovskyi. All rights reserved.
//

import Foundation

enum RedditsListViewData {
    case reddit(RedditsListCellViewData)
    case loadMore
}

// MARK: Protocol

protocol RedditsListModel {
    var viewData: [RedditsListViewData] { get }
    func loadDataFromStorage()
    func fetchTopRedditsIfNeeded(with progressHandler: ((OperationState<[RedditsListViewData], NSError>) -> ())?)
    func fetchTopReddits(with progressHandler: ((OperationState<[RedditsListViewData], NSError>) -> ())?)
    func fetchMoreTopReddits(with progressHandler: ((OperationState<[RedditsListViewData], NSError>) -> ())?)
    func imagePreviewModelForReddit(at index: Int) -> ImagePreviewModel?
}

// MARK: Implementation

class RedditsListModelImpl: RedditsListModel {
    private let storage: RedditsListDataStorage
    private let apiManager: RedditApiRequestManager
    private var reddits: [Reddit] {
        didSet {
            viewData = viewData(with: reddits, hasMoreData: after != nil && reddits.isNotEmpty)
        }
    }
    private var after: String?
    private var currentFetchOperation: Cancellable?
    private(set) var viewData = [RedditsListViewData]()

    init(
        apiManager: RedditApiRequestManager,
        reddits: [Reddit] = [],
        after: String? = nil,
        storage: RedditsListDataStorage,
        predefinedFetchOperation: Cancellable? = nil
    ) {
        self.apiManager = apiManager
        self.storage = storage
        self.after = after
        self.reddits = reddits
        self.viewData = viewData(with: reddits, hasMoreData: after != nil && reddits.isNotEmpty)
        self.currentFetchOperation = predefinedFetchOperation
    }

    func loadDataFromStorage() {
        after = storage.getAfter()
        reddits = storage.getReddits()
    }

    func saveDataToStorage() {
        if let after = after {
            storage.safe(after: after)
        }
        storage.save(reddits: reddits)
    }

    func fetchTopRedditsIfNeeded(with progressHandler: ((OperationState<[RedditsListViewData], NSError>) -> ())?) {
        if reddits.isEmpty {
            fetchTopReddits(with: progressHandler)
        }
    }

    func fetchTopReddits(with progressHandler: ((OperationState<[RedditsListViewData], NSError>) -> ())?) {
        guard currentFetchOperation == nil else {
            return
        }
        progressHandler?(.inProgress)
        currentFetchOperation = apiManager.fetchTopReddits(after: nil) { [weak self] reddits, after, error in
            guard let strongSelf = self else { return }
            strongSelf.currentFetchOperation = nil
            if let error = error {
                progressHandler?(.failure(error: error as NSError))
            } else {
                strongSelf.after = after
                strongSelf.reddits = reddits
                strongSelf.saveDataToStorage()
                progressHandler?(.success(value: strongSelf.viewData))
            }
        }
    }

    func fetchMoreTopReddits(with progressHandler: ((OperationState<[RedditsListViewData], NSError>) -> ())?) {
        guard currentFetchOperation == nil else {
            return
        }
        progressHandler?(.inProgress)
        currentFetchOperation = apiManager.fetchTopReddits(after: after) { [weak self] reddits, after, error in
            guard let strongSelf = self else { return }
            strongSelf.currentFetchOperation = nil
            if let error = error {
                progressHandler?(.failure(error: error as NSError))
            } else {
                strongSelf.after = after
                strongSelf.reddits += reddits
                strongSelf.saveDataToStorage()
                progressHandler?(.success(value: strongSelf.viewData))
            }
        }
    }

    func imagePreviewModelForReddit(at index: Int) -> ImagePreviewModel? {
        guard
            let reddit = reddits[safe: index],
            let imageUrl = reddit.sourceImage
        else {
            return nil
        }
        return ImagePreviewModelFactory.default(sourceImageUrl: imageUrl)
    }

    private func viewData(with reddits:[Reddit], hasMoreData: Bool) -> [RedditsListViewData] {
        let data = reddits.map { RedditsListViewData.reddit(RedditsListCellViewDataFactory.default(reddit: $0)) }
        return hasMoreData ? data + [.loadMore] : data
    }
}

// MARK: Factory

class RedditsListModelFactory {
    static func `default`() -> RedditsListModel {
        return RedditsListModelImpl(
            apiManager: RedditApiRequestManagerFactory.default(),
            storage: RedditsListDataStorageFactory.default()
        )
    }
}
