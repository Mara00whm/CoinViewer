//
//  MarketDetailHeaderView.swift
//  IMW
//
//  Created by Марат Саляхетдинов on 04.06.2026.
//

import AppUICore
import SnapKit
import UIKit

final class MarketDetailHeaderView: UIView {

    // MARK: - UI Elements

    private let assetImageView: UIImageView = .init()
    private let titleLabel: AppLabel = .init(settings: .init(labelType: .bigBold, color: .label, numberOfLines: 2))
    private let subtitleLabel: AppLabel = .init(settings: .init(labelType: .titleWithAlpha, color: .secondaryLabel, numberOfLines: 1))
    private let rankLabel: AppLabel = .init(settings: .init(labelType: .titleBold, color: .label, numberOfLines: 1, textAlignment: .center))
    private let watchlistButton: UIButton = .init(type: .system)

    // MARK: - Init

    init() {
        super.init(frame: .zero)
        setupTitleStackView()
        setupAssetImageView()
        setupRankLabel()
        setupWatchlistButton()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public methods

    func addWatchlistTarget(_ target: Any?, action: Selector) {
        watchlistButton.addTarget(target, action: action, for: .touchUpInside)
    }

    func configure(title: String, subtitle: String, rankText: String, image: UIImage?, isInWatchlist: Bool) {
        titleLabel.text = title
        subtitleLabel.text = subtitle
        rankLabel.text = rankText
        configureImage(image)
        configureWatchlistButton(isInWatchlist: isInWatchlist)
    }
}

// MARK: - Private methods

private extension MarketDetailHeaderView {

    func setupTitleStackView() {
        let titleStackView: UIStackView = .init(arrangedSubviews: [titleLabel, subtitleLabel])
        titleStackView.axis = .vertical
        titleStackView.spacing = 4
        titleStackView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)

        [assetImageView, titleStackView, rankLabel, watchlistButton].forEach {
            addSubview($0)
        }

        titleStackView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.equalTo(assetImageView.snp.trailing).offset(12)
            $0.trailing.lessThanOrEqualTo(rankLabel.snp.leading).offset(-12)
        }
    }

    func setupAssetImageView() {
        assetImageView.contentMode = .scaleAspectFill
        assetImageView.clipsToBounds = true
        assetImageView.backgroundColor = .secondarySystemBackground
        assetImageView.layer.cornerRadius = 28
        assetImageView.tintColor = .systemYellow

        assetImageView.snp.makeConstraints {
            $0.top.leading.bottom.equalToSuperview()
            $0.size.equalTo(56)
        }
    }

    func setupRankLabel() {
        rankLabel.backgroundColor = .systemGroupedBackground
        rankLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        rankLabel.addBordersAndRoundCornersWith(roundMode: .fully, cornerRadius: 14, color: .separator.withAlphaComponent(0.2))

        rankLabel.snp.makeConstraints {
            $0.centerY.equalTo(assetImageView.snp.centerY)
            $0.trailing.equalTo(watchlistButton.snp.leading).offset(-8)
            $0.height.equalTo(28)
            $0.width.greaterThanOrEqualTo(48)
        }
    }

    func setupWatchlistButton() {
        watchlistButton.backgroundColor = .clear
        watchlistButton.tintColor = .systemYellow
        watchlistButton.setContentCompressionResistancePriority(.required, for: .horizontal)
        watchlistButton.setImage(UIImage(systemName: "star"), for: .normal)
        watchlistButton.setImage(UIImage(systemName: "star.fill"), for: .selected)
        watchlistButton.setPreferredSymbolConfiguration(.init(pointSize: 30, weight: .semibold), forImageIn: .normal)

        watchlistButton.snp.makeConstraints {
            $0.centerY.equalTo(assetImageView.snp.centerY)
            $0.trailing.equalToSuperview()
            $0.size.equalTo(36)
        }
    }

    func configureImage(_ image: UIImage?) {
        if let image {
            assetImageView.image = image.withRenderingMode(.alwaysOriginal)
            return
        }

        assetImageView.image = UIImage(systemName: "bitcoinsign.circle.fill")?.withRenderingMode(.alwaysTemplate)
    }

    func configureWatchlistButton(isInWatchlist: Bool) {
        watchlistButton.isSelected = isInWatchlist
        watchlistButton.setImage(UIImage(systemName: isInWatchlist ? "star.fill" : "star"), for: .normal)
        watchlistButton.accessibilityLabel = isInWatchlist ? "Remove from Watchlist" : "Add to Watchlist"
    }
}
