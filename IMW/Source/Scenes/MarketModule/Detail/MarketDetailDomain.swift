//
//  MarketDetailDomain.swift
//  IMW
//
//  Created by Марат Саляхетдинов on 03.06.2026.
//

import Foundation

struct MarketDetailDomain: Sendable {
    let id: String
    let symbol: String
    let name: String
    let rank: Int?
    let imageURL: URL?
    let description: String?
    let homepageURL: URL?
    let githubURL: URL?
    let categories: [String]
    let currentPrice: Double?
    let marketCap: Double?
    let totalVolume: Double?
    let high24h: Double?
    let low24h: Double?
    let ath: Double?
    let athChangePercentage: Double?
    let atl: Double?
    let atlChangePercentage: Double?
    let priceChange24h: Double?
    let priceChangePercentage24h: Double?
    let priceChangePercentage7d: Double?
    let priceChangePercentage30d: Double?
    let circulatingSupply: Double?
    let totalSupply: Double?
    let maxSupply: Double?
    let twitterFollowers: Int?
    let redditSubscribers: Int?
    let githubStars: Int?
    let githubForks: Int?
    let githubSubscribers: Int?
    let totalIssues: Int?
    let closedIssues: Int?
    let commitCount4Weeks: Int?
    let updatedAt: Date?
}

struct MarketChartPointDomain: Sendable {
    let date: Date
    let price: Double
    let marketCap: Double?
    let totalVolume: Double?
}
