//
//  IMWStorageModelFactory.swift
//  IMW
//
//  Created by Марат Саляхетдинов on 02.06.2026.
//

import CoreData
import Foundation

enum IMWStorageModelFactory {

    // MARK: - Public methods

    static func makeModel() -> NSManagedObjectModel {
        let model: NSManagedObjectModel = .init()
        let marketAssetEntity: NSEntityDescription = makeMarketAssetEntity()
        let marketDetailEntity: NSEntityDescription = makeMarketDetailEntity()
        let marketChartPointEntity: NSEntityDescription = makeMarketChartPointEntity()
        let watchlistAssetEntity: NSEntityDescription = makeWatchlistAssetEntity()
        model.entities = [marketAssetEntity, marketDetailEntity, marketChartPointEntity, watchlistAssetEntity]
        return model
    }
}

// MARK: - Private methods

private extension IMWStorageModelFactory {

    static func makeMarketAssetEntity() -> NSEntityDescription {
        let entity: NSEntityDescription = .init()
        entity.name = MarketAssetEntity.entityName
        entity.managedObjectClassName = NSStringFromClass(MarketAssetEntity.self)
        entity.properties = [
            makeAttribute(name: "id", type: .stringAttributeType),
            makeAttribute(name: "symbol", type: .stringAttributeType),
            makeAttribute(name: "name", type: .stringAttributeType),
            makeAttribute(name: "imageURLString", type: .stringAttributeType),
            makeAttribute(name: "currentPrice", type: .doubleAttributeType),
            makeAttribute(name: "marketCap", type: .doubleAttributeType),
            makeAttribute(name: "marketCapRank", type: .integer64AttributeType),
            makeAttribute(name: "totalVolume", type: .doubleAttributeType),
            makeAttribute(name: "high24h", type: .doubleAttributeType),
            makeAttribute(name: "low24h", type: .doubleAttributeType),
            makeAttribute(name: "priceChange24h", type: .doubleAttributeType),
            makeAttribute(name: "priceChangePercentage24h", type: .doubleAttributeType),
            makeAttribute(name: "updatedAt", type: .dateAttributeType)
        ]
        return entity
    }

    static func makeMarketDetailEntity() -> NSEntityDescription {
        let entity: NSEntityDescription = .init()
        entity.name = MarketDetailEntity.entityName
        entity.managedObjectClassName = NSStringFromClass(MarketDetailEntity.self)
        entity.properties = [
            makeAttribute(name: "id", type: .stringAttributeType),
            makeAttribute(name: "symbol", type: .stringAttributeType),
            makeAttribute(name: "name", type: .stringAttributeType),
            makeAttribute(name: "rank", type: .integer64AttributeType),
            makeAttribute(name: "imageURLString", type: .stringAttributeType),
            makeAttribute(name: "coinDescription", type: .stringAttributeType),
            makeAttribute(name: "homepageURLString", type: .stringAttributeType),
            makeAttribute(name: "githubURLString", type: .stringAttributeType),
            makeAttribute(name: "categories", type: .stringAttributeType),
            makeAttribute(name: "currentPrice", type: .doubleAttributeType),
            makeAttribute(name: "marketCap", type: .doubleAttributeType),
            makeAttribute(name: "totalVolume", type: .doubleAttributeType),
            makeAttribute(name: "high24h", type: .doubleAttributeType),
            makeAttribute(name: "low24h", type: .doubleAttributeType),
            makeAttribute(name: "ath", type: .doubleAttributeType),
            makeAttribute(name: "athChangePercentage", type: .doubleAttributeType),
            makeAttribute(name: "atl", type: .doubleAttributeType),
            makeAttribute(name: "atlChangePercentage", type: .doubleAttributeType),
            makeAttribute(name: "priceChange24h", type: .doubleAttributeType),
            makeAttribute(name: "priceChangePercentage24h", type: .doubleAttributeType),
            makeAttribute(name: "priceChangePercentage7d", type: .doubleAttributeType),
            makeAttribute(name: "priceChangePercentage30d", type: .doubleAttributeType),
            makeAttribute(name: "circulatingSupply", type: .doubleAttributeType),
            makeAttribute(name: "totalSupply", type: .doubleAttributeType),
            makeAttribute(name: "maxSupply", type: .doubleAttributeType),
            makeAttribute(name: "twitterFollowers", type: .integer64AttributeType),
            makeAttribute(name: "redditSubscribers", type: .integer64AttributeType),
            makeAttribute(name: "githubStars", type: .integer64AttributeType),
            makeAttribute(name: "githubForks", type: .integer64AttributeType),
            makeAttribute(name: "githubSubscribers", type: .integer64AttributeType),
            makeAttribute(name: "totalIssues", type: .integer64AttributeType),
            makeAttribute(name: "closedIssues", type: .integer64AttributeType),
            makeAttribute(name: "commitCount4Weeks", type: .integer64AttributeType),
            makeAttribute(name: "updatedAt", type: .dateAttributeType)
        ]
        return entity
    }

    static func makeMarketChartPointEntity() -> NSEntityDescription {
        let entity: NSEntityDescription = .init()
        entity.name = MarketChartPointEntity.entityName
        entity.managedObjectClassName = NSStringFromClass(MarketChartPointEntity.self)
        entity.properties = [
            makeAttribute(name: "coinID", type: .stringAttributeType),
            makeAttribute(name: "range", type: .stringAttributeType),
            makeAttribute(name: "date", type: .dateAttributeType),
            makeAttribute(name: "price", type: .doubleAttributeType),
            makeAttribute(name: "marketCap", type: .doubleAttributeType),
            makeAttribute(name: "totalVolume", type: .doubleAttributeType)
        ]
        return entity
    }

    static func makeWatchlistAssetEntity() -> NSEntityDescription {
        let entity: NSEntityDescription = .init()
        entity.name = WatchlistAssetEntity.entityName
        entity.managedObjectClassName = NSStringFromClass(WatchlistAssetEntity.self)
        entity.properties = [
            makeAttribute(name: "id", type: .stringAttributeType),
            makeAttribute(name: "symbol", type: .stringAttributeType),
            makeAttribute(name: "name", type: .stringAttributeType),
            makeAttribute(name: "imageURLString", type: .stringAttributeType),
            makeAttribute(name: "currentPrice", type: .doubleAttributeType),
            makeAttribute(name: "marketCap", type: .doubleAttributeType),
            makeAttribute(name: "marketCapRank", type: .integer64AttributeType),
            makeAttribute(name: "totalVolume", type: .doubleAttributeType),
            makeAttribute(name: "high24h", type: .doubleAttributeType),
            makeAttribute(name: "low24h", type: .doubleAttributeType),
            makeAttribute(name: "priceChange24h", type: .doubleAttributeType),
            makeAttribute(name: "priceChangePercentage24h", type: .doubleAttributeType),
            makeAttribute(name: "addedAt", type: .dateAttributeType),
            makeAttribute(name: "updatedAt", type: .dateAttributeType)
        ]
        return entity
    }

    static func makeAttribute(name: String, type: NSAttributeType) -> NSAttributeDescription {
        let attribute: NSAttributeDescription = .init()
        attribute.name = name
        attribute.attributeType = type
        attribute.isOptional = true
        return attribute
    }
}
