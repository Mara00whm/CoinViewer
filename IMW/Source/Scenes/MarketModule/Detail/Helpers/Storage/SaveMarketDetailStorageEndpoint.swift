//
//  SaveMarketDetailStorageEndpoint.swift
//  IMW
//
//  Created by Марат Саляхетдинов on 03.06.2026.
//

import AppStorageCore
import CoreData
import Foundation

struct SaveMarketDetailStorageEndpoint: StorageEndpoint, @unchecked Sendable {

    typealias Response = Void

    let operation: StorageOperation = .write

    // MARK: - Private properties

    private let domain: MarketDetailDomain

    // MARK: - Init

    init(domain: MarketDetailDomain) {
        self.domain = domain
    }

    // MARK: - Public methods

    func execute(in context: NSManagedObjectContext) throws {
        let entity: MarketDetailEntity = try existingEntity(in: context) ?? newEntity(in: context)
        MarketDetailStorageMapper.configure(entity, with: domain)

        if context.hasChanges {
            try context.save()
        }
    }
}

// MARK: - Private methods

private extension SaveMarketDetailStorageEndpoint {

    func existingEntity(in context: NSManagedObjectContext) throws -> MarketDetailEntity? {
        let request: NSFetchRequest<MarketDetailEntity> = .init(entityName: MarketDetailEntity.entityName)
        request.predicate = .init(format: "%K == %@", #keyPath(MarketDetailEntity.id), domain.id)
        request.fetchLimit = 1
        request.includesPendingChanges = true

        return try context.fetch(request).first
    }

    func newEntity(in context: NSManagedObjectContext) throws -> MarketDetailEntity {
        guard let entity: MarketDetailEntity = NSEntityDescription.insertNewObject(forEntityName: MarketDetailEntity.entityName, into: context) as? MarketDetailEntity else {
            throw StorageError.entityTypeMismatch(name: MarketDetailEntity.entityName)
        }

        return entity
    }
}
