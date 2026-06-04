//
//  EmptyResultView.swift
//  IMW
//
//  Created by Марат Саляхетдинов on 04.06.2026.
//

import AppUICore
import SnapKit
import UIKit

final class EmptyResultView: UIView {

    // MARK: - UI Elements

    private let stackView: UIStackView = .init()
    private let imageView: UIImageView = .init()
    private let titleLabel: AppLabel = .init(settings: .init(labelType: .header, color: .label, numberOfLines: 0, textAlignment: .center))

    // MARK: - Init

    init(viewModel: EmptyResultViewModel) {
        super.init(frame: .zero)
        setupView()
        setupStackView()
        setupImageView()
        setupTitleLabel()
        setupConstraints()
        configure(viewModel)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public methods

    func configure(_ viewModel: EmptyResultViewModel) {
        backgroundColor = viewModel.backgroundColor
        imageView.image = viewModel.image
        titleLabel.text = viewModel.title
    }
}

// MARK: - Private methods

private extension EmptyResultView {

    func setupView() {
        isUserInteractionEnabled = false
    }

    func setupStackView() {
        addSubview(stackView)
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 16
        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(titleLabel)
    }

    func setupImageView() {
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .systemYellow
    }

    func setupTitleLabel() {
        titleLabel.textColor = .label
    }

    func setupConstraints() {
        stackView.snp.makeConstraints {
            $0.centerY.equalToSuperview().offset(-24)
            $0.leading.trailing.equalToSuperview().inset(32)
        }

        imageView.snp.makeConstraints {
            $0.size.equalTo(96)
        }
    }
}
