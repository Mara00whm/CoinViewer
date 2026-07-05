//
//  WatchListAssembly.swift
//  IMW
//
//  Created by Марат Саляхетдинов on 01.06.2026.
//

import UIKit

@MainActor
final class WatchListAssembly {
    
    // MARK: - Public methods

    func createModule(input _: WatchListModel.Input, dependencies: WatchListModel.Dependencies) -> UIViewController {
        let viewController: WatchListViewController = .init()
        configurate(viewController, dependencies: dependencies)
        return viewController
    }
}

// MARK: - Private methods

private extension WatchListAssembly {

    func configurate(_ vc: WatchListDisplayLogic, dependencies: WatchListModel.Dependencies) {
        let worker: WatchListWorkerInterface = WatchListWorker(restClient: dependencies.restClient, imageLoader: dependencies.imageLoader, storageClient: dependencies.storageClient)
        let mapper: WatchListMapperInterface = WatchListMapper(marketListMapper: MarketListMapper())
        let presenter: WatchListPresenter = .init(worker: worker, mapper: mapper, coordinator: dependencies.coordinator)
        vc.presenter = presenter
        presenter.viewController = vc
    }
}
