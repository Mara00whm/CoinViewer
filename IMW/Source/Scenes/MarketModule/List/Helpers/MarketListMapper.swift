//
//  MarketListMapper.swift
//  IMW
//
//  Created by Марат Саляхетдинов on 01.06.2026.
//

import Foundation
import UIKit

protocol MarketListMapperInterface {
    func mapToDomain(_ response: [APINamespaces.MarketList.Response]) -> [MarketListDomain]
    func mapToViewModel(_ domains: [MarketListDomain], images: [String: UIImage]) -> MarketListModel.ViewModel
}

final class MarketListMapper: MarketListMapperInterface {

    // MARK: - Public methods

    func mapToDomain(_ response: [APINamespaces.MarketList.Response]) -> [MarketListDomain] {
        response.map {
            .init(id: $0.id, symbol: $0.symbol, name: $0.name, imageURL: $0.image.flatMap(URL.init(string:)), currentPrice: $0.currentPrice, marketCap: $0.marketCap, marketCapRank: $0.marketCapRank, totalVolume: $0.totalVolume, high24h: $0.high24h, low24h: $0.low24h, priceChange24h: $0.priceChange24h, priceChangePercentage24h: $0.priceChangePercentage24h)
        }
    }

    func mapToViewModel(_ domains: [MarketListDomain], images: [String: UIImage]) -> MarketListModel.ViewModel {
        .init(items: domains.map { makeItemViewModel($0, image: images[$0.id]) })
    }
}

// MARK: - Private methods

private extension MarketListMapper {

    func makeItemViewModel(_ domain: MarketListDomain, image: UIImage?) -> MarketListModel.ItemViewModel {
        .init(id: domain.id, title: domain.name, subtitle: domain.symbol.uppercased(), priceText: formatPrice(domain.currentPrice), priceChangeText: formatPercentage(domain.priceChangePercentage24h), priceChangeColor: makeChangeColor(domain.priceChangePercentage24h), rankText: formatRank(domain.marketCapRank), image: image)
    }

    func formatPrice(_ value: Double?) -> String {
        guard let value else { return "-" }

        let formatter: NumberFormatter = .init()
        formatter.numberStyle = .currency
        formatter.currencyCode = "USD"
        formatter.maximumFractionDigits = value >= 1 ? 2 : 6
        formatter.minimumFractionDigits = value >= 1 ? 2 : 2
        return formatter.string(from: value as NSNumber) ?? "$\(value)"
    }

    func formatPercentage(_ value: Double?) -> String {
        guard let value else { return "-" }

        let sign: String = value > 0 ? "+" : ""
        return "\(sign)\(String(format: "%.2f", value))%"
    }

    func makeChangeColor(_ value: Double?) -> UIColor {
        guard let value else { return .secondaryLabel }
        return value >= 0 ? .systemGreen : .systemRed
    }

    func formatRank(_ value: Int?) -> String {
        guard let value else { return "-" }
        return "#\(value)"
    }
}
