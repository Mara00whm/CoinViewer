//
//  WatchListWorker.swift
//  IMW
//
//  Created by Марат Саляхетдинов on 04.06.2026.
//

import AppImageCore
import AppNetworkCore
import AppStorageCore
import Foundation
import UIKit

protocol WatchListWorkerInterface {
    func fetchWatchlist(ids: [String]) async throws -> [APINamespaces.MarketList.Response]
    func fetchCachedWatchlist() async throws -> [MarketListDomain]
    func cacheWatchlist(_ domains: [MarketListDomain]) async throws
    func fetchImage(for url: URL) async throws -> UIImage
}

final class WatchListWorker: WatchListWorkerInterface {

    // MARK: - Private properties

    private let restClient: any RESTClientInterface
    private let imageLoader: any ImageLoaderInterface
    private let storageClient: any StorageClient

    // MARK: - Init

    init(restClient: any RESTClientInterface, imageLoader: any ImageLoaderInterface, storageClient: any StorageClient) {
        self.restClient = restClient
        self.imageLoader = imageLoader
        self.storageClient = storageClient
    }

    // MARK: - Public methods

    func fetchWatchlist(ids: [String]) async throws -> [APINamespaces.MarketList.Response] {
        let endpoint: MarketListEndpoint = .init(page: 1, perPage: max(ids.count, 1), ids: ids)
        return try await restClient.request(endpoint)
    }

    func fetchCachedWatchlist() async throws -> [MarketListDomain] {
        try await storageClient.execute(FetchWatchlistAssetsStorageEndpoint())
    }

    func cacheWatchlist(_ domains: [MarketListDomain]) async throws {
        try await storageClient.execute(SaveWatchlistAssetsStorageEndpoint(domains: domains))
    }

    func fetchImage(for url: URL) async throws -> UIImage {
        let request: ImageRequest = .init(url: url, cachePolicy: .memoryAndDisk)
        return try await imageLoader.loadImage(for: request)
    }
}
