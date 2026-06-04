//
//  MainCoordinator.swift
//  IMW
//
//  Created by Марат Саляхетдинов on 01.06.2026.
//

import UIKit

@MainActor
final class MainCoordinator: Coordinator {

    // MARK: - Public properties

    let rootViewController: UIViewController

    // MARK: - Private properties

    private let tabBarController: MainTabBarController
    private let marketCoordinator: MarketCoordinator
    private let watchlistCoordinator: WatchlistCoordinator
    private var childCoordinators: [Coordinator] = []

    // MARK: - Init

    init(dependencyContainer: any DependencyContainerInterface) {
        self.tabBarController = .init()
        self.rootViewController = tabBarController
        self.marketCoordinator = .init(dependencyContainer: dependencyContainer)
        self.watchlistCoordinator = .init(dependencyContainer: dependencyContainer)
    }

    // MARK: - Public methods

    func start() -> UIViewController {
        let controllers: [UIViewController] = [
            createFlowController(coordinator: marketCoordinator, tab: .market),
            createFlowController(coordinator: watchlistCoordinator, tab: .watchlist)
        ]

        childCoordinators = [
            marketCoordinator,
            watchlistCoordinator
        ]
        tabBarController.setViewControllers(controllers, animated: false)
        return rootViewController
    }

    func selectTab(_ tab: MainTab) {
        tabBarController.selectedIndex = tab.rawValue
    }
}

// MARK: - Private methods

private extension MainCoordinator {

    func createFlowController(coordinator: Coordinator, tab: MainTab) -> UIViewController {
        let viewController: UIViewController = coordinator.start()
        viewController.tabBarItem = .init(title: tab.title, image: tab.icon, selectedImage: tab.selectedIcon)
        viewController.tabBarItem.tag = tab.rawValue
        return viewController
    }
}
