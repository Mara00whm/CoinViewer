//
//  MarketDetailWorker.swift
//  IMW
//
//  Created by Марат Саляхетдинов on 03.06.2026.
//

import AppImageCore
import AppNetworkCore
import AppStorageCore
import Foundation
import UIKit

protocol MarketDetailWorkerInterface {
    func fetchMarketDetail(id: String) async throws -> APINamespaces.MarketDetail.Response
    func fetchMarketChart(id: String, range: MarketChartRange) async throws -> APINamespaces.MarketChart.Response
    func fetchCachedMarketDetail(id: String) async throws -> MarketDetailDomain?
    func fetchCachedMarketChart(id: String, range: MarketChartRange) async throws -> [MarketChartPointDomain]
    func cacheMarketDetail(_ domain: MarketDetailDomain) async throws
    func cacheMarketChart(_ points: [MarketChartPointDomain], coinID: String, range: MarketChartRange) async throws
    func isWatchlistAssetSaved(id: String) async throws -> Bool
    func saveWatchlistAsset(_ domain: MarketListDomain) async throws
    func deleteWatchlistAsset(id: String) async throws
    func fetchImage(for url: URL) async throws -> UIImage
}

final class MarketDetailWorker: MarketDetailWorkerInterface {

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

    func fetchMarketDetail(id: String) async throws -> APINamespaces.MarketDetail.Response {
        let endpoint: MarketDetailEndpoint = .init(id: id)
        return try await restClient.request(endpoint)
    }

    func fetchMarketChart(id: String, range: MarketChartRange) async throws -> APINamespaces.MarketChart.Response {
        let endpoint: MarketChartEndpoint = .init(id: id, range: range)
        return try await restClient.request(endpoint)
    }

    func fetchCachedMarketDetail(id: String) async throws -> MarketDetailDomain? {
        try await storageClient.execute(FetchMarketDetailStorageEndpoint(id: id))
    }

    func fetchCachedMarketChart(id: String, range: MarketChartRange) async throws -> [MarketChartPointDomain] {
        try await storageClient.execute(FetchMarketChartStorageEndpoint(coinID: id, range: range))
    }

    func cacheMarketDetail(_ domain: MarketDetailDomain) async throws {
        try await storageClient.execute(SaveMarketDetailStorageEndpoint(domain: domain))
    }

    func cacheMarketChart(_ points: [MarketChartPointDomain], coinID: String, range: MarketChartRange) async throws {
        try await storageClient.execute(SaveMarketChartStorageEndpoint(coinID: coinID, range: range, points: points))
    }

    func isWatchlistAssetSaved(id: String) async throws -> Bool {
        try await storageClient.execute(IsWatchlistAssetSavedStorageEndpoint(id: id))
    }

    func saveWatchlistAsset(_ domain: MarketListDomain) async throws {
        try await storageClient.execute(SaveWatchlistAssetStorageEndpoint(domain: domain))
    }

    func deleteWatchlistAsset(id: String) async throws {
        try await storageClient.execute(DeleteWatchlistAssetStorageEndpoint(id: id))
    }

    func fetchImage(for url: URL) async throws -> UIImage {
        let request: ImageRequest = .init(url: url, cachePolicy: .memoryAndDisk)
        return try await imageLoader.loadImage(for: request)
    }
}
