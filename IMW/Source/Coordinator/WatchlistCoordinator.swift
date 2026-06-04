//
//  WatchlistCoordinator.swift
//  IMW
//
//  Created by Марат Саляхетдинов on 01.06.2026.
//

import UIKit

@MainActor
protocol WatchlistCoordinatorInterface: DependencyCoordinatorInterface {
    func showDetail(id: String)
}

@MainActor
final class WatchlistCoordinator: WatchlistCoordinatorInterface {

    // MARK: - Public properties

    let rootViewController: UIViewController

    // MARK: - Private properties

    private let dependencyContainer: any DependencyContainerInterface

    // MARK: - Init

    init(dependencyContainer: any DependencyContainerInterface) {
        self.dependencyContainer = dependencyContainer
        self.rootViewController = UINavigationController()
    }

    // MARK: - Public methods

    func start() -> UIViewController {
        let viewController: WatchListViewController = WatchListAssembly.makeViewController(.init(restClient: dependencyContainer.restClient, imageLoader: dependencyContainer.imageLoader, storageClient: dependencyContainer.storageClient, coordinator: self))
        navigationRootViewController?.setViewControllers([viewController], animated: false)
        return rootViewController
    }

    func showDetail(id: String) {
        let viewController: MarketDetailViewController = MarketDetailAssembly.makeViewController(.init(id: id, restClient: dependencyContainer.restClient, imageLoader: dependencyContainer.imageLoader, storageClient: dependencyContainer.storageClient))
        push(viewController)
    }
}
