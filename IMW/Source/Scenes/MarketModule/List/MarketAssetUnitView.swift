//
//  MarketAssetUnitView.swift
//  IMW
//
//  Created by Марат Саляхетдинов on 02.06.2026.
//

import AppUICore
import SnapKit
import UIKit

final class MarketAssetUnitView: UIView, AppTableUnitView {

    // MARK: - UI Elements

    private let iconImageView: UIImageView = .init()
    private let infoStackView: UIStackView = .init()
    private let priceStackView: UIStackView = .init()
    private let titleLabel: AppLabel = .init(settings: .init(labelType: .titleBold, color: .label, numberOfLines: 1))
    private let subtitleLabel: AppLabel = .init(settings: .init(labelType: .descriptionWithAlpha, color: .secondaryLabel, numberOfLines: 1))
    private let priceLabel: AppLabel = .init(settings: .init(labelType: .titleBold, color: .label, numberOfLines: 1, textAlignment: .right))
    private let changeLabel: AppLabel = .init(settings: .init(labelType: .description, color: .secondaryLabel, numberOfLines: 1, textAlignment: .right))
    private let rankLabel: AppLabel = .init(settings: .init(labelType: .descriptionWithAlpha, color: .secondaryLabel, numberOfLines: 1, textAlignment: .center))

    // MARK: - Init

    init(viewModel: MarketListModel.ItemViewModel) {
        super.init(frame: .zero)
        setupView()
        setupConstraints()
        configure(viewModel: viewModel)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Private methods

private extension MarketAssetUnitView {

    func setupView() {
        backgroundColor = .systemBackground
        [rankLabel, iconImageView, infoStackView, priceStackView].forEach {
            addSubview($0)
        }

        infoStackView.axis = .vertical
        infoStackView.spacing = 3
        infoStackView.addArrangedSubview(titleLabel)
        infoStackView.addArrangedSubview(subtitleLabel)

        priceStackView.axis = .vertical
        priceStackView.spacing = 3
        priceStackView.alignment = .trailing
        priceStackView.addArrangedSubview(priceLabel)
        priceStackView.addArrangedSubview(changeLabel)

        iconImageView.contentMode = .scaleAspectFill
        iconImageView.clipsToBounds = true
        iconImageView.layer.cornerRadius = 16
        titleLabel.lineBreakMode = .byTruncatingTail
        subtitleLabel.lineBreakMode = .byTruncatingTail
        rankLabel.setContentHuggingPriority(.required, for: .horizontal)
        infoStackView.setContentHuggingPriority(.defaultLow, for: .horizontal)
        infoStackView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        priceStackView.setContentHuggingPriority(.required, for: .horizontal)
        priceStackView.setContentCompressionResistancePriority(.required, for: .horizontal)
        priceLabel.setContentHuggingPriority(.required, for: .horizontal)
        priceLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        changeLabel.setContentHuggingPriority(.required, for: .horizontal)
        changeLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
    }

    func setupConstraints() {
        snp.makeConstraints {
            $0.height.greaterThanOrEqualTo(64)
        }
        
        rankLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(4)
            $0.centerY.equalToSuperview()
            $0.width.equalTo(14)
        }
        
        iconImageView.snp.makeConstraints {
            $0.leading.equalTo(rankLabel.snp.trailing).offset(4)
            $0.centerY.equalToSuperview()
            $0.size.equalTo(32)
        }
        
        infoStackView.snp.makeConstraints {
            $0.leading.equalTo(iconImageView.snp.trailing).offset(12)
            $0.centerY.equalToSuperview()
            $0.trailing.lessThanOrEqualTo(priceStackView.snp.leading).offset(-12)
        }
        
        priceStackView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(16)
            $0.width.greaterThanOrEqualTo(86)
        }
    }

    func configure(viewModel: MarketListModel.ItemViewModel) {
        titleLabel.text = viewModel.title
        subtitleLabel.text = viewModel.subtitle
        priceLabel.text = viewModel.priceText
        changeLabel.text = viewModel.priceChangeText
        changeLabel.textColor = viewModel.priceChangeColor
        rankLabel.text = viewModel.rankText

        iconImageView.image = viewModel.image ?? UIImage(systemName: "bitcoinsign.circle")
    }
}
