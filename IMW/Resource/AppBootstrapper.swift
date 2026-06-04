//
//  AppBootstrapper.swift
//  IMW
//
//  Created by Марат Саляхетдинов on 02.06.2026.
//

import AppImageCore
import AppNetworkCore
import AppStorageCore
import CoreData
import Foundation

enum AppBootstrapper {

    // MARK: - Public methods

    static func makeDependencyContainer(marketDataAPIKey: String? = nil) async throws -> DependencyContainer {
        let restClient: RESTClient = makeRESTClient(marketDataAPIKey: marketDataAPIKey)
        let imageFileStorage: LocalFileStorage = try .init(configuration: .init(directory: .caches, folderName: "IMWImages"))
        let imageDataClient: RESTImageDataClient = .init { components in
            .init(baseURL: components)
        }
        let imageLoader: DefaultImageLoader = .init(dataClient: imageDataClient, diskStorage: imageFileStorage)
        let storageClient: CoreDataStorageClient = try await makeStorageClient()

        return .init(
            restClient: restClient,
            imageLoader: imageLoader,
            imageFileStorage: imageFileStorage,
            storageClient: storageClient
        )
    }
}

// MARK: - Private methods

private extension AppBootstrapper {

    static func makeRESTClient(marketDataAPIKey: String?) -> RESTClient {
        let baseURL: URLComponents = .init(string: "https://api.coingecko.com/api/v3")!
        var defaultHeaders: [String: String] = [
            "Accept": "application/json"
        ]

        if let marketDataAPIKey,
           marketDataAPIKey.isEmpty == false {
            defaultHeaders["x-cg-demo-api-key"] = marketDataAPIKey
        }

        let restConfig: RESTConfig = .init(baseURL: baseURL, defaultHeaders: defaultHeaders)
        return .init(config: restConfig)
    }

    static func makeStorageClient() async throws -> CoreDataStorageClient {
        let storageModel: NSManagedObjectModel = IMWStorageModelFactory.makeModel()
        let storageConfiguration: CoreDataConfiguration = .persistent(name: "IMWStorage", managedObjectModel: storageModel, storeURL: try makeStorageURL())
        let storageStack: CoreDataStack = try await .init(configuration: storageConfiguration)
        return .init(stack: storageStack)
    }

    static func makeStorageURL() throws -> URL {
        try FileManager.default
            .url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            .appendingPathComponent("IMWStorage.sqlite")
    }
}
