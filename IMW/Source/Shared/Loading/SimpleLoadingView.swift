//
//  SimpleLoadingView.swift
//  IMW
//
//  Created by Марат Саляхетдинов on 04.06.2026.
//

import SnapKit
import UIKit

final class SimpleLoadingView: UIView {

    // MARK: - UI Elements

    private let indicatorView: CircularLoadingIndicatorView = .init()

    // MARK: - Private properties

    private let indicatorSize: CGFloat
    private let overlayColor: UIColor

    // MARK: - Init

    init(indicatorSize: CGFloat = 44, overlayColor: UIColor = UIColor.systemBackground.withAlphaComponent(0.72)) {
        self.indicatorSize = indicatorSize
        self.overlayColor = overlayColor
        super.init(frame: .zero)
        setupView()
        setupIndicatorView()
        setupConstraints()
        hide()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public methods

    func show() {
        isHidden = false
        indicatorView.startAnimating()
    }

    func hide() {
        indicatorView.stopAnimating()
        isHidden = true
    }
}

// MARK: - Private methods

private extension SimpleLoadingView {

    func setupView() {
        backgroundColor = overlayColor
        isUserInteractionEnabled = true
    }

    func setupIndicatorView() {
        addSubview(indicatorView)
    }

    func setupConstraints() {
        indicatorView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.size.equalTo(indicatorSize)
        }
    }
}
