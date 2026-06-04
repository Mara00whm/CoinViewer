//
//  FetchMarketChartStorageEndpoint.swift
//  IMW
//
//  Created by Марат Саляхетдинов on 03.06.2026.
//

import AppStorageCore
import CoreData
import Foundation

struct FetchMarketChartStorageEndpoint: StorageEndpoint, @unchecked Sendable {

    typealias Response = [MarketChartPointDomain]

    let operation: StorageOperation = .fetch

    // MARK: - Private properties

    private let coinID: String
    private let range: MarketChartRange

    // MARK: - Init

    init(coinID: String, range: MarketChartRange) {
        self.coinID = coinID
        self.range = range
    }

    // MARK: - Public methods

    func execute(in context: NSManagedObjectContext) throws -> [MarketChartPointDomain] {
        let request: NSFetchRequest<MarketChartPointEntity> = .init(entityName: MarketChartPointEntity.entityName)
        request.predicate = .init(format: "%K == %@ AND %K == %@", #keyPath(MarketChartPointEntity.coinID), coinID, #keyPath(MarketChartPointEntity.range), range.rawValue)
        request.sortDescriptors = [
            .init(key: #keyPath(MarketChartPointEntity.date), ascending: true)
        ]
        request.returnsObjectsAsFaults = false

        let entities: [MarketChartPointEntity] = try context.fetch(request)
        return MarketChartStorageMapper.mapToDomain(entities)
    }
}
