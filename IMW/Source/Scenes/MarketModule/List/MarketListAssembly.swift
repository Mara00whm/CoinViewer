//
//  MarketListAssembly.swift
//  IMW
//
//  Created by Марат Саляхетдинов on 01.06.2026.
//

@MainActor
enum MarketListAssembly {

    static func makeViewController(_ injection: MarketListModel.InjectionModel) -> MarketListViewController {
        let viewController: MarketListViewController = .init()
        configurate(viewController, injection)
        return viewController
    }

    private static func configurate(_ vc: MarketListDisplayLogic, _ injection: MarketListModel.InjectionModel) {
        let worker: MarketListWorkerInterface = MarketListWorker(restClient: injection.restClient, imageLoader: injection.imageLoader, storageClient: injection.storageClient)
        let mapper: MarketListMapperInterface = MarketListMapper()
        let presenter: MarketListPresenter = .init(worker: worker, mapper: mapper, coordinator: injection.coordinator)
        vc.presenter = presenter
        presenter.viewController = vc
    }
}
