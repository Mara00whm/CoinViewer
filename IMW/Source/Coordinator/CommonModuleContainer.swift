//
//  CommonModuleContainer.swift
//  IMW
//
//  Created by Марат Саляхетдинов on 06.07.2026.
//

import UIKit

@MainActor
protocol CommonModuleContainerInterface {
    func createMarketDetailScreen(id: String) -> UIViewController
}

@MainActor
final class CommonModuleContainer: CommonModuleContainerInterface {

    // MARK: - Private properties

    private let dependencies: any DependencyContainerInterface

    // MARK: - Init

    init(dependencies: any DependencyContainerInterface) {
        self.dependencies = dependencies
    }

    // MARK: - Public methods

    func createMarketDetailScreen(id: String) -> UIViewController {
        MarketDetailAssembly().createModule(input: .init(id: id), dependencies: .init(restClient: dependencies.restClient, imageLoader: dependencies.imageLoader, storageClient: dependencies.storageClient))
    }
}
