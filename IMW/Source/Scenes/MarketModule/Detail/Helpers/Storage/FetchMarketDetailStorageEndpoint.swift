//
//  FetchMarketDetailStorageEndpoint.swift
//  IMW
//
//  Created by Марат Саляхетдинов on 03.06.2026.
//

import AppStorageCore
import CoreData
import Foundation

struct FetchMarketDetailStorageEndpoint: StorageEndpoint, @unchecked Sendable {

    typealias Response = MarketDetailDomain?

    let operation: StorageOperation = .fetch

    // MARK: - Private properties

    private let id: String

    // MARK: - Init

    init(id: String) {
        self.id = id
    }

    // MARK: - Public methods

    func execute(in context: NSManagedObjectContext) throws -> MarketDetailDomain? {
        let request: NSFetchRequest<MarketDetailEntity> = .init(entityName: MarketDetailEntity.entityName)
        request.predicate = .init(format: "%K == %@", #keyPath(MarketDetailEntity.id), id)
        request.fetchLimit = 1
        request.returnsObjectsAsFaults = false

        guard let entity: MarketDetailEntity = try context.fetch(request).first else { return nil }
        return MarketDetailStorageMapper.mapToDomain(entity)
    }
}
