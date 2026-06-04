//
//  MarketDetailStatsSectionView.swift
//  IMW
//
//  Created by Марат Саляхетдинов on 04.06.2026.
//

import AppUICore
import SnapKit
import UIKit

final class MarketDetailStatsSectionView: UIStackView {

    // MARK: - UI Elements

    private let titleLabel: AppLabel = .init(settings: .init(labelType: .header, color: .label, numberOfLines: 1))
    private let statsStackView: UIStackView = .init()

    // MARK: - Init

    init() {
        super.init(frame: .zero)
        setupView()
        setupStatsStackView()
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public methods

    func configure(_ stats: [MarketDetailModel.StatViewModel]) {
        statsStackView.removeArrangedSubviews()

        for index in stride(from: 0, to: stats.count, by: 2) {
            let rowStackView: UIStackView = makeRowStackView()
            rowStackView.addArrangedSubview(MarketDetailStatView(viewModel: stats[index]))

            if stats.indices.contains(index + 1) {
                rowStackView.addArrangedSubview(MarketDetailStatView(viewModel: stats[index + 1]))
            } else {
                rowStackView.addArrangedSubview(UIView())
            }

            statsStackView.addArrangedSubview(rowStackView)
        }
    }
}

// MARK: - Private methods

private extension MarketDetailStatsSectionView {

    func setupView() {
        titleLabel.text = "Market statistics"
        axis = .vertical
        spacing = 12
        addArrangedSubview(titleLabel)
        addArrangedSubview(statsStackView)
    }

    func setupStatsStackView() {
        statsStackView.axis = .vertical
        statsStackView.spacing = 8
    }

    func makeRowStackView() -> UIStackView {
        let rowStackView: UIStackView = .init()
        rowStackView.axis = .horizontal
        rowStackView.spacing = 8
        rowStackView.distribution = .fillEqually
        return rowStackView
    }
}

private final class MarketDetailStatView: UIView {

    // MARK: - UI Elements

    private let titleLabel: AppLabel = .init(settings: .init(labelType: .descriptionWithAlpha, color: .secondaryLabel, numberOfLines: 1))
    private let valueLabel: AppLabel = .init(settings: .init(labelType: .titleBold, color: .label, numberOfLines: 1))
    private let stackView: UIStackView = .init()

    // MARK: - Init

    init(viewModel: MarketDetailModel.StatViewModel) {
        super.init(frame: .zero)
        setupView()
        setupStackView()
        configure(viewModel)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Private methods

    private func setupView() {
        backgroundColor = .secondarySystemBackground
        addBordersAndRoundCornersWith(roundMode: .fully, cornerRadius: 8, color: .separator.withAlphaComponent(0.2))
    }

    private func setupStackView() {
        addSubview(stackView)
        stackView.axis = .vertical
        stackView.spacing = 6
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(valueLabel)

        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(12)
        }
    }

    private func configure(_ viewModel: MarketDetailModel.StatViewModel) {
        titleLabel.text = viewModel.title
        valueLabel.text = viewModel.value
    }
}

private extension UIStackView {

    func removeArrangedSubviews() {
        arrangedSubviews.forEach {
            removeArrangedSubview($0)
            $0.removeFromSuperview()
        }
    }
}
