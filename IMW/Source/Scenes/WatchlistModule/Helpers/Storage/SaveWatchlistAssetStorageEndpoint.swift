//
//  SaveWatchlistAssetStorageEndpoint.swift
//  IMW
//
//  Created by Марат Саляхетдинов on 04.06.2026.
//

import AppStorageCore
import CoreData
import Foundation

struct SaveWatchlistAssetStorageEndpoint: StorageEndpoint, @unchecked Sendable {

    typealias Response = Void

    let operation: StorageOperation = .write

    // MARK: - Private properties

    private let domain: MarketListDomain

    // MARK: - Init

    init(domain: MarketListDomain) {
        self.domain = domain
    }

    // MARK: - Public methods

    func execute(in context: NSManagedObjectContext) throws {
        let entity: WatchlistAssetEntity = try existingEntity(in: context) ?? newEntity(in: context)
        WatchlistStorageMapper.configure(entity, with: domain)

        if context.hasChanges {
            try context.save()
        }
    }
}

// MARK: - Private methods

private extension SaveWatchlistAssetStorageEndpoint {

    func existingEntity(in context: NSManagedObjectContext) throws -> WatchlistAssetEntity? {
        let request: NSFetchRequest<WatchlistAssetEntity> = .init(entityName: WatchlistAssetEntity.entityName)
        request.predicate = .init(format: "%K == %@", #keyPath(WatchlistAssetEntity.id), domain.id)
        request.fetchLimit = 1
        request.includesPendingChanges = true

        return try context.fetch(request).first
    }

    func newEntity(in context: NSManagedObjectContext) throws -> WatchlistAssetEntity {
        guard let entity: WatchlistAssetEntity = NSEntityDescription.insertNewObject(forEntityName: WatchlistAssetEntity.entityName, into: context) as? WatchlistAssetEntity else {
            throw StorageError.entityTypeMismatch(name: WatchlistAssetEntity.entityName)
        }

        return entity
    }
}
