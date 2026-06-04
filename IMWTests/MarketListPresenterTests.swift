//
//  MarketListPresenterTests.swift
//  IMWTests
//
//  Created by Марат Саляхетдинов on 04.06.2026.
//

import UIKit
import XCTest
@testable import IMW

@MainActor
final class MarketListPresenterTests: XCTestCase {

    // MARK: - Tests

    func testViewDidLoadDisplaysCachedAssetsBeforeNetworkResponse() async {
        let worker: MarketListWorkerMock = .init()
        let mapper: MarketListMapperMock = .init()
        let viewController: MarketListDisplayLogicMock = .init()
        let networkGate: MarketListFetchGate = .init()
        let presenter: MarketListPresenter = makePresenter(worker: worker, mapper: mapper, viewController: viewController)

        worker.cachedMarketList = [makeDomain(id: "cached")]
        worker.fetchMarketListHandler = { _, _ in
            try await networkGate.wait()
        }

        let cacheDisplayExpectation: XCTestExpectation = .init(description: "Cached market list displayed")
        let networkStartedExpectation: XCTestExpectation = .init(description: "Network request started")

        var cacheDisplayFulfilled: Bool = false
        viewController.onDisplayMarketList = {
            guard cacheDisplayFulfilled == false,
                  viewController.displayedViewModels.last?.items.map(\.id) == ["cached"] else { return }

            cacheDisplayFulfilled = true
            cacheDisplayExpectation.fulfill()
        }

        networkGate.onStarted = {
            networkStartedExpectation.fulfill()
        }

        presenter.viewDidLoad()

        await fulfillment(of: [cacheDisplayExpectation, networkStartedExpectation], timeout: 1)

        let networkDisplayExpectation: XCTestExpectation = .init(description: "Network market list displayed")
        var networkDisplayFulfilled: Bool = false
        viewController.onDisplayMarketList = {
            guard networkDisplayFulfilled == false,
                  viewController.displayedViewModels.last?.items.map(\.id) == ["network"] else { return }

            networkDisplayFulfilled = true
            networkDisplayExpectation.fulfill()
        }

        networkGate.resume(returning: [makeResponse(id: "network")])

        await fulfillment(of: [networkDisplayExpectation], timeout: 1)

        XCTAssertEqual(viewController.displayedViewModels.first?.items.map(\.id), ["cached"])
        XCTAssertEqual(viewController.displayedViewModels.last?.items.map(\.id), ["network"])
    }

    func testRefreshDataResetsPaginationAndLoadsFirstPage() async {
        let worker: MarketListWorkerMock = .init()
        let mapper: MarketListMapperMock = .init()
        let viewController: MarketListDisplayLogicMock = .init()
        let presenter: MarketListPresenter = makePresenter(worker: worker, mapper: mapper, viewController: viewController)

        worker.marketListResponses = [
            makeResponses(prefix: "page-1", count: 50),
            makeResponses(prefix: "page-2", count: 50),
            makeResponses(prefix: "refresh", count: 50)
        ]

        let firstPageExpectation: XCTestExpectation = expectation(forFirstDisplayedID: "page-1-0", viewController: viewController)
        presenter.refreshData()
        await fulfillment(of: [firstPageExpectation], timeout: 1)

        let secondPageExpectation: XCTestExpectation = expectation(forFirstDisplayedID: "page-1-0", expectedItemsCount: 100, viewController: viewController)
        presenter.loadNextData()
        await fulfillment(of: [secondPageExpectation], timeout: 1)

        let refreshCacheExpectation: XCTestExpectation = .init(description: "Refresh cache saved")
        worker.onCacheMarketList = {
            guard worker.cacheMarketListCalls.last?.ids.first == "refresh-0",
                  worker.cacheMarketListCalls.last?.shouldReplaceExistingCache == true else { return }

            refreshCacheExpectation.fulfill()
        }

        let refreshExpectation: XCTestExpectation = expectation(forFirstDisplayedID: "refresh-0", viewController: viewController)
        presenter.refreshData()
        await fulfillment(of: [refreshExpectation, refreshCacheExpectation], timeout: 1)

        XCTAssertEqual(worker.fetchMarketListCalls.map { $0.page }, [1, 2, 1])
        XCTAssertEqual(worker.cacheMarketListCalls.last?.ids.first, "refresh-0")
        XCTAssertEqual(worker.cacheMarketListCalls.last?.shouldReplaceExistingCache, true)
        XCTAssertEqual(viewController.displayedViewModels.last?.items.count, 50)
    }

