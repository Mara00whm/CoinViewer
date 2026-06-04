//
//  MarketDetailContentView.swift
//  IMW
//
//  Created by Марат Саляхетдинов on 04.06.2026.
//

import SnapKit
import UIKit

final class MarketDetailContentView: UIView {

    // MARK: - UI Elements

    private let scrollView: UIScrollView = .init()
    private let contentView: UIView = .init()
    private let contentStackView: UIStackView = .init()
    private let headerView: MarketDetailHeaderView = .init()
    private let priceView: MarketDetailPriceView = .init()
    private let chartSectionView: MarketDetailChartSectionView = .init()
    private let statsSectionView: MarketDetailStatsSectionView = .init()
    private let linksSectionView: MarketDetailLinksSectionView = .init()
    private let categoriesSectionView: MarketDetailTextSectionView = .init(title: "Categories")
    private let descriptionSectionView: MarketDetailTextSectionView = .init(title: "About")

    // MARK: - Computed properties

    var selectedRangeIndex: Int {
        chartSectionView.selectedRangeIndex
    }

    // MARK: - Init

    init() {
        super.init(frame: .zero)
        setupView()
        setupScrollView()
        setupContentStackView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public methods

    func addRangeTarget(_ target: Any?, action: Selector) {
        chartSectionView.addRangeTarget(target, action: action)
    }

    func addWatchlistTarget(_ target: Any?, action: Selector) {
        headerView.addWatchlistTarget(target, action: action)
    }

    func configure(_ viewModel: MarketDetailModel.ViewModel, linkTarget: Any?, linkAction: Selector) {
        headerView.configure(title: viewModel.title, subtitle: viewModel.subtitle, rankText: viewModel.rankText, image: viewModel.image, isInWatchlist: viewModel.isInWatchlist)
        priceView.configure(priceText: viewModel.priceText, priceChangeText: viewModel.priceChangeText, priceChangeColor: viewModel.priceChangeColor)
        chartSectionView.configure(viewModel.chart)
        statsSectionView.configure(viewModel.stats)
        linksSectionView.configure(viewModel.links, target: linkTarget, action: linkAction)
        categoriesSectionView.configure(text: viewModel.categoriesText, hideWhenEmpty: true)
        descriptionSectionView.configure(text: viewModel.descriptionText, hideWhenEmpty: false)
    }

    func setChartContentView(_ view: UIView) {
        chartSectionView.setChartContentView(view)
    }
}

// MARK: - Private methods

private extension MarketDetailContentView {

    func setupView() {
        backgroundColor = .clear
    }

    func setupScrollView() {
        addSubview(scrollView)
        scrollView.addSubview(contentView)

        scrollView.backgroundColor = .clear
        contentView.backgroundColor = .clear
        scrollView.alwaysBounceVertical = true
        scrollView.showsVerticalScrollIndicator = false

        scrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        contentView.snp.makeConstraints {
            $0.edges.equalTo(scrollView.contentLayoutGuide)
            $0.width.equalTo(scrollView.frameLayoutGuide)
        }
    }

    func setupContentStackView() {
        contentView.addSubview(contentStackView)

        contentStackView.axis = .vertical
        contentStackView.spacing = 20
        contentStackView.alignment = .fill

        [headerView, priceView, chartSectionView, statsSectionView, linksSectionView, categoriesSectionView, descriptionSectionView].forEach {
            contentStackView.addArrangedSubview($0)
        }

        contentStackView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(16)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().inset(24)
        }
    }
}
