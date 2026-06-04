//
//  MarketListPresenter.swift
//  IMW
//
//  Created by Марат Саляхетдинов on 01.06.2026.
//

import AppCore
import Foundation
import UIKit

@MainActor
protocol MarketListPresentationProtocol: AnyObject {
    var viewController: MarketListDisplayLogic? { get set }

    func viewDidLoad()
    func refreshData()
    func loadNextData()
    func selectAsset(at index: Int)
    func retryDataLoading()
    func cancelTasks()
}

@MainActor
final class MarketListPresenter: MarketListPresentationProtocol {

    private enum TaskKey: Hashable {
        case cachedMarketList
        case marketList
    }

    // MARK: - MVP Variables

    weak var viewController: MarketListDisplayLogic?

    // MARK: - Managers

    private let worker: MarketListWorkerInterface
    private let mapper: MarketListMapperInterface
    private let coordinator: any MarketCoordinatorInterface

    // MARK: - Logic Variables

    private let paginator: Pagination = .init(limit: 50)
    private let taskBox: TaskBox<TaskKey> = .init()
    private var isLoading: Bool = false

    // MARK: - Data Properties

    private var assets: [MarketListDomain] = []
    private var assetImages: [String: UIImage] = [:]

    // MARK: - Init

    init(worker: MarketListWorkerInterface, mapper: MarketListMapperInterface, coordinator: any MarketCoordinatorInterface) {
        self.worker = worker
        self.mapper = mapper
        self.coordinator = coordinator
    }

    // MARK: - Delegate Methods

    func viewDidLoad() {
        loadCachedMarketList()
        loadMarketList(shouldReset: true)
    }

    func refreshData() {
        loadMarketList(shouldReset: true)
    }

    func loadNextData() {
        guard paginator.canLoadNext else {
            displayCurrentAssets()
            return
        }

        loadMarketList(shouldReset: false)
    }

    func selectAsset(at index: Int) {
        guard assets.indices.contains(index) else { return }
        coordinator.showDetail(id: assets[index].id)
    }

    func retryDataLoading() {
        refreshData()
    }

    func cancelTasks() {
        taskBox.cancelAll()
        isLoading = false
    }
}

// MARK: - Private Methods

private extension MarketListPresenter {

    func loadCachedMarketList() {
        guard assets.isEmpty else { return }

        let task: Task<Void, Never> = Task { [weak self] in
            guard let self else { return }

            do {
                let cachedAssets: [MarketListDomain] = try await worker.fetchCachedMarketList()
                guard assets.isEmpty, cachedAssets.isEmpty == false else { return }

                let images: [String: UIImage] = await loadImages(for: cachedAssets)
                guard Task.isCancelled == false else { return }

                assetImages.merge(images) { _, new in new }
                assets = cachedAssets
                displayCurrentAssets()
            } catch is CancellationError {
                return
            } catch {
                AppLogger.dump(error, name: "Market list cached fetch error")
            }
        }

        taskBox.set(task, for: .cachedMarketList)
    }

    func loadMarketList(shouldReset: Bool) {
        guard isLoading == false else {
            displayCurrentAssets()
            return
        }

        if shouldReset {
            paginator.reset()
            assetImages.removeAll()
        } else {
            guard paginator.canLoadNext else {
                displayCurrentAssets()
                return
            }
        }

        let request: PaginationRequest = paginator.request
        let page: Int = request.offset / request.limit + 1

        isLoading = true

        let task: Task<Void, Never> = Task { [weak self] in
            guard let self else { return }

            do {
                let response: [APINamespaces.MarketList.Response] = try await worker.fetchMarketList(page: page, perPage: request.limit)
                let domains: [MarketListDomain] = mapper.mapToDomain(response)
                let images: [String: UIImage] = await loadImages(for: domains)
                guard Task.isCancelled == false else {
                    isLoading = false
                    return
                }

                assetImages.merge(images) { _, new in new }
                paginator.handleLoadedItemsCount(domains.count)
                assets = shouldReset ? domains : assets + domains
                isLoading = false
                displayCurrentAssets()

                do {
                    try await worker.cacheMarketList(domains, shouldReplaceExistingCache: shouldReset)
                } catch {
                    AppLogger.dump(error, name: "Market list cache save error")
                }
            } catch is CancellationError {
                isLoading = false
            } catch {
                isLoading = false
                viewController?.displayError(error.localizedDescription)
            }
        }

        taskBox.set(task, for: .marketList)
    }

    func loadImages(for domains: [MarketListDomain]) async -> [String: UIImage] {
        await withTaskGroup(of: (String, UIImage)?.self) { [worker] group in
            domains.forEach { domain in
                guard let imageURL: URL = domain.imageURL else { return }

                group.addTask {
                    do {
                        let image: UIImage = try await worker.fetchImage(for: imageURL)
                        return (domain.id, image)
                    } catch is CancellationError {
                        return nil
                    } catch {
                        AppLogger.dump(error, name: "Market list image fetch error")
                        return nil
                    }
                }
            }

            var images: [String: UIImage] = [:]

            for await result in group {
                guard let result else { continue }
                images[result.0] = result.1
            }

            return images
        }
    }

    func displayCurrentAssets() {
        viewController?.displayMarketList(mapper.mapToViewModel(assets, images: assetImages))
    }
}
