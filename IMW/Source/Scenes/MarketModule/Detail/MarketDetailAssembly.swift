//
//  MarketDetailAssembly.swift
//  IMW
//
//  Created by Марат Саляхетдинов on 03.06.2026.
//

@MainActor
enum MarketDetailAssembly {

    static func makeViewController(_ injection: MarketDetailModel.InjectionModel) -> MarketDetailViewController {
        let viewController: MarketDetailViewController = .init()
        configurate(viewController, injection)
        return viewController
    }

    private static func configurate(_ vc: MarketDetailDisplayLogic, _ injection: MarketDetailModel.InjectionModel) {
        let worker: MarketDetailWorkerInterface = MarketDetailWorker(restClient: injection.restClient, imageLoader: injection.imageLoader, storageClient: injection.storageClient)
        let mapper: MarketDetailMapperInterface = MarketDetailMapper()
        let presenter: MarketDetailPresenter = .init(injection, worker: worker, mapper: mapper)
        vc.presenter = presenter
        presenter.viewController = vc
    }
}
