//
//  MarketDetailAssembly.swift
//  IMW
//
//  Created by Марат Саляхетдинов on 03.06.2026.
//

import UIKit

@MainActor
final class MarketDetailAssembly {

    // MARK: - Public methods

    func createModule(input: MarketDetailModel.Input, dependencies: MarketDetailModel.Dependencies) -> UIViewController {
        let viewController: MarketDetailViewController = .init()
        configurate(viewController, input: input, dependencies: dependencies)
        return viewController
    }
}

// MARK: - Private methods

private extension MarketDetailAssembly {

    func configurate(_ vc: MarketDetailDisplayLogic, input: MarketDetailModel.Input, dependencies: MarketDetailModel.Dependencies) {
        let worker: MarketDetailWorkerInterface = MarketDetailWorker(restClient: dependencies.restClient, imageLoader: dependencies.imageLoader, storageClient: dependencies.storageClient)
        let mapper: MarketDetailMapperInterface = MarketDetailMapper()
        let presenter: MarketDetailPresenter = .init(input: input, worker: worker, mapper: mapper)
        vc.presenter = presenter
        presenter.viewController = vc
    }
}
