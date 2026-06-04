//
//  MainTabBarController.swift
//  IMW
//
//  Created by Марат Саляхетдинов on 01.06.2026.
//

import UIKit

final class MainTabBarController: UITabBarController {

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupAppearance()
    }
}

// MARK: - Private methods

private extension MainTabBarController {

    func setupAppearance() {
        let appearance: UITabBarAppearance = .init()
        appearance.configureWithTransparentBackground()
        appearance.backgroundColor = .clear
        appearance.shadowColor = .clear

        tabBar.standardAppearance = appearance
        tabBar.scrollEdgeAppearance = appearance
        tabBar.backgroundColor = .clear
        tabBar.isTranslucent = true
        tabBar.tintColor = .label
        tabBar.unselectedItemTintColor = .secondaryLabel
    }
}
