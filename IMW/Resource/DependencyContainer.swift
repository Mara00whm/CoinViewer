//
//  DependencyContainer.swift
//  IMW
//
//  Created by Марат Саляхетдинов on 01.06.2026.
//

import AppImageCore
import AppNetworkCore
import AppStorageCore
import Foundation

protocol DependencyContainerInterface {
    var restClient: any RESTClientInterface { get }
    var imageLoader: any ImageLoaderInterface { get }
    var imageFileStorage: any FileStorage { get }
    var storageClient: any StorageClient { get }
}

struct DependencyContainer: DependencyContainerInterface {

    // MARK: - Public properties

    let restClient: any RESTClientInterface
    let imageLoader: any ImageLoaderInterface
    let imageFileStorage: any FileStorage
    let storageClient: any StorageClient

    // MARK: - Init

    init(restClient: any RESTClientInterface, imageLoader: any ImageLoaderInterface, imageFileStorage: any FileStorage, storageClient: any StorageClient) {
        self.restClient = restClient
        self.imageLoader = imageLoader
        self.imageFileStorage = imageFileStorage
        self.storageClient = storageClient
    }
}
