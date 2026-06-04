//
//  MarketListEndpoint.swift
//  IMW
//
//  Created by Марат Саляхетдинов on 01.06.2026.
//

import AppNetworkCore
import Foundation

struct MarketListEndpoint: APIEndpoint {
    typealias Response = [APINamespaces.MarketList.Response]

    let method: HTTPMethod = .get
    let path: String = "/coins/markets"
    let queryItems: [URLQueryItem]?

    init(vsCurrency: String = "usd", page: Int = 1, perPage: Int = 50, ids: [String] = []) {
        var queryItems: [URLQueryItem] = [
            .init(name: "vs_currency", value: vsCurrency),
            .init(name: "order", value: "market_cap_desc"),
            .init(name: "per_page", value: String(perPage)),
            .init(name: "page", value: String(page)),
            .init(name: "sparkline", value: "false"),
            .init(name: "price_change_percentage", value: "24h")
        ]

        if ids.isEmpty == false {
            queryItems.append(.init(name: "ids", value: ids.joined(separator: ",")))
        }

        self.queryItems = queryItems
    }
}

extension APINamespaces.MarketList {
    
    struct Response: Decodable {
        let id: String
        let symbol: String
        let name: String
        let image: String?
        let currentPrice: Double?
        let marketCap: Double?
        let marketCapRank: Int?
        let totalVolume: Double?
        let high24h: Double?
        let low24h: Double?
        let priceChange24h: Double?
        let priceChangePercentage24h: Double?
        
        enum CodingKeys: String, CodingKey {
            case id
            case symbol
            case name
            case image
            case currentPrice = "current_price"
            case marketCap = "market_cap"
            case marketCapRank = "market_cap_rank"
            case totalVolume = "total_volume"
            case high24h = "high_24h"
            case low24h = "low_24h"
            case priceChange24h = "price_change_24h"
            case priceChangePercentage24h = "price_change_percentage_24h"
        }
    }
}
