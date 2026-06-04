//
//  SaveMarketChartStorageEndpoint.swift
//  IMW
//
//  Created by Марат Саляхетдинов on 03.06.2026.
//

import AppStorageCore
import CoreData
import Foundation

struct SaveMarketChartStorageEndpoint: StorageEndpoint, @unchecked Sendable {

    typealias Response = Void

    let operation: StorageOperation = .write

    // MARK: - Private properties

    private let coinID: String
    private let range: MarketChartRange
    private let points: [MarketChartPointDomain]

    // MARK: - Init

    init(coinID: String, range: MarketChartRange, points: [MarketChartPointDomain]) {
        self.coinID = coinID
        self.range = range
        self.points = points
    }

    // MARK: - Public methods

    func execute(in context: NSManagedObjectContext) throws {
        try deleteExistingPoints(in: context)

        try points.forEach {
            let entity: MarketChartPointEntity = try newEntity(in: context)
            MarketChartStorageMapper.configure(entity, with: $0, coinID: coinID, range: range)
        }

        if context.hasChanges {
            try context.save()
        }
    }
}

// MARK: - Private methods

private extension SaveMarketChartStorageEndpoint {

    func deleteExistingPoints(in context: NSManagedObjectContext) throws {
        let request: NSFetchRequest<NSManagedObject> = .init(entityName: MarketChartPointEntity.entityName)
        request.predicate = .init(format: "%K == %@ AND %K == %@", #keyPath(MarketChartPointEntity.coinID), coinID, #keyPath(MarketChartPointEntity.range), range.rawValue)
        request.includesPendingChanges = true

        let entities: [NSManagedObject] = try context.fetch(request)
        entities.forEach(context.delete)
    }

    func newEntity(in context: NSManagedObjectContext) throws -> MarketChartPointEntity {
        guard let entity: MarketChartPointEntity = NSEntityDescription.insertNewObject(forEntityName: MarketChartPointEntity.entityName, into: context) as? MarketChartPointEntity else {
            throw StorageError.entityTypeMismatch(name: MarketChartPointEntity.entityName)
        }

        return entity
    }
}
