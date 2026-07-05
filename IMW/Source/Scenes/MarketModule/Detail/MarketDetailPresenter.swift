//
//  MarketDetailPresenter.swift
//  IMW
//
//  Created by Марат Саляхетдинов on 03.06.2026.
//

import AppCore
import Foundation
import UIKit

@MainActor
protocol MarketDetailPresentationProtocol: AnyObject {
    var viewController: MarketDetailDisplayLogic? { get set }

    func viewDidLoad()
    func selectChartRange(at index: Int)
    func selectLink(at index: Int)
    func toggleWatchlist()
    func retryDataLoading()
    func cancelTasks()
}

@MainActor
final class MarketDetailPresenter: MarketDetailPresentationProtocol {

    private enum TaskKey: Hashable {
        case cachedDetail
        case detail
        case cachedChart
        case chart
        case watchlist
    }

    // MARK: - MVP Variables

    weak var viewController: MarketDetailDisplayLogic?

    // MARK: - Managers

    private let worker: MarketDetailWorkerInterface
    private let mapper: MarketDetailMapperInterface

    // MARK: - Logic Variables

    private let taskBox: TaskBox<TaskKey> = .init()
    private let id: String
    private var selectedRange: MarketChartRange = .week
    private var isLoadingDetail: Bool = false
    private var isLoadingChart: Bool = false

    // MARK: - Data Properties

    private var detail: MarketDetailDomain?
    private var chartPoints: [MarketChartPointDomain] = []
    private var detailImage: UIImage?
    private var currentLinks: [MarketDetailModel.LinkViewModel] = []
    private var isInWatchlist: Bool = false

    // MARK: - Init

    init(input: MarketDetailModel.Input, worker: MarketDetailWorkerInterface, mapper: MarketDetailMapperInterface) {
        self.id = input.id
        self.worker = worker
        self.mapper = mapper
    }

    // MARK: - Delegate Methods

    func viewDidLoad() {
        loadWatchlistState()
        loadCachedDetail()
        loadCachedChart(range: selectedRange)
        loadDetail()
        loadChart(range: selectedRange)
    }

    func selectChartRange(at index: Int) {
        guard MarketChartRange.allCases.indices.contains(index) else { return }

        selectedRange = MarketChartRange.allCases[index]
        chartPoints = []
        isLoadingChart = false
        displayCurrentState()
        loadCachedChart(range: selectedRange)
        loadChart(range: selectedRange)
    }

    func selectLink(at index: Int) {
        guard currentLinks.indices.contains(index) else { return }
        viewController?.openLink(currentLinks[index].url)
    }

    func toggleWatchlist() {
        guard let detail else { return }

        let task: Task<Void, Never> = Task { [weak self] in
            guard let self else { return }

            do {
                if isInWatchlist {
                    try await worker.deleteWatchlistAsset(id: detail.id)
                    guard Task.isCancelled == false else { return }
                    isInWatchlist = false
                } else {
                    try await worker.saveWatchlistAsset(mapper.mapToMarketListDomain(detail))
                    guard Task.isCancelled == false else { return }
                    isInWatchlist = true
                }

                displayCurrentState()
            } catch is CancellationError {
                return
            } catch {
                AppLogger.dump(error, name: "Market detail watchlist toggle error")
            }
        }

        taskBox.set(task, for: .watchlist)
    }

    func retryDataLoading() {
        loadDetail()
        loadChart(range: selectedRange)
    }

    func cancelTasks() {
        taskBox.cancelAll()
        isLoadingDetail = false
        isLoadingChart = false
    }
}

// MARK: - Private Methods

private extension MarketDetailPresenter {

    func loadWatchlistState() {
        let task: Task<Void, Never> = Task { [weak self] in
            guard let self else { return }

            do {
                isInWatchlist = try await worker.isWatchlistAssetSaved(id: id)
                guard Task.isCancelled == false else { return }
                displayCurrentState()
            } catch is CancellationError {
                return
            } catch {
                AppLogger.dump(error, name: "Market detail watchlist state error")
            }
        }

        taskBox.set(task, for: .watchlist)
    }

