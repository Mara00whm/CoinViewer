//
//  MarketChartEndpoint.swift
//  IMW
//
//  Created by Марат Саляхетдинов on 03.06.2026.
//

import AppNetworkCore
import Foundation

struct MarketChartEndpoint: APIEndpoint {
    typealias Response = APINamespaces.MarketChart.Response

    let method: HTTPMethod = .get
    let path: String
    let queryItems: [URLQueryItem]?

    init(id: String, vsCurrency: String = "usd", range: MarketChartRange) {
        self.path = "/coins/\(id)/market_chart"
        self.queryItems = [
            .init(name: "vs_currency", value: vsCurrency),
            .init(name: "days", value: range.daysValue)
        ]
    }
}

enum MarketChartRange: String, CaseIterable, Sendable {
    case day
    case week
    case month
    case year

    var title: String {
        switch self {
        case .day:
            return "24H"
        case .week:
            return "7D"
        case .month:
            return "30D"
        case .year:
            return "1Y"
        }
    }

    var daysValue: String {
        switch self {
        case .day:
            return "1"
        case .week:
            return "7"
        case .month:
            return "30"
        case .year:
            return "365"
        }
    }
}

extension APINamespaces.MarketChart {

    struct Response: Decodable {
        let prices: [[Double]]
        let marketCaps: [[Double]]
        let totalVolumes: [[Double]]

        enum CodingKeys: String, CodingKey {
            case prices
            case marketCaps = "market_caps"
            case totalVolumes = "total_volumes"
        }
    }
}