    func testRefreshDataRemovesImagesLoadedBeforeRefresh() async {
        let worker: MarketListWorkerMock = .init()
        let mapper: MarketListMapperMock = .init()
        let viewController: MarketListDisplayLogicMock = .init()
        let presenter: MarketListPresenter = makePresenter(worker: worker, mapper: mapper, viewController: viewController)

        worker.marketListResponses = [
            makeResponses(prefix: "old", count: 50, imageIndexes: [0]),
            makeResponses(prefix: "refresh", count: 50, imageIndexes: [0])
        ]

        let oldDisplayExpectation: XCTestExpectation = expectation(forFirstDisplayedID: "old-0", viewController: viewController)
        presenter.refreshData()
        await fulfillment(of: [oldDisplayExpectation], timeout: 1)

        let refreshDisplayExpectation: XCTestExpectation = expectation(forFirstDisplayedID: "refresh-0", viewController: viewController)
        presenter.refreshData()
        await fulfillment(of: [refreshDisplayExpectation], timeout: 1)

        XCTAssertEqual(worker.fetchMarketListCalls.map { $0.page }, [1, 1])
        XCTAssertFalse(mapper.receivedImageKeys.last?.contains("old-0") ?? true)
        XCTAssertTrue(mapper.receivedImageKeys.last?.contains("refresh-0") ?? false)
    }

    func testLoadNextDataDoesNotRequestNetworkWhenLastPageWasLoaded() async {
        let worker: MarketListWorkerMock = .init()
        let mapper: MarketListMapperMock = .init()
        let viewController: MarketListDisplayLogicMock = .init()
        let presenter: MarketListPresenter = makePresenter(worker: worker, mapper: mapper, viewController: viewController)

        worker.marketListResponses = [
            makeResponses(prefix: "last-page", count: 10)
        ]

        let firstDisplayExpectation: XCTestExpectation = expectation(forFirstDisplayedID: "last-page-0", viewController: viewController)
        presenter.refreshData()
        await fulfillment(of: [firstDisplayExpectation], timeout: 1)

        presenter.loadNextData()

        XCTAssertEqual(worker.fetchMarketListCalls.map { $0.page }, [1])
        XCTAssertEqual(viewController.displayedViewModels.last?.items.map(\.id), viewController.displayedViewModels.first?.items.map(\.id))
    }

    func testRefreshAndPaginationDoNotStartSecondRequestWhileLoading() async {
        let worker: MarketListWorkerMock = .init()
        let mapper: MarketListMapperMock = .init()
        let viewController: MarketListDisplayLogicMock = .init()
        let networkGate: MarketListFetchGate = .init()
        let presenter: MarketListPresenter = makePresenter(worker: worker, mapper: mapper, viewController: viewController)

        worker.fetchMarketListHandler = { _, _ in
            try await networkGate.wait()
        }

        let networkStartedExpectation: XCTestExpectation = .init(description: "Network request started")
        networkGate.onStarted = {
            networkStartedExpectation.fulfill()
        }

        presenter.refreshData()
        await fulfillment(of: [networkStartedExpectation], timeout: 1)

        presenter.refreshData()
        presenter.loadNextData()

        XCTAssertEqual(worker.fetchMarketListCalls.count, 1)

        let displayExpectation: XCTestExpectation = expectation(forFirstDisplayedID: "loaded-0", viewController: viewController)
        networkGate.resume(returning: [makeResponse(id: "loaded-0")])
        await fulfillment(of: [displayExpectation], timeout: 1)

        XCTAssertEqual(worker.fetchMarketListCalls.count, 1)
    }
}

// MARK: - Private methods

private extension MarketListPresenterTests {

    func makePresenter(worker: MarketListWorkerMock, mapper: MarketListMapperMock, viewController: MarketListDisplayLogicMock) -> MarketListPresenter {
        let presenter: MarketListPresenter = .init(worker: worker, mapper: mapper, coordinator: MarketCoordinatorMock())
        presenter.viewController = viewController
        viewController.presenter = presenter
        return presenter
    }

    func expectation(forFirstDisplayedID id: String, expectedItemsCount: Int? = nil, viewController: MarketListDisplayLogicMock) -> XCTestExpectation {
        let expectation: XCTestExpectation = .init(description: "Market list displayed with first id \(id)")
        var isFulfilled: Bool = false

        viewController.onDisplayMarketList = {
            guard isFulfilled == false,
                  viewController.displayedViewModels.last?.items.first?.id == id else { return }

            if let expectedItemsCount {
                guard viewController.displayedViewModels.last?.items.count == expectedItemsCount else { return }
            }

            isFulfilled = true
            expectation.fulfill()
        }

        return expectation
    }

    func makeDomain(id: String, imageURL: URL? = nil) -> MarketListDomain {
        .init(id: id, symbol: id, name: id, imageURL: imageURL, currentPrice: 1, marketCap: 1, marketCapRank: 1, totalVolume: 1, high24h: 1, low24h: 1, priceChange24h: 1, priceChangePercentage24h: 1)
    }

    func makeResponse(id: String, imageURL: URL? = nil) -> APINamespaces.MarketList.Response {
        .init(id: id, symbol: id, name: id, image: imageURL?.absoluteString, currentPrice: 1, marketCap: 1, marketCapRank: 1, totalVolume: 1, high24h: 1, low24h: 1, priceChange24h: 1, priceChangePercentage24h: 1)
    }

    func makeResponses(prefix: String, count: Int, imageIndexes: Set<Int> = []) -> [APINamespaces.MarketList.Response] {
        (0..<count).map {
            let id: String = "\(prefix)-\($0)"
            let imageURL: URL? = imageIndexes.contains($0) ? URL(string: "https://example.com/\(id).png") : nil
            return makeResponse(id: id, imageURL: imageURL)
        }
    }
}

