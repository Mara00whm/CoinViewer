//
//  MarketDetailLinksSectionView.swift
//  IMW
//
//  Created by Марат Саляхетдинов on 04.06.2026.
//

import AppUICore
import UIKit

final class MarketDetailLinksSectionView: UIStackView {

    // MARK: - UI Elements

    private let titleLabel: AppLabel = .init(settings: .init(labelType: .header, color: .label, numberOfLines: 1))
    private let linksStackView: UIStackView = .init()

    // MARK: - Init

    init() {
        super.init(frame: .zero)
        setupView()
        setupLinksStackView()
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public methods

    func configure(_ links: [MarketDetailModel.LinkViewModel], target: Any?, action: Selector) {
        clearLinks()

        for (index, link) in links.enumerated() {
            let button: AppButton = .init(settings: .init(style: .bordered, icon: .yes(image: UIImage(systemName: "arrow.up.right"), placement: .right), title: link.title, widthType: .external, height: 40))
            button.tag = index
            button.addTarget(target, action: action, for: .touchUpInside)
            linksStackView.addArrangedSubview(button)
        }

        isHidden = links.isEmpty
    }
}

// MARK: - Private methods

private extension MarketDetailLinksSectionView {

    func setupView() {
        titleLabel.text = "Links"
        axis = .vertical
        spacing = 12
        isHidden = true
        addArrangedSubview(titleLabel)
        addArrangedSubview(linksStackView)
    }

    func setupLinksStackView() {
        linksStackView.axis = .horizontal
        linksStackView.spacing = 8
        linksStackView.distribution = .fillEqually
    }

    func clearLinks() {
        linksStackView.arrangedSubviews.forEach {
            linksStackView.removeArrangedSubview($0)
            $0.removeFromSuperview()
        }
    }
}
