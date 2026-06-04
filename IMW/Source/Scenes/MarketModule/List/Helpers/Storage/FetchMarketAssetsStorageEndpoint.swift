//
//  FetchMarketAssetsStorageEndpoint.swift
//  IMW
//
//  Created by Марат Саляхетдинов on 02.06.2026.
//

import AppStorageCore
import CoreData
import Foundation

struct FetchMarketAssetsStorageEndpoint: StorageEndpoint, @unchecked Sendable {

    typealias Response = [MarketListDomain]

    let operation: StorageOperation = .fetch

    // MARK: - Public methods

    func execute(in context: NSManagedObjectContext) throws -> [MarketListDomain] {
        let request: NSFetchRequest<MarketAssetEntity> = .init(entityName: MarketAssetEntity.entityName)
        request.sortDescriptors = [
            .init(key: #keyPath(MarketAssetEntity.marketCapRank), ascending: true)
        ]
        request.returnsObjectsAsFaults = false

        let entities: [MarketAssetEntity] = try context.fetch(request)
        return MarketListStorageMapper.mapToDomain(entities)
    }
}
