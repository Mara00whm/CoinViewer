//
//  MarketDetailViewController.swift
//  IMW
//
//  Created by Марат Саляхетдинов on 03.06.2026.
//

import SafariServices
import SnapKit
import SwiftUI
import UIKit

@MainActor
protocol MarketDetailDisplayLogic: BaseViewControllerInterface {
    var presenter: MarketDetailPresentationProtocol! { get set }

    func displayDetail(_ viewModel: MarketDetailModel.ViewModel)
    func displayError(_ message: String)
    func openLink(_ url: URL)
}

final class MarketDetailViewController: BaseViewController {

    // MARK: - MVP Variables
    
    var presenter: MarketDetailPresentationProtocol!
    
    // MARK: - Logic Variables

    private var chartHostingController: UIHostingController<MarketPriceChartView>?
    
    // MARK: - UI Elements

    private let detailContentView: MarketDetailContentView = .init()
    private let loadingView: SkeletonLoadingView = .init(type: .detail)

    // MARK: - Init
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
  
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        showLoading()
        presenter.viewDidLoad()
    }

    // MARK: - Public Methods

    override func showLoading() {
        loadingView.show()
    }

    override func hideLoading() {
        loadingView.hide()
    }
}

// MARK: - Actions

@objc private extension MarketDetailViewController {

    func rangeControlDidChange() {
        presenter.selectChartRange(at: detailContentView.selectedRangeIndex)
    }

    func linkButtonDidTap(_ sender: UIControl) {
        presenter.selectLink(at: sender.tag)
    }

    func watchlistButtonDidTap() {
        presenter.toggleWatchlist()
    }
}

// MARK: - Private Methods

private extension MarketDetailViewController {
    
    func setupView() {
        title = "Details"
        view.backgroundColor = .systemGroupedBackground
        setupDetailContentView()
        setupLoadingView()
    }

    func setupDetailContentView() {
        view.addSubview(detailContentView)
        detailContentView.addRangeTarget(self, action: #selector(rangeControlDidChange))
        detailContentView.addWatchlistTarget(self, action: #selector(watchlistButtonDidTap))

        detailContentView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }

    func setupLoadingView() {
        view.addSubview(loadingView)

        loadingView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }

    func applyViewModel(_ viewModel: MarketDetailModel.ViewModel) {
        title = viewModel.title
        detailContentView.configure(viewModel, linkTarget: self, linkAction: #selector(linkButtonDidTap(_:)))
        configureChart(viewModel.chart)
    }

    func configureChart(_ viewModel: MarketDetailModel.ChartViewModel) {
        chartHostingController?.willMove(toParent: nil)
        chartHostingController?.view.removeFromSuperview()
        chartHostingController?.removeFromParent()

        let hostingController: UIHostingController<MarketPriceChartView> = .init(rootView: MarketPriceChartView(viewModel: viewModel))
        hostingController.view.backgroundColor = .clear
        addChild(hostingController)
        detailContentView.setChartContentView(hostingController.view)

        hostingController.didMove(toParent: self)
        chartHostingController = hostingController
    }
}

// MARK: - MarketDetailDisplayLogic

extension MarketDetailViewController: MarketDetailDisplayLogic {

    func displayDetail(_ viewModel: MarketDetailModel.ViewModel) {
        hideLoading()
        hideEmptyResult()
        applyViewModel(viewModel)
    }

    func displayError(_ message: String) {
        hideLoading()
        showErrorAlert(message) { [weak self] in
            self?.showLoading()
            self?.presenter.retryDataLoading()
        }
    }

    func openLink(_ url: URL) {
        let viewController: SFSafariViewController = .init(url: url)
        present(viewController, animated: true)
    }
}
