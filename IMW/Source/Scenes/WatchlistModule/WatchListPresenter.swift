//
//  WatchListPresenter.swift
//  IMW
//
//  Created by Марат Саляхетдинов on 01.06.2026.
//

import AppCore
import Foundation
import UIKit

@MainActor
protocol WatchListPresentationProtocol: AnyObject {
    var viewController: WatchListDisplayLogic? { get set }

    func viewDidLoad()
    func viewWillAppear()
    func refreshData()
    func selectAsset(at index: Int)
    func retryDataLoading()
    func cancelTasks()
}

@MainActor
final class WatchListPresenter: WatchListPresentationProtocol {

    private enum TaskKey: Hashable {
        case cachedWatchlist
        case watchlist
    }

    // MARK: - MVP Variables

    weak var viewController: WatchListDisplayLogic?

    // MARK: - Managers

    private let worker: WatchListWorkerInterface
    private let mapper: WatchListMapperInterface
    private let coordinator: any WatchlistCoordinatorInterface

    // MARK: - Logic Variables

    private let taskBox: TaskBox<TaskKey> = .init()
    private var isLoading: Bool = false

    // MARK: - Data Properties

    private var assets: [MarketListDomain] = []
    private var assetImages: [String: UIImage] = [:]

    // MARK: - Init

    init(worker: WatchListWorkerInterface, mapper: WatchListMapperInterface, coordinator: any WatchlistCoordinatorInterface) {
        self.worker = worker
        self.mapper = mapper
        self.coordinator = coordinator
    }

    // MARK: - Delegate Methods

    func viewDidLoad() {
        loadCachedWatchlist(shouldForce: false)
        refreshWatchlist()
    }

    func viewWillAppear() {
        loadCachedWatchlist(shouldForce: true)
    }

    func refreshData() {
        refreshWatchlist()
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

private extension WatchListPresenter {

    func loadCachedWatchlist(shouldForce: Bool) {
        guard shouldForce || assets.isEmpty else { return }

        let task: Task<Void, Never> = Task { [weak self] in
            guard let self else { return }

            do {
                let cachedAssets: [MarketListDomain] = try await worker.fetchCachedWatchlist()
                let images: [String: UIImage] = await loadImages(for: cachedAssets)
                guard Task.isCancelled == false else { return }

                assets = cachedAssets
                assetImages = images
                displayCurrentAssets()
            } catch is CancellationError {
                return
            } catch {
                AppLogger.dump(error, name: "Watchlist cached fetch error")
            }
        }

        taskBox.set(task, for: .cachedWatchlist)
    }

    func refreshWatchlist() {
        guard isLoading == false else {
            displayCurrentAssets()
            return
        }

        isLoading = true

        let task: Task<Void, Never> = Task { [weak self] in
            guard let self else { return }

            do {
                let cachedAssets: [MarketListDomain]

                do {
                    cachedAssets = try await worker.fetchCachedWatchlist()
                } catch is CancellationError {
                    isLoading = false
                    return
                } catch {
                    AppLogger.dump(error, name: "Watchlist cached refresh fetch error")
                    isLoading = false
                    displayCurrentAssets()
                    return
                }

                let ids: [String] = cachedAssets.map(\.id)

                guard ids.isEmpty == false else {
                    assets = []
                    assetImages.removeAll()
                    isLoading = false
                    displayCurrentAssets()
                    return
                }

                let response: [APINamespaces.MarketList.Response] = try await worker.fetchWatchlist(ids: ids)
                let domains: [MarketListDomain] = sortedDomains(mapper.mapToDomain(response), ids: ids)
                let images: [String: UIImage] = await loadImages(for: domains)
                guard Task.isCancelled == false else {
                    isLoading = false
                    return
                }

                assets = domains
                assetImages = images
                isLoading = false
                displayCurrentAssets()

                do {
                    try await worker.cacheWatchlist(domains)
                } catch {
                    AppLogger.dump(error, name: "Watchlist cache save error")
                }
            } catch is CancellationError {
                isLoading = false
            } catch {
                isLoading = false
                viewController?.displayError(error.localizedDescription)
            }
        }

        taskBox.set(task, for: .watchlist)
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
                        AppLogger.dump(error, name: "Watchlist image fetch error")
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

    func sortedDomains(_ domains: [MarketListDomain], ids: [String]) -> [MarketListDomain] {
        let orderIndexes: [String: Int] = Dictionary(uniqueKeysWithValues: ids.enumerated().map { ($0.element, $0.offset) })
        return domains.sorted { (orderIndexes[$0.id] ?? Int.max) < (orderIndexes[$1.id] ?? Int.max) }
    }

    func displayCurrentAssets() {
        viewController?.displayWatchlist(mapper.mapToViewModel(assets, images: assetImages))
    }
}
