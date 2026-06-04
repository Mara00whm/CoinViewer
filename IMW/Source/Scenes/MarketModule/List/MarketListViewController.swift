//
//  MarketListViewController.swift
//  IMW
//
//  Created by Марат Саляхетдинов on 01.06.2026.
//

import AppUICore
import SnapKit
import UIKit

@MainActor
protocol MarketListDisplayLogic: BaseViewControllerInterface {
    var presenter: MarketListPresentationProtocol! { get set }

    func displayMarketList(_ viewModel: MarketListModel.ViewModel)
    func displayError(_ message: String)
}

final class MarketListViewController: BaseViewController {

    // MARK: - MVP Variables
    
    var presenter: MarketListPresentationProtocol!
    
    // MARK: - Data Properties

    private var viewModel: MarketListModel.ViewModel = .init(items: [])

    // MARK: - UI Elements

    private lazy var tableView: AppTableView = .init(settings: .init(withRefreshing: true, withPagination: true, contentInset: .init(top: 8, left: 0, bottom: 16, right: 0), interRowsSpacing: 0, interSectionsSpacing: 0))
    private let headerView: UIView = .init()
    private let titleLabel: AppLabel = .init(settings: .init(labelType: .bigBold, color: .label, numberOfLines: 1))
    private let subtitleLabel: AppLabel = .init(settings: .init(labelType: .titleWithAlpha, color: .secondaryLabel, numberOfLines: 1))
    private let loadingView: SkeletonLoadingView = .init(type: .list)

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

// MARK: - Private Methods

private extension MarketListViewController {
    
    func setupView() {
        title = "Market"
        view.backgroundColor = .systemBackground
        setupTableView()
        setupHeaderView()
        setupLoadingView()
    }

    func setupTableView() {
        tableView.tableDelegate = self
        view.addSubview(tableView)

        tableView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }

    func setupHeaderView() {
        titleLabel.text = "Markets"
        subtitleLabel.text = "Top assets by market cap"

        [titleLabel, subtitleLabel].forEach {
            headerView.addSubview($0)
        }

        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(16)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().inset(16)
        }
        
        subtitleLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(4)
            $0.leading.equalTo(titleLabel.snp.leading)
            $0.trailing.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().inset(12)
        }
    }

    func setupLoadingView() {
        view.addSubview(loadingView)

        loadingView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

// MARK: - MarketListDisplayLogic

extension MarketListViewController: MarketListDisplayLogic {

    func displayMarketList(_ viewModel: MarketListModel.ViewModel) {
        hideLoading()
        self.viewModel = viewModel
        tableView.reload()

        if viewModel.items.isEmpty {
            showEmptyResult()
        } else {
            hideEmptyResult()
        }
    }

    func displayError(_ message: String) {
        hideLoading()
        tableView.reload()
        showErrorAlert(message) { [weak self] in
            self?.showLoading()
            self?.presenter.retryDataLoading()
        }
    }
}

// MARK: - AppTableDelegate

extension MarketListViewController: AppTableDelegate {

    func getSectionsCount() -> Int {
        1
    }

    func getCellsCountIn(section: Int) -> Int {
        viewModel.items.count
    }

    func getUnitViewForCellWith(indexPath: IndexPath) -> (UIView & AppTableUnitView)? {
        guard viewModel.items.indices.contains(indexPath.row) else { return nil }

        let item: MarketListModel.ItemViewModel = viewModel.items[indexPath.row]
        return MarketAssetUnitView(viewModel: item)
    }

    func getCellStyle(at indexPath: IndexPath, position: AppTableRowPosition) -> AppTableCellStyle {
        .init(container: .plain, separator: .separator(color: .separator.withAlphaComponent(0.35), insets: .init(top: 0, left: 16, bottom: 0, right: 16)))
    }

    func getTableHeaderView() -> UIView? {
        headerView
    }

    func refreshData() {
        presenter.refreshData()
    }

    func loadNextData() {
        presenter.loadNextData()
    }

    func handleActionAtCell(_ indexPath: IndexPath) {
        presenter.selectAsset(at: indexPath.row)
    }
}
