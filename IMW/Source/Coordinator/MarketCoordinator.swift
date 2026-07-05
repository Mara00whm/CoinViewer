//
//  MarketCoordinator.swift
//  IMW
//
//  Created by Марат Саляхетдинов on 01.06.2026.
//

import UIKit

@MainActor
protocol MarketCoordinatorInterface: Coordinator {
    func showDetail(id: String)
}

@MainActor
final class MarketCoordinator: MarketCoordinatorInterface {

    // MARK: - Public properties

    let rootViewController: UIViewController

    // MARK: - Private properties

    private let container: any MarketContainerInterface
    private let commonContainer: any CommonModuleContainerInterface

    // MARK: - Init

    init(container: any MarketContainerInterface, commonContainer: any CommonModuleContainerInterface) {
        self.container = container
        self.commonContainer = commonContainer
        self.rootViewController = UINavigationController()
    }

    // MARK: - Public methods

    func start() -> UIViewController {
        let viewController: UIViewController = container.createMarketListScreen(coordinator: self)
        navigationRootViewController?.setViewControllers([viewController], animated: false)
        return rootViewController
    }

    func showDetail(id: String) {
        let viewController: UIViewController = commonContainer.createMarketDetailScreen(id: id)
        push(viewController)
    }
}
