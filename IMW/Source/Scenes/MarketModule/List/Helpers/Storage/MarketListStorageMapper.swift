//
//  MarketListStorageMapper.swift
//  IMW
//
//  Created by Марат Саляхетдинов on 02.06.2026.
//

import Foundation

enum MarketListStorageMapper {

    // MARK: - Public methods

    static func configure(_ entity: MarketAssetEntity, with domain: MarketListDomain) {
        entity.id = domain.id
        entity.symbol = domain.symbol
        entity.name = domain.name
        entity.imageURLString = domain.imageURL?.absoluteString
        entity.currentPrice = domain.currentPrice.map(NSNumber.init(value:))
        entity.marketCap = domain.marketCap.map(NSNumber.init(value:))
        entity.marketCapRank = domain.marketCapRank.map(NSNumber.init(value:))
        entity.totalVolume = domain.totalVolume.map(NSNumber.init(value:))
        entity.high24h = domain.high24h.map(NSNumber.init(value:))
        entity.low24h = domain.low24h.map(NSNumber.init(value:))
        entity.priceChange24h = domain.priceChange24h.map(NSNumber.init(value:))
        entity.priceChangePercentage24h = domain.priceChangePercentage24h.map(NSNumber.init(value:))
        entity.updatedAt = Date()
    }

    static func mapToDomain(_ entities: [MarketAssetEntity]) -> [MarketListDomain] {
        entities.compactMap(mapToDomain)
    }
}

// MARK: - Private methods

private extension MarketListStorageMapper {

    nonisolated static func mapToDomain(_ entity: MarketAssetEntity) -> MarketListDomain? {
        guard let id: String = entity.id,
              let symbol: String = entity.symbol,
              let name: String = entity.name else { return nil }

        return .init(
            id: id,
            symbol: symbol,
            name: name,
            imageURL: entity.imageURLString.flatMap(URL.init(string:)),
            currentPrice: entity.currentPrice?.doubleValue,
            marketCap: entity.marketCap?.doubleValue,
            marketCapRank: entity.marketCapRank?.intValue,
            totalVolume: entity.totalVolume?.doubleValue,
            high24h: entity.high24h?.doubleValue,
            low24h: entity.low24h?.doubleValue,
            priceChange24h: entity.priceChange24h?.doubleValue,
            priceChangePercentage24h: entity.priceChangePercentage24h?.doubleValue
        )
    }
}
