//
//  MarketListAssembly.swift
//  IMW
//
//  Created by Марат Саляхетдинов on 01.06.2026.
//

import UIKit

@MainActor
final class MarketListAssembly {

    // MARK: - Public methods

    func createModule(input _: MarketListModel.Input, dependencies: MarketListModel.Dependencies) -> UIViewController {
        let viewController: MarketListViewController = .init()
        configurate(viewController, dependencies: dependencies)
        return viewController
    }
}

// MARK: - Private methods

private extension MarketListAssembly {

    func configurate(_ vc: MarketListDisplayLogic, dependencies: MarketListModel.Dependencies) {
        let worker: MarketListWorkerInterface = MarketListWorker(restClient: dependencies.restClient, imageLoader: dependencies.imageLoader, storageClient: dependencies.storageClient)
        let mapper: MarketListMapperInterface = MarketListMapper()
        let presenter: MarketListPresenter = .init(worker: worker, mapper: mapper, coordinator: dependencies.coordinator)
        vc.presenter = presenter
        presenter.viewController = vc
    }
}
