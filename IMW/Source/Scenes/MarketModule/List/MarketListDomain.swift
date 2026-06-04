//
//  MarketListDomain.swift
//  IMW
//
//  Created by Марат Саляхетдинов on 02.06.2026.
//

import Foundation

struct MarketListDomain: Sendable {
    let id: String
    let symbol: String
    let name: String
    let imageURL: URL?
    let currentPrice: Double?
    let marketCap: Double?
    let marketCapRank: Int?
    let totalVolume: Double?
    let high24h: Double?
    let low24h: Double?
    let priceChange24h: Double?
    let priceChangePercentage24h: Double?
}
