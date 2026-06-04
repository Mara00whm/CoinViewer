//
//  MarketChartPointEntity.swift
//  IMW
//
//  Created by Марат Саляхетдинов on 03.06.2026.
//

import CoreData
import Foundation

@objc(MarketChartPointEntity)
final class MarketChartPointEntity: NSManagedObject {

    static let entityName: String = "MarketChartPointEntity"

    @NSManaged var coinID: String?
    @NSManaged var range: String?
    @NSManaged var date: Date?
    @NSManaged var price: NSNumber?
    @NSManaged var marketCap: NSNumber?
    @NSManaged var totalVolume: NSNumber?
}