// MARK: - Mocks

@MainActor
private final class MarketListWorkerMock: MarketListWorkerInterface {

    // MARK: - Public properties

    var cachedMarketList: [MarketListDomain] = []
    var marketListResponses: [[APINamespaces.MarketList.Response]] = []
    var fetchMarketListHandler: ((Int, Int) async throws -> [APINamespaces.MarketList.Response])?
    var onCacheMarketList: (() -> Void)?

    private(set) var fetchMarketListCalls: [(page: Int, perPage: Int)] = []
    private(set) var fetchCachedMarketListCallCount: Int = 0
    private(set) var cacheMarketListCalls: [(ids: [String], shouldReplaceExistingCache: Bool)] = []

    // MARK: - Public methods

    func fetchMarketList(page: Int, perPage: Int) async throws -> [APINamespaces.MarketList.Response] {
        fetchMarketListCalls.append((page: page, perPage: perPage))

        if let fetchMarketListHandler {
            return try await fetchMarketListHandler(page, perPage)
        }

        guard marketListResponses.isEmpty == false else { return [] }
        return marketListResponses.removeFirst()
    }

    func fetchCachedMarketList() async throws -> [MarketListDomain] {
        fetchCachedMarketListCallCount += 1
        return cachedMarketList
    }

    func cacheMarketList(_ domains: [MarketListDomain], shouldReplaceExistingCache: Bool) async throws {
        cacheMarketListCalls.append((ids: domains.map(\.id), shouldReplaceExistingCache: shouldReplaceExistingCache))
        onCacheMarketList?()
    }

    func fetchImage(for url: URL) async throws -> UIImage {
        UIImage()
    }
}

@MainActor
private final class MarketListMapperMock: MarketListMapperInterface {

    // MARK: - Public properties

    private(set) var receivedImageKeys: [Set<String>] = []

    // MARK: - Public methods

    func mapToDomain(_ response: [APINamespaces.MarketList.Response]) -> [MarketListDomain] {
        response.map {
            .init(id: $0.id, symbol: $0.symbol, name: $0.name, imageURL: $0.image.flatMap(URL.init(string:)), currentPrice: $0.currentPrice, marketCap: $0.marketCap, marketCapRank: $0.marketCapRank, totalVolume: $0.totalVolume, high24h: $0.high24h, low24h: $0.low24h, priceChange24h: $0.priceChange24h, priceChangePercentage24h: $0.priceChangePercentage24h)
        }
    }

    func mapToViewModel(_ domains: [MarketListDomain], images: [String: UIImage]) -> MarketListModel.ViewModel {
        receivedImageKeys.append(Set(images.keys))
        return .init(items: domains.map { .init(id: $0.id, title: $0.name, subtitle: $0.symbol, priceText: "", priceChangeText: "", priceChangeColor: .secondaryLabel, rankText: "", image: images[$0.id]) })
    }
}

@MainActor
private final class MarketListDisplayLogicMock: MarketListDisplayLogic {

    // MARK: - Public properties

    var presenter: MarketListPresentationProtocol!
    var onDisplayMarketList: (() -> Void)?

    private(set) var displayedViewModels: [MarketListModel.ViewModel] = []
    private(set) var displayedErrors: [String] = []

    // MARK: - Public methods

    func showLoading() {}

    func hideLoading() {}

    func showEmptyResult() {}

    func hideEmptyResult() {}

    func showErrorAlert(_ message: String, retryHandler: (() -> Void)?) {}

    func displayMarketList(_ viewModel: MarketListModel.ViewModel) {
        displayedViewModels.append(viewModel)
        onDisplayMarketList?()
    }

    func displayError(_ message: String) {
        displayedErrors.append(message)
    }
}

@MainActor
private final class MarketCoordinatorMock: MarketCoordinatorInterface {

    // MARK: - Public properties

    let rootViewController: UIViewController = .init()
    private(set) var shownDetailIDs: [String] = []

    // MARK: - Init

    init() {}

    required init(dependencyContainer: any DependencyContainerInterface) {
        fatalError("init(dependencyContainer:) has not been implemented")
    }

    // MARK: - Public methods

    func start() -> UIViewController {
        rootViewController
    }

    func showDetail(id: String) {
        shownDetailIDs.append(id)
    }
}

@MainActor
private final class MarketListFetchGate {

    // MARK: - Public properties

    var onStarted: (() -> Void)?

    // MARK: - Private properties

    private var continuation: CheckedContinuation<[APINamespaces.MarketList.Response], Error>?

    // MARK: - Public methods

    func wait() async throws -> [APINamespaces.MarketList.Response] {
        guard continuation == nil else {
            XCTFail("MarketListFetchGate already has a pending request")
            return []
        }

        return try await withCheckedThrowingContinuation {
            continuation = $0
            onStarted?()
        }
    }

    func resume(returning response: [APINamespaces.MarketList.Response]) {
        guard let continuation else {
            XCTFail("MarketListFetchGate has no pending request")
            return
        }

        continuation.resume(returning: response)
        continuation = nil
    }
}
