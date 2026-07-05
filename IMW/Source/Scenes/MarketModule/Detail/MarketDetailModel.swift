//
//  MarketDetailModel.swift
//  IMW
//
//  Created by Марат Саляхетдинов on 03.06.2026.
//

import AppImageCore
import AppNetworkCore
import AppStorageCore
import Foundation
import UIKit

enum MarketDetailModel {

    struct ViewModel {
        let title: String
        let subtitle: String
        let rankText: String
        let image: UIImage?
        let priceText: String
        let priceChangeText: String
        let priceChangeColor: UIColor
        let chart: ChartViewModel
        let stats: [StatViewModel]
        let links: [LinkViewModel]
        let categoriesText: String
        let descriptionText: String
        let isInWatchlist: Bool
    }

    struct ChartViewModel {
        let rangeTitles: [String]
        let selectedRangeIndex: Int
        let points: [ChartPointViewModel]
        let lineColor: UIColor
    }

    struct ChartPointViewModel: Identifiable {
        let id: Date
        let date: Date
        let price: Double
    }

    struct StatViewModel {
        let title: String
        let value: String
    }

    struct LinkViewModel {
        let title: String
        let url: URL
    }

    struct Input {
        let id: String
    }

    struct Dependencies {
        let restClient: any RESTClientInterface
        let imageLoader: any ImageLoaderInterface
        let storageClient: any StorageClient
    }
}
