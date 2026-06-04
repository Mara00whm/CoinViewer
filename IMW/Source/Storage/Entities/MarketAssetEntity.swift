//
//  MarketAssetEntity.swift
//  IMW
//
//  Created by Марат Саляхетдинов on 02.06.2026.
//

import CoreData
import Foundation

@objc(MarketAssetEntity)
final class MarketAssetEntity: NSManagedObject {

    static let entityName: String = "MarketAssetEntity"

    @NSManaged var id: String?
    @NSManaged var symbol: String?
    @NSManaged var name: String?
    @NSManaged var imageURLString: String?
    @NSManaged var currentPrice: NSNumber?
    @NSManaged var marketCap: NSNumber?
    @NSManaged var marketCapRank: NSNumber?
    @NSManaged var totalVolume: NSNumber?
    @NSManaged var high24h: NSNumber?
    @NSManaged var low24h: NSNumber?
    @NSManaged var priceChange24h: NSNumber?
    @NSManaged var priceChangePercentage24h: NSNumber?
    @NSManaged var updatedAt: Date?
}
