//
//  MarketContainer.swift
//  IMW
//
//  Created by Марат Саляхетдинов on 06.07.2026.
//

import UIKit

@MainActor
protocol MarketContainerInterface {
    func createMarketListScreen(coordinator: any MarketCoordinatorInterface) -> UIViewController
}

@MainActor
final class MarketContainer: MarketContainerInterface {

    // MARK: - Private properties

    private let dependencies: any DependencyContainerInterface

    // MARK: - Init

    init(dependencies: any DependencyContainerInterface) {
        self.dependencies = dependencies
    }

    // MARK: - Public methods

    func createMarketListScreen(coordinator: any MarketCoordinatorInterface) -> UIViewController {
        MarketListAssembly().createModule(input: .init(), dependencies: .init(restClient: dependencies.restClient, imageLoader: dependencies.imageLoader, storageClient: dependencies.storageClient, coordinator: coordinator))
    }
}
