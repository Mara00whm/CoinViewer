//
//  MarketDetailMapper.swift
//  IMW
//
//  Created by Марат Саляхетдинов on 03.06.2026.
//

import AppCore
import Foundation
import UIKit

protocol MarketDetailMapperInterface {
    func mapToDomain(_ response: APINamespaces.MarketDetail.Response) -> MarketDetailDomain
    func mapToChartPoints(_ response: APINamespaces.MarketChart.Response) -> [MarketChartPointDomain]
    func mapToMarketListDomain(_ domain: MarketDetailDomain) -> MarketListDomain
    func mapToViewModel(_ domain: MarketDetailDomain, image: UIImage?, chartPoints: [MarketChartPointDomain], selectedRange: MarketChartRange, isInWatchlist: Bool) -> MarketDetailModel.ViewModel
}

final class MarketDetailMapper: MarketDetailMapperInterface {

    // MARK: - Public methods

    func mapToDomain(_ response: APINamespaces.MarketDetail.Response) -> MarketDetailDomain {
        let marketData: APINamespaces.MarketDetail.MarketData? = response.marketData

        return .init(
            id: response.id,
            symbol: response.symbol,
            name: response.name,
            rank: response.marketCapRank,
            imageURL: response.image?.large.flatMap(URL.init(string:)) ?? response.image?.small.flatMap(URL.init(string:)),
            description: response.description?.en?.htmlStripped.trimmingCharacters(in: .whitespacesAndNewlines),
            homepageURL: firstURL(response.links?.homepage),
            githubURL: firstURL(response.links?.reposURL?.github),
            categories: response.categories ?? [],
            currentPrice: marketData?.currentPrice?["usd"],
            marketCap: marketData?.marketCap?["usd"],
            totalVolume: marketData?.totalVolume?["usd"],
            high24h: marketData?.high24h?["usd"],
            low24h: marketData?.low24h?["usd"],
            ath: marketData?.ath?["usd"],
            athChangePercentage: marketData?.athChangePercentage?["usd"],
            atl: marketData?.atl?["usd"],
            atlChangePercentage: marketData?.atlChangePercentage?["usd"],
            priceChange24h: marketData?.priceChange24h,
            priceChangePercentage24h: marketData?.priceChangePercentage24h,
            priceChangePercentage7d: marketData?.priceChangePercentage7d,
            priceChangePercentage30d: marketData?.priceChangePercentage30d,
            circulatingSupply: marketData?.circulatingSupply,
            totalSupply: marketData?.totalSupply,
            maxSupply: marketData?.maxSupply,
            twitterFollowers: response.communityData?.twitterFollowers,
            redditSubscribers: response.communityData?.redditSubscribers,
            githubStars: response.developerData?.stars,
            githubForks: response.developerData?.forks,
            githubSubscribers: response.developerData?.subscribers,
            totalIssues: response.developerData?.totalIssues,
            closedIssues: response.developerData?.closedIssues,
            commitCount4Weeks: response.developerData?.commitCount4Weeks,
            updatedAt: Date()
        )
    }

    func mapToChartPoints(_ response: APINamespaces.MarketChart.Response) -> [MarketChartPointDomain] {
        response.prices.enumerated().compactMap { index, priceItem in
            guard priceItem.count >= 2 else { return nil }

            let marketCap: Double? = value(at: index, from: response.marketCaps)
            let totalVolume: Double? = value(at: index, from: response.totalVolumes)

            return .init(
                date: .init(timeIntervalSince1970: priceItem[0] / 1000),
                price: priceItem[1],
                marketCap: marketCap,
                totalVolume: totalVolume
            )
        }
    }

    func mapToMarketListDomain(_ domain: MarketDetailDomain) -> MarketListDomain {
        .init(
            id: domain.id,
            symbol: domain.symbol,
            name: domain.name,
            imageURL: domain.imageURL,
            currentPrice: domain.currentPrice,
            marketCap: domain.marketCap,
            marketCapRank: domain.rank,
            totalVolume: domain.totalVolume,
            high24h: domain.high24h,
            low24h: domain.low24h,
            priceChange24h: domain.priceChange24h,
            priceChangePercentage24h: domain.priceChangePercentage24h
        )
    }

