//
//  IsWatchlistAssetSavedStorageEndpoint.swift
//  IMW
//
//  Created by Марат Саляхетдинов on 04.06.2026.
//

import AppStorageCore
import CoreData
import Foundation

struct IsWatchlistAssetSavedStorageEndpoint: StorageEndpoint, @unchecked Sendable {

    typealias Response = Bool

    let operation: StorageOperation = .fetch

    // MARK: - Private properties

    private let id: String

    // MARK: - Init

    init(id: String) {
        self.id = id
    }

    // MARK: - Public methods

    func execute(in context: NSManagedObjectContext) throws -> Bool {
        let request: NSFetchRequest<WatchlistAssetEntity> = .init(entityName: WatchlistAssetEntity.entityName)
        request.predicate = .init(format: "%K == %@", #keyPath(WatchlistAssetEntity.id), id)
        request.fetchLimit = 1
        request.includesPendingChanges = true

        let count: Int = try context.count(for: request)
        return count > 0
    }
}
