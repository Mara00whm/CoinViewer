//
//  MarketDetailTextSectionView.swift
//  IMW
//
//  Created by Марат Саляхетдинов on 04.06.2026.
//

import AppUICore
import UIKit

final class MarketDetailTextSectionView: UIStackView {

    // MARK: - UI Elements

    private let titleLabel: AppLabel = .init(settings: .init(labelType: .header, color: .label, numberOfLines: 1))
    private let textLabel: AppLabel = .init(settings: .init(labelType: .title, color: .secondaryLabel, numberOfLines: 0))

    // MARK: - Init

    init(title: String) {
        super.init(frame: .zero)
        setupView()
        titleLabel.text = title
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public methods

    func configure(text: String, hideWhenEmpty: Bool) {
        textLabel.text = text
        isHidden = hideWhenEmpty && text.isEmpty
    }
}

// MARK: - Private methods

private extension MarketDetailTextSectionView {

    func setupView() {
        axis = .vertical
        spacing = 8
        addArrangedSubview(titleLabel)
        addArrangedSubview(textLabel)
    }
}
