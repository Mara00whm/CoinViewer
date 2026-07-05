//
//  MarketChartStorageMapper.swift
//  IMW
//
//  Created by Марат Саляхетдинов on 03.06.2026.
//

import Foundation

enum MarketChartStorageMapper {

    // MARK: - Public methods

    static func configure(_ entity: MarketChartPointEntity, with domain: MarketChartPointDomain, coinID: String, range: MarketChartRange) {
        entity.coinID = coinID
        entity.range = range.rawValue
        entity.date = domain.date
        entity.price = .init(value: domain.price)
        entity.marketCap = domain.marketCap.map(NSNumber.init(value:))
        entity.totalVolume = domain.totalVolume.map(NSNumber.init(value:))
    }

    static func mapToDomain(_ entities: [MarketChartPointEntity]) -> [MarketChartPointDomain] {
        entities.compactMap(mapToDomain)
    }
}

// MARK: - Private methods

private extension MarketChartStorageMapper {

    nonisolated static func mapToDomain(_ entity: MarketChartPointEntity) -> MarketChartPointDomain? {
        guard let date: Date = entity.date,
              let price: NSNumber = entity.price else { return nil }

        return .init(
            date: date,
            price: price.doubleValue,
            marketCap: entity.marketCap?.doubleValue,
            totalVolume: entity.totalVolume?.doubleValue
        )
    }
}
