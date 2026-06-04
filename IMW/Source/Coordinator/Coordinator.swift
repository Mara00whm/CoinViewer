//
//  Coordinator.swift
//  IMW
//
//  Created by Марат Саляхетдинов on 01.06.2026.
//

import UIKit

@MainActor
protocol Coordinator: AnyObject {
    var rootViewController: UIViewController { get }

    func start() -> UIViewController
}

@MainActor
protocol DependencyCoordinatorInterface: Coordinator {
    init(dependencyContainer: any DependencyContainerInterface)
}

extension Coordinator {

    // MARK: - Computed properties

    var navigationRootViewController: UINavigationController? {
        rootViewController as? UINavigationController
    }

    // MARK: - Public methods

    func push(_ viewController: UIViewController, animated: Bool = true) {
        navigationRootViewController?.pushViewController(viewController, animated: animated)
    }

    func present(_ viewController: UIViewController, animated: Bool = true) {
        navigationRootViewController?.topViewController?.present(viewController, animated: animated)
    }

    @discardableResult
    func resetToRoot(animated: Bool) -> Self {
        navigationRootViewController?.popToRootViewController(animated: animated)
        return self
    }
}
