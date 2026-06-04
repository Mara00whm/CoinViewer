//
//  FetchWatchlistAssetsStorageEndpoint.swift
//  IMW
//
//  Created by Марат Саляхетдинов on 04.06.2026.
//

import AppStorageCore
import CoreData
import Foundation

struct FetchWatchlistAssetsStorageEndpoint: StorageEndpoint, @unchecked Sendable {

    typealias Response = [MarketListDomain]

    let operation: StorageOperation = .fetch

    // MARK: - Public methods

    func execute(in context: NSManagedObjectContext) throws -> [MarketListDomain] {
        let request: NSFetchRequest<WatchlistAssetEntity> = .init(entityName: WatchlistAssetEntity.entityName)
        request.sortDescriptors = [
            .init(key: #keyPath(WatchlistAssetEntity.addedAt), ascending: false)
        ]
        request.returnsObjectsAsFaults = false

        let entities: [WatchlistAssetEntity] = try context.fetch(request)
        return WatchlistStorageMapper.mapToDomain(entities)
    }
}
