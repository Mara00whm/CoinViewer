//
//  DeleteWatchlistAssetStorageEndpoint.swift
//  IMW
//
//  Created by Марат Саляхетдинов on 04.06.2026.
//

import AppStorageCore
import CoreData
import Foundation

struct DeleteWatchlistAssetStorageEndpoint: StorageEndpoint, @unchecked Sendable {

    typealias Response = Void

    let operation: StorageOperation = .write

    // MARK: - Private properties

    private let id: String

    // MARK: - Init

    init(id: String) {
        self.id = id
    }

    // MARK: - Public methods

    func execute(in context: NSManagedObjectContext) throws {
        let request: NSFetchRequest<WatchlistAssetEntity> = .init(entityName: WatchlistAssetEntity.entityName)
        request.predicate = .init(format: "%K == %@", #keyPath(WatchlistAssetEntity.id), id)
        request.includesPendingChanges = true

        let entities: [WatchlistAssetEntity] = try context.fetch(request)
        entities.forEach(context.delete)

        if context.hasChanges {
            try context.save()
        }
    }
}