    func mapToViewModel(_ domain: MarketDetailDomain, image: UIImage?, chartPoints: [MarketChartPointDomain], selectedRange: MarketChartRange, isInWatchlist: Bool) -> MarketDetailModel.ViewModel {
        .init(
            title: domain.name,
            subtitle: domain.symbol.uppercased(),
            rankText: formatRank(domain.rank),
            image: image,
            priceText: formatPrice(domain.currentPrice),
            priceChangeText: formatPercentage(domain.priceChangePercentage24h),
            priceChangeColor: makeChangeColor(domain.priceChangePercentage24h),
            chart: makeChartViewModel(points: chartPoints, selectedRange: selectedRange),
            stats: makeStats(domain),
            links: makeLinks(domain),
            categoriesText: domain.categories.prefix(4).joined(separator: ", "),
            descriptionText: domain.description.isNilOrEmpty ? "No description available." : domain.description ?? "No description available.",
            isInWatchlist: isInWatchlist
        )
    }
}

// MARK: - Private methods

private extension MarketDetailMapper {

    func firstURL(_ values: [String]?) -> URL? {
        values?.first { $0.isEmpty == false }.flatMap(URL.init(string:))
    }

    func value(at index: Int, from values: [[Double]]) -> Double? {
        guard values.indices.contains(index),
              values[index].count >= 2 else { return nil }

        return values[index][1]
    }

    func makeChartViewModel(points: [MarketChartPointDomain], selectedRange: MarketChartRange) -> MarketDetailModel.ChartViewModel {
        let firstPrice: Double = points.first?.price ?? 0
        let lastPrice: Double = points.last?.price ?? 0
        let lineColor: UIColor = lastPrice >= firstPrice ? .systemGreen : .systemRed

        return .init(
            rangeTitles: MarketChartRange.allCases.map(\.title),
            selectedRangeIndex: MarketChartRange.allCases.firstIndex(of: selectedRange) ?? 0,
            points: points.map { .init(id: $0.date, date: $0.date, price: $0.price) },
            lineColor: lineColor
        )
    }

    func makeStats(_ domain: MarketDetailDomain) -> [MarketDetailModel.StatViewModel] {
        [
            .init(title: "Market Cap", value: formatCompactCurrency(domain.marketCap)),
            .init(title: "24h Volume", value: formatCompactCurrency(domain.totalVolume)),
            .init(title: "24h High", value: formatPrice(domain.high24h)),
            .init(title: "24h Low", value: formatPrice(domain.low24h)),
            .init(title: "ATH", value: formatPrice(domain.ath)),
            .init(title: "ATL", value: formatPrice(domain.atl)),
            .init(title: "Circulating Supply", value: formatCompactNumber(domain.circulatingSupply)),
            .init(title: "Total Supply", value: formatCompactNumber(domain.totalSupply)),
            .init(title: "Max Supply", value: formatCompactNumber(domain.maxSupply)),
            .init(title: "GitHub Stars", value: formatCompactNumber(domain.githubStars.map(Double.init))),
            .init(title: "GitHub Forks", value: formatCompactNumber(domain.githubForks.map(Double.init))),
            .init(title: "Commits 4w", value: formatCompactNumber(domain.commitCount4Weeks.map(Double.init)))
        ]
    }

    func makeLinks(_ domain: MarketDetailDomain) -> [MarketDetailModel.LinkViewModel] {
        var links: [MarketDetailModel.LinkViewModel] = []

        if let homepageURL: URL = domain.homepageURL {
            links.append(.init(title: "Website", url: homepageURL))
        }

        if let githubURL: URL = domain.githubURL {
            links.append(.init(title: "GitHub", url: githubURL))
        }

        return links
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

    func formatCompactCurrency(_ value: Double?) -> String {
        guard let value else { return "-" }

        let compactValue: (value: Double, suffix: String) = makeCompactValue(abs(value))
        let sign: String = value < 0 ? "-" : ""
        return "\(sign)$\(formatDecimal(compactValue.value, maximumFractionDigits: 2))\(compactValue.suffix)"
    }

    func formatCompactNumber(_ value: Double?) -> String {
        guard let value else { return "-" }

        let compactValue: (value: Double, suffix: String) = makeCompactValue(abs(value))
        let sign: String = value < 0 ? "-" : ""
        return "\(sign)\(formatDecimal(compactValue.value, maximumFractionDigits: 2))\(compactValue.suffix)"
    }

    func makeCompactValue(_ value: Double) -> (value: Double, suffix: String) {
        switch value {
        case 1_000_000_000_000...:
            return (value / 1_000_000_000_000, "T")
        case 1_000_000_000...:
            return (value / 1_000_000_000, "B")
        case 1_000_000...:
            return (value / 1_000_000, "M")
        case 1_000...:
            return (value / 1_000, "K")
        default:
            return (value, "")
        }
    }

    func formatDecimal(_ value: Double, maximumFractionDigits: Int) -> String {
        let formatter: NumberFormatter = .init()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = maximumFractionDigits
        return formatter.string(from: value as NSNumber) ?? "\(value)"
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

private extension String {

    var htmlStripped: String {
        replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression)
    }
}
