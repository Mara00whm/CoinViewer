//
//  WatchListModel.swift
//  IMW
//
//  Created by Марат Саляхетдинов on 01.06.2026.
//

import AppImageCore
import AppNetworkCore
import AppStorageCore

enum WatchListModel {

    struct ViewModel {
        let items: [MarketListModel.ItemViewModel]
        let isEmpty: Bool
    }

    struct InjectionModel {
        let restClient: any RESTClientInterface
        let imageLoader: any ImageLoaderInterface
        let storageClient: any StorageClient
        let coordinator: any WatchlistCoordinatorInterface
    }
}
