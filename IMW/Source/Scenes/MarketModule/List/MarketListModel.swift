//
//  MarketListModel.swift
//  IMW
//
//  Created by Марат Саляхетдинов on 01.06.2026.
//

import AppImageCore
import AppNetworkCore
import AppStorageCore
import Foundation
import UIKit

enum MarketListModel {

    struct ViewModel {
        let items: [ItemViewModel]
    }

    struct ItemViewModel {
        let id: String
        let title: String
        let subtitle: String
        let priceText: String
        let priceChangeText: String
        let priceChangeColor: UIColor
        let rankText: String
        let image: UIImage?
    }

    struct InjectionModel {
        let restClient: any RESTClientInterface
        let imageLoader: any ImageLoaderInterface
        let storageClient: any StorageClient
        let coordinator: any MarketCoordinatorInterface
    }
}
