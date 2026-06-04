//
//  MarketDetailPriceView.swift
//  IMW
//
//  Created by Марат Саляхетдинов on 04.06.2026.
//

import AppUICore
import UIKit

final class MarketDetailPriceView: UIStackView {

    // MARK: - UI Elements

    private let priceLabel: AppLabel = .init(settings: .init(labelType: .big, color: .label, numberOfLines: 1))
    private let priceChangeLabel: AppLabel = .init(settings: .init(labelType: .titleBold, color: .secondaryLabel, numberOfLines: 1))

    // MARK: - Init

    init() {
        super.init(frame: .zero)
        setupView()
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public methods

    func configure(priceText: String, priceChangeText: String, priceChangeColor: UIColor) {
        priceLabel.text = priceText
        priceChangeLabel.text = "\(priceChangeText) 24h"
        priceChangeLabel.textColor = priceChangeColor
    }
}

// MARK: - Private methods

private extension MarketDetailPriceView {

    func setupView() {
        axis = .vertical
        spacing = 6
        addArrangedSubview(priceLabel)
        addArrangedSubview(priceChangeLabel)
    }
}
