//
//  MarketDetailChartSectionView.swift
//  IMW
//
//  Created by Марат Саляхетдинов on 04.06.2026.
//

import AppUICore
import SnapKit
import UIKit

final class MarketDetailChartSectionView: UIStackView {

    // MARK: - UI Elements

    private let rangeControl: UISegmentedControl = .init()
    private let chartContainerView: UIView = .init()

    // MARK: - Computed properties

    var selectedRangeIndex: Int {
        rangeControl.selectedSegmentIndex
    }

    // MARK: - Init

    init() {
        super.init(frame: .zero)
        setupView()
        setupRangeControl()
        setupChartContainerView()
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public methods

    func addRangeTarget(_ target: Any?, action: Selector) {
        rangeControl.addTarget(target, action: action, for: .valueChanged)
    }

    func configure(_ viewModel: MarketDetailModel.ChartViewModel) {
        rangeControl.removeAllSegments()

        for (index, title) in viewModel.rangeTitles.enumerated() {
            rangeControl.insertSegment(withTitle: title, at: index, animated: false)
        }

        guard viewModel.rangeTitles.indices.contains(viewModel.selectedRangeIndex) else { return }
        rangeControl.selectedSegmentIndex = viewModel.selectedRangeIndex
    }

    func setChartContentView(_ view: UIView) {
        chartContainerView.subviews.forEach {
            $0.removeFromSuperview()
        }

        chartContainerView.addSubview(view)
        view.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(12)
        }
    }
}

// MARK: - Private methods

private extension MarketDetailChartSectionView {

    func setupView() {
        axis = .vertical
        spacing = 12
        addArrangedSubview(rangeControl)
        addArrangedSubview(chartContainerView)
    }

    func setupRangeControl() {
        rangeControl.selectedSegmentTintColor = .label
        rangeControl.setTitleTextAttributes([.foregroundColor: UIColor.label], for: .normal)
        rangeControl.setTitleTextAttributes([.foregroundColor: UIColor.systemBackground], for: .selected)
    }

    func setupChartContainerView() {
        chartContainerView.backgroundColor = .secondarySystemBackground
        chartContainerView.addBordersAndRoundCornersWith(roundMode: .fully, cornerRadius: 8, color: .separator.withAlphaComponent(0.2))

        chartContainerView.snp.makeConstraints {
            $0.height.equalTo(220)
        }
    }
}
