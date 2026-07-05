//
//  WatchlistContainer.swift
//  IMW
//
//  Created by Марат Саляхетдинов on 06.07.2026.
//

import UIKit

@MainActor
protocol WatchlistContainerInterface {
    func createWatchListScreen(coordinator: any WatchlistCoordinatorInterface) -> UIViewController
}

@MainActor
final class WatchlistContainer: WatchlistContainerInterface {

    // MARK: - Private properties

    private let dependencies: any DependencyContainerInterface

    // MARK: - Init

    init(dependencies: any DependencyContainerInterface) {
        self.dependencies = dependencies
    }

    // MARK: - Public methods

    func createWatchListScreen(coordinator: any WatchlistCoordinatorInterface) -> UIViewController {
        WatchListAssembly().createModule(input: .init(), dependencies: .init(restClient: dependencies.restClient, imageLoader: dependencies.imageLoader, storageClient: dependencies.storageClient, coordinator: coordinator))
    }
}
