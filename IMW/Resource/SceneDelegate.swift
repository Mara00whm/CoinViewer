//
//  SceneDelegate.swift
//  IMW
//
//  Created by Марат Саляхетдинов on 01.06.2026.
//

import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    private var mainCoordinator: MainCoordinator?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene: UIWindowScene = scene as? UIWindowScene else { return }

        let window: UIWindow = .init(windowScene: windowScene)
        self.window = window

        Task { @MainActor in
            do {
                let dependencyContainer: DependencyContainer = try await AppBootstrapper.makeDependencyContainer(marketDataAPIKey: AppConfiguration.coinGeckoAPIKey)
                let mainCoordinator: MainCoordinator = .init(dependencyContainer: dependencyContainer)

                window.rootViewController = mainCoordinator.start()
                window.makeKeyAndVisible()

                self.mainCoordinator = mainCoordinator
            } catch {
                assertionFailure(error.localizedDescription)
            }
        }
    }
}
