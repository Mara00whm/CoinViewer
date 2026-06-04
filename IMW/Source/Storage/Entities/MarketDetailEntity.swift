//
//  MarketDetailEntity.swift
//  IMW
//
//  Created by Марат Саляхетдинов on 03.06.2026.
//

import CoreData
import Foundation

@objc(MarketDetailEntity)
final class MarketDetailEntity: NSManagedObject {

    static let entityName: String = "MarketDetailEntity"

    @NSManaged var id: String?
    @NSManaged var symbol: String?
    @NSManaged var name: String?
    @NSManaged var rank: NSNumber?
    @NSManaged var imageURLString: String?
    @NSManaged var coinDescription: String?
    @NSManaged var homepageURLString: String?
    @NSManaged var githubURLString: String?
    @NSManaged var categories: String?
    @NSManaged var currentPrice: NSNumber?
    @NSManaged var marketCap: NSNumber?
    @NSManaged var totalVolume: NSNumber?
    @NSManaged var high24h: NSNumber?
    @NSManaged var low24h: NSNumber?
    @NSManaged var ath: NSNumber?
    @NSManaged var athChangePercentage: NSNumber?
    @NSManaged var atl: NSNumber?
    @NSManaged var atlChangePercentage: NSNumber?
    @NSManaged var priceChange24h: NSNumber?
    @NSManaged var priceChangePercentage24h: NSNumber?
    @NSManaged var priceChangePercentage7d: NSNumber?
    @NSManaged var priceChangePercentage30d: NSNumber?
    @NSManaged var circulatingSupply: NSNumber?
    @NSManaged var totalSupply: NSNumber?
    @NSManaged var maxSupply: NSNumber?
    @NSManaged var twitterFollowers: NSNumber?
    @NSManaged var redditSubscribers: NSNumber?
    @NSManaged var githubStars: NSNumber?
    @NSManaged var githubForks: NSNumber?
    @NSManaged var githubSubscribers: NSNumber?
    @NSManaged var totalIssues: NSNumber?
    @NSManaged var closedIssues: NSNumber?
    @NSManaged var commitCount4Weeks: NSNumber?
    @NSManaged var updatedAt: Date?
}
