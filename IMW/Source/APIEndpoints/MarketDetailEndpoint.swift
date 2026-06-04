//
//  MarketDetailEndpoint.swift
//  IMW
//
//  Created by Марат Саляхетдинов on 03.06.2026.
//

import AppNetworkCore
import Foundation

struct MarketDetailEndpoint: APIEndpoint {
    typealias Response = APINamespaces.MarketDetail.Response

    let method: HTTPMethod = .get
    let path: String
    let queryItems: [URLQueryItem]?

    init(id: String) {
        self.path = "/coins/\(id)"
        self.queryItems = [
            .init(name: "localization", value: "false"),
            .init(name: "tickers", value: "false"),
            .init(name: "market_data", value: "true"),
            .init(name: "community_data", value: "true"),
            .init(name: "developer_data", value: "true"),
            .init(name: "sparkline", value: "false")
        ]
    }
}

extension APINamespaces.MarketDetail {

    struct Response: Decodable {
        let id: String
        let symbol: String
        let name: String
        let categories: [String]?
        let description: Description?
        let links: Links?
        let image: Image?
        let marketCapRank: Int?
        let marketData: MarketData?
        let communityData: CommunityData?
        let developerData: DeveloperData?

        enum CodingKeys: String, CodingKey {
            case id
            case symbol
            case name
            case categories
            case description
            case links
            case image
            case marketCapRank = "market_cap_rank"
            case marketData = "market_data"
            case communityData = "community_data"
            case developerData = "developer_data"
        }
    }

    struct Description: Decodable {
        let en: String?
    }

    struct Links: Decodable {
        let homepage: [String]?
        let blockchainSite: [String]?
        let officialForumURL: [String]?
        let reposURL: ReposURL?

        enum CodingKeys: String, CodingKey {
            case homepage
            case blockchainSite = "blockchain_site"
            case officialForumURL = "official_forum_url"
            case reposURL = "repos_url"
        }
    }

    struct ReposURL: Decodable {
        let github: [String]?
    }

    struct Image: Decodable {
        let thumb: String?
        let small: String?
        let large: String?
    }

    struct MarketData: Decodable {
        let currentPrice: [String: Double]?
        let marketCap: [String: Double]?
        let totalVolume: [String: Double]?
        let high24h: [String: Double]?
        let low24h: [String: Double]?
        let ath: [String: Double]?
        let athChangePercentage: [String: Double]?
        let atl: [String: Double]?
        let atlChangePercentage: [String: Double]?
        let priceChange24h: Double?
        let priceChangePercentage24h: Double?
        let priceChangePercentage7d: Double?
        let priceChangePercentage30d: Double?
        let circulatingSupply: Double?
        let totalSupply: Double?
        let maxSupply: Double?

        enum CodingKeys: String, CodingKey {
            case currentPrice = "current_price"
            case marketCap = "market_cap"
            case totalVolume = "total_volume"
            case high24h = "high_24h"
            case low24h = "low_24h"
            case ath
            case athChangePercentage = "ath_change_percentage"
            case atl
            case atlChangePercentage = "atl_change_percentage"
            case priceChange24h = "price_change_24h"
            case priceChangePercentage24h = "price_change_percentage_24h"
            case priceChangePercentage7d = "price_change_percentage_7d"
            case priceChangePercentage30d = "price_change_percentage_30d"
            case circulatingSupply = "circulating_supply"
            case totalSupply = "total_supply"
            case maxSupply = "max_supply"
        }
    }

    struct CommunityData: Decodable {
        let twitterFollowers: Int?
        let redditSubscribers: Int?

        enum CodingKeys: String, CodingKey {
            case twitterFollowers = "twitter_followers"
            case redditSubscribers = "reddit_subscribers"
        }
    }

    struct DeveloperData: Decodable {
        let forks: Int?
        let stars: Int?
        let subscribers: Int?
        let totalIssues: Int?
        let closedIssues: Int?
        let commitCount4Weeks: Int?

        enum CodingKeys: String, CodingKey {
            case forks
            case stars
            case subscribers
            case totalIssues = "total_issues"
            case closedIssues = "closed_issues"
            case commitCount4Weeks = "commit_count_4_weeks"
        }
    }
}
