//
//  MarketListWorker.swift
//  IMW
//
//  Created by Марат Саляхетдинов on 01.06.2026.
//

import AppImageCore
import AppNetworkCore
import AppStorageCore
import Foundation
import UIKit

protocol MarketListWorkerInterface {
    func fetchMarketList(page: Int, perPage: Int) async throws -> [APINamespaces.MarketList.Response]
    func fetchCachedMarketList() async throws -> [MarketListDomain]
    func cacheMarketList(_ domains: [MarketListDomain], shouldReplaceExistingCache: Bool) async throws
    func fetchImage(for url: URL) async throws -> UIImage
}

final class MarketListWorker: MarketListWorkerInterface {

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

    func fetchMarketList(page: Int = 1, perPage: Int = 50) async throws -> [APINamespaces.MarketList.Response] {
        let endpoint: MarketListEndpoint = .init(page: page, perPage: perPage)
        return try await restClient.request(endpoint)
    }

    func fetchCachedMarketList() async throws -> [MarketListDomain] {
        try await storageClient.execute(FetchMarketAssetsStorageEndpoint())
    }

    func cacheMarketList(_ domains: [MarketListDomain], shouldReplaceExistingCache: Bool) async throws {
        try await storageClient.execute(SaveMarketAssetsStorageEndpoint(domains: domains, shouldReplaceExistingCache: shouldReplaceExistingCache))
    }

    func fetchImage(for url: URL) async throws -> UIImage {
        let request: ImageRequest = .init(url: url, cachePolicy: .memoryAndDisk)
        return try await imageLoader.loadImage(for: request)
    }
}
