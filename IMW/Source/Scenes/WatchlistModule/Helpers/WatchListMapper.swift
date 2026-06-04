//
//  WatchListMapper.swift
//  IMW
//
//  Created by Марат Саляхетдинов on 04.06.2026.
//

import Foundation
import UIKit

protocol WatchListMapperInterface {
    func mapToDomain(_ response: [APINamespaces.MarketList.Response]) -> [MarketListDomain]
    func mapToViewModel(_ domains: [MarketListDomain], images: [String: UIImage]) -> WatchListModel.ViewModel
}

final class WatchListMapper: WatchListMapperInterface {

    // MARK: - Private properties

    private let marketListMapper: MarketListMapperInterface

    // MARK: - Init

    init(marketListMapper: MarketListMapperInterface) {
        self.marketListMapper = marketListMapper
    }

    // MARK: - Public methods

    func mapToDomain(_ response: [APINamespaces.MarketList.Response]) -> [MarketListDomain] {
        marketListMapper.mapToDomain(response)
    }

    func mapToViewModel(_ domains: [MarketListDomain], images: [String: UIImage]) -> WatchListModel.ViewModel {
        let viewModel: MarketListModel.ViewModel = marketListMapper.mapToViewModel(domains, images: images)
        return .init(items: viewModel.items, isEmpty: domains.isEmpty)
    }
}
