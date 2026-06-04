//
//  SaveMarketAssetsStorageEndpoint.swift
//  IMW
//
//  Created by Марат Саляхетдинов on 02.06.2026.
//

import AppStorageCore
import CoreData
import Foundation

struct SaveMarketAssetsStorageEndpoint: StorageEndpoint, @unchecked Sendable {

    typealias Response = Void

    let operation: StorageOperation = .write

    // MARK: - Private properties

    private let domains: [MarketListDomain]
    private let shouldReplaceExistingCache: Bool

    // MARK: - Init

    init(domains: [MarketListDomain], shouldReplaceExistingCache: Bool) {
        self.domains = domains
        self.shouldReplaceExistingCache = shouldReplaceExistingCache
    }

    // MARK: - Public methods

    func execute(in context: NSManagedObjectContext) throws {
        if shouldReplaceExistingCache {
            try deleteExistingCache(in: context)
        }

        try domains.forEach {
            let entity: MarketAssetEntity = try existingEntity(for: $0, in: context) ?? newEntity(in: context)
            MarketListStorageMapper.configure(entity, with: $0)
        }

        if context.hasChanges {
            try context.save()
        }
    }
}

// MARK: - Private methods

private extension SaveMarketAssetsStorageEndpoint {

    func deleteExistingCache(in context: NSManagedObjectContext) throws {
        let request: NSFetchRequest<NSManagedObject> = .init(entityName: MarketAssetEntity.entityName)
        request.includesPendingChanges = true

        let entities: [NSManagedObject] = try context.fetch(request)
        entities.forEach(context.delete)
    }

    func existingEntity(for domain: MarketListDomain, in context: NSManagedObjectContext) throws -> MarketAssetEntity? {
        guard shouldReplaceExistingCache == false else { return nil }

        let request: NSFetchRequest<MarketAssetEntity> = .init(entityName: MarketAssetEntity.entityName)
        request.predicate = .init(format: "%K == %@", #keyPath(MarketAssetEntity.id), domain.id)
        request.fetchLimit = 1
        request.includesPendingChanges = true

        return try context.fetch(request).first
    }

    func newEntity(in context: NSManagedObjectContext) throws -> MarketAssetEntity {
        guard let entity: MarketAssetEntity = NSEntityDescription.insertNewObject(forEntityName: MarketAssetEntity.entityName, into: context) as? MarketAssetEntity else {
            throw StorageError.entityTypeMismatch(name: MarketAssetEntity.entityName)
        }

        return entity
    }
}
