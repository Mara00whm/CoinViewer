//
//  WatchListAssembly.swift
//  IMW
//
//  Created by Марат Саляхетдинов on 01.06.2026.
//

@MainActor
enum WatchListAssembly {
    
    static func makeViewController(_ injection: WatchListModel.InjectionModel) -> WatchListViewController {
        let viewController: WatchListViewController = .init()
        configurate(viewController, injection)
        return viewController
    }

    private static func configurate(_ vc: WatchListDisplayLogic, _ injection: WatchListModel.InjectionModel) {
        let worker: WatchListWorkerInterface = WatchListWorker(restClient: injection.restClient, imageLoader: injection.imageLoader, storageClient: injection.storageClient)
        let mapper: WatchListMapperInterface = WatchListMapper(marketListMapper: MarketListMapper())
        let presenter: WatchListPresenter = .init(worker: worker, mapper: mapper, coordinator: injection.coordinator)
        vc.presenter = presenter
        presenter.viewController = vc
    }
}