    func loadCachedDetail() {
        let task: Task<Void, Never> = Task { [weak self] in
            guard let self else { return }

            do {
                guard let cachedDetail: MarketDetailDomain = try await worker.fetchCachedMarketDetail(id: id) else { return }
                let image: UIImage? = await loadImageIfNeeded(for: cachedDetail)
                guard Task.isCancelled == false else { return }

                detail = cachedDetail
                detailImage = image
                displayCurrentState()
            } catch is CancellationError {
                return
            } catch {
                AppLogger.dump(error, name: "Market detail cached fetch error")
            }
        }

        taskBox.set(task, for: .cachedDetail)
    }

    func loadDetail() {
        guard isLoadingDetail == false else { return }

        isLoadingDetail = true

        let task: Task<Void, Never> = Task { [weak self] in
            guard let self else { return }

            do {
                let response: APINamespaces.MarketDetail.Response = try await worker.fetchMarketDetail(id: id)
                let domain: MarketDetailDomain = mapper.mapToDomain(response)
                let image: UIImage? = await loadImageIfNeeded(for: domain)
                guard Task.isCancelled == false else {
                    isLoadingDetail = false
                    return
                }

                detail = domain
                detailImage = image
                isLoadingDetail = false
                displayCurrentState()

                do {
                    try await worker.cacheMarketDetail(domain)
                } catch {
                    AppLogger.dump(error, name: "Market detail cache save error")
                }
            } catch is CancellationError {
                isLoadingDetail = false
            } catch {
                isLoadingDetail = false
                viewController?.displayError(error.localizedDescription)
            }
        }

        taskBox.set(task, for: .detail)
    }

    func loadCachedChart(range: MarketChartRange) {
        let task: Task<Void, Never> = Task { [weak self] in
            guard let self else { return }

            do {
                let cachedPoints: [MarketChartPointDomain] = try await worker.fetchCachedMarketChart(id: id, range: range)
                guard selectedRange == range, cachedPoints.isEmpty == false else { return }
                guard Task.isCancelled == false else { return }

                chartPoints = cachedPoints
                displayCurrentState()
            } catch is CancellationError {
                return
            } catch {
                AppLogger.dump(error, name: "Market chart cached fetch error")
            }
        }

        taskBox.set(task, for: .cachedChart)
    }

    func loadChart(range: MarketChartRange) {
        guard isLoadingChart == false else { return }

        isLoadingChart = true

        let task: Task<Void, Never> = Task { [weak self] in
            guard let self else { return }

            do {
                let response: APINamespaces.MarketChart.Response = try await worker.fetchMarketChart(id: id, range: range)
                let points: [MarketChartPointDomain] = mapper.mapToChartPoints(response)
                guard Task.isCancelled == false else {
                    if selectedRange == range {
                        isLoadingChart = false
                    }
                    return
                }

                guard selectedRange == range else {
                    isLoadingChart = false
                    return
                }

                chartPoints = points
                isLoadingChart = false
                displayCurrentState()

                do {
                    try await worker.cacheMarketChart(points, coinID: id, range: range)
                } catch {
                    AppLogger.dump(error, name: "Market chart cache save error")
                }
            } catch is CancellationError {
                if selectedRange == range {
                    isLoadingChart = false
                }
            } catch {
                isLoadingChart = false
                viewController?.displayError(error.localizedDescription)
            }
        }

        taskBox.set(task, for: .chart)
    }

    func loadImageIfNeeded(for domain: MarketDetailDomain) async -> UIImage? {
        guard let imageURL: URL = domain.imageURL else { return nil }

        do {
            return try await worker.fetchImage(for: imageURL)
        } catch is CancellationError {
            return nil
        } catch {
            AppLogger.dump(error, name: "Market detail image fetch error")
            return nil
        }
    }

    func displayCurrentState() {
        guard let detail else { return }

        let viewModel: MarketDetailModel.ViewModel = mapper.mapToViewModel(detail, image: detailImage, chartPoints: chartPoints, selectedRange: selectedRange, isInWatchlist: isInWatchlist)
        currentLinks = viewModel.links
        viewController?.displayDetail(viewModel)
    }
}
