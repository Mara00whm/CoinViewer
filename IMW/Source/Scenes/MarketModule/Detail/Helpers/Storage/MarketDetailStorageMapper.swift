//
//  MarketDetailStorageMapper.swift
//  IMW
//
//  Created by Марат Саляхетдинов on 03.06.2026.
//

import Foundation

enum MarketDetailStorageMapper {

    // MARK: - Public methods

    static func configure(_ entity: MarketDetailEntity, with domain: MarketDetailDomain) {
        entity.id = domain.id
        entity.symbol = domain.symbol
        entity.name = domain.name
        entity.rank = domain.rank.map(NSNumber.init(value:))
        entity.imageURLString = domain.imageURL?.absoluteString
        entity.coinDescription = domain.description
        entity.homepageURLString = domain.homepageURL?.absoluteString
        entity.githubURLString = domain.githubURL?.absoluteString
        entity.categories = domain.categories.joined(separator: "\n")
        entity.currentPrice = domain.currentPrice.map(NSNumber.init(value:))
        entity.marketCap = domain.marketCap.map(NSNumber.init(value:))
        entity.totalVolume = domain.totalVolume.map(NSNumber.init(value:))
        entity.high24h = domain.high24h.map(NSNumber.init(value:))
        entity.low24h = domain.low24h.map(NSNumber.init(value:))
        entity.ath = domain.ath.map(NSNumber.init(value:))
        entity.athChangePercentage = domain.athChangePercentage.map(NSNumber.init(value:))
        entity.atl = domain.atl.map(NSNumber.init(value:))
        entity.atlChangePercentage = domain.atlChangePercentage.map(NSNumber.init(value:))
        entity.priceChange24h = domain.priceChange24h.map(NSNumber.init(value:))
        entity.priceChangePercentage24h = domain.priceChangePercentage24h.map(NSNumber.init(value:))
        entity.priceChangePercentage7d = domain.priceChangePercentage7d.map(NSNumber.init(value:))
        entity.priceChangePercentage30d = domain.priceChangePercentage30d.map(NSNumber.init(value:))
        entity.circulatingSupply = domain.circulatingSupply.map(NSNumber.init(value:))
        entity.totalSupply = domain.totalSupply.map(NSNumber.init(value:))
        entity.maxSupply = domain.maxSupply.map(NSNumber.init(value:))
        entity.twitterFollowers = domain.twitterFollowers.map(NSNumber.init(value:))
        entity.redditSubscribers = domain.redditSubscribers.map(NSNumber.init(value:))
        entity.githubStars = domain.githubStars.map(NSNumber.init(value:))
        entity.githubForks = domain.githubForks.map(NSNumber.init(value:))
        entity.githubSubscribers = domain.githubSubscribers.map(NSNumber.init(value:))
        entity.totalIssues = domain.totalIssues.map(NSNumber.init(value:))
        entity.closedIssues = domain.closedIssues.map(NSNumber.init(value:))
        entity.commitCount4Weeks = domain.commitCount4Weeks.map(NSNumber.init(value:))
        entity.updatedAt = Date()
    }

    static func mapToDomain(_ entity: MarketDetailEntity) -> MarketDetailDomain? {
        guard let id: String = entity.id,
              let symbol: String = entity.symbol,
              let name: String = entity.name else { return nil }

        return .init(
            id: id,
            symbol: symbol,
            name: name,
            rank: entity.rank?.intValue,
            imageURL: entity.imageURLString.flatMap(URL.init(string:)),
            description: entity.coinDescription,
            homepageURL: entity.homepageURLString.flatMap(URL.init(string:)),
            githubURL: entity.githubURLString.flatMap(URL.init(string:)),
            categories: entity.categories?.components(separatedBy: "\n").filter { $0.isEmpty == false } ?? [],
            currentPrice: entity.currentPrice?.doubleValue,
            marketCap: entity.marketCap?.doubleValue,
            totalVolume: entity.totalVolume?.doubleValue,
            high24h: entity.high24h?.doubleValue,
            low24h: entity.low24h?.doubleValue,
            ath: entity.ath?.doubleValue,
            athChangePercentage: entity.athChangePercentage?.doubleValue,
            atl: entity.atl?.doubleValue,
            atlChangePercentage: entity.atlChangePercentage?.doubleValue,
            priceChange24h: entity.priceChange24h?.doubleValue,
            priceChangePercentage24h: entity.priceChangePercentage24h?.doubleValue,
            priceChangePercentage7d: entity.priceChangePercentage7d?.doubleValue,
            priceChangePercentage30d: entity.priceChangePercentage30d?.doubleValue,
            circulatingSupply: entity.circulatingSupply?.doubleValue,
            totalSupply: entity.totalSupply?.doubleValue,
            maxSupply: entity.maxSupply?.doubleValue,
            twitterFollowers: entity.twitterFollowers?.intValue,
            redditSubscribers: entity.redditSubscribers?.intValue,
            githubStars: entity.githubStars?.intValue,
            githubForks: entity.githubForks?.intValue,
            githubSubscribers: entity.githubSubscribers?.intValue,
            totalIssues: entity.totalIssues?.intValue,
            closedIssues: entity.closedIssues?.intValue,
            commitCount4Weeks: entity.commitCount4Weeks?.intValue,
            updatedAt: entity.updatedAt
        )
    }
}
