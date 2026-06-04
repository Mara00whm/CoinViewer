//
//  SkeletonLoadingView.swift
//  IMW
//
//  Created by Марат Саляхетдинов on 03.06.2026.
//

import SnapKit
import UIKit

final class SkeletonLoadingView: UIView {

    enum LoadingType {
        case list
        case detail
    }

    // MARK: - UI Elements

    private let scrollView: UIScrollView = .init()
    private let contentView: UIView = .init()
    private let stackView: UIStackView = .init()

    // MARK: - Private properties

    private let type: LoadingType
    private var blocks: [SkeletonBlockView] = []

    // MARK: - Init

    init(type: LoadingType) {
        self.type = type
        super.init(frame: .zero)
        setupView()
        setupConstraints()
        setupContent()
        hide()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public methods

    func show() {
        isHidden = false
        blocks.forEach { $0.startAnimating() }
    }

    func hide() {
        blocks.forEach { $0.stopAnimating() }
        isHidden = true
    }
}

// MARK: - Private methods

private extension SkeletonLoadingView {

    func setupView() {
        backgroundColor = .systemGroupedBackground
        isUserInteractionEnabled = true
        addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(stackView)

        scrollView.backgroundColor = .clear
        scrollView.showsVerticalScrollIndicator = false
        stackView.axis = .vertical
        stackView.spacing = 16
    }

    func setupConstraints() {
        scrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        contentView.snp.makeConstraints {
            $0.edges.equalTo(scrollView.contentLayoutGuide)
            $0.width.equalTo(scrollView.frameLayoutGuide)
        }

        stackView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(16)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().inset(24)
        }
    }

    func setupContent() {
        switch type {
        case .list:
            setupListContent()
        case .detail:
            setupDetailContent()
        }
    }

    func setupListContent() {
        stackView.spacing = 0
        stackView.addArrangedSubview(makeListHeaderView())

        for _ in 0..<12 {
            stackView.addArrangedSubview(makeListRowView())
        }
    }

    func setupDetailContent() {
        stackView.addArrangedSubview(makeDetailHeaderView())
        stackView.addArrangedSubview(makePriceView())
        stackView.addArrangedSubview(makeBlock(height: 34, cornerRadius: 10))
        stackView.addArrangedSubview(makeBlock(height: 220, cornerRadius: 8))
        stackView.addArrangedSubview(makeTitleBlock(width: 160))
        stackView.addArrangedSubview(makeStatsGridView())
        stackView.addArrangedSubview(makeTitleBlock(width: 80))
        stackView.addArrangedSubview(makeLinksView())
        stackView.addArrangedSubview(makeTitleBlock(width: 70))
        stackView.addArrangedSubview(makeTextLinesView(linesCount: 8))
    }

    func makeListHeaderView() -> UIView {
        let view: UIView = .init()
        let titleBlock: SkeletonBlockView = makeBlock(height: 28, width: 120, cornerRadius: 8)
        let subtitleBlock: SkeletonBlockView = makeBlock(height: 16, width: 180, cornerRadius: 6)

        view.addSubview(titleBlock)
        view.addSubview(subtitleBlock)

        titleBlock.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview()
        }

        subtitleBlock.snp.makeConstraints {
            $0.top.equalTo(titleBlock.snp.bottom).offset(8)
            $0.leading.equalToSuperview()
            $0.bottom.equalToSuperview().inset(12)
        }

        return view
    }

    func makeListRowView() -> UIView {
        let view: UIView = .init()
        let rankBlock: SkeletonBlockView = makeBlock(height: 12, width: 24, cornerRadius: 6)
        let imageBlock: SkeletonBlockView = makeBlock(height: 32, width: 32, cornerRadius: 16)
        let titleBlock: SkeletonBlockView = makeBlock(height: 16, width: 190, cornerRadius: 6)
        let subtitleBlock: SkeletonBlockView = makeBlock(height: 10, width: 56, cornerRadius: 5)
        let priceBlock: SkeletonBlockView = makeBlock(height: 16, width: 86, cornerRadius: 6)
        let changeBlock: SkeletonBlockView = makeBlock(height: 10, width: 48, cornerRadius: 5)

        [rankBlock, imageBlock, titleBlock, subtitleBlock, priceBlock, changeBlock].forEach {
            view.addSubview($0)
        }

        view.snp.makeConstraints {
            $0.height.equalTo(64)
        }

        rankBlock.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(8)
            $0.centerY.equalToSuperview()
        }

        imageBlock.snp.makeConstraints {
            $0.leading.equalTo(rankBlock.snp.trailing).offset(8)
            $0.centerY.equalToSuperview()
        }

        titleBlock.snp.makeConstraints {
            $0.leading.equalTo(imageBlock.snp.trailing).offset(12)
            $0.top.equalToSuperview().offset(15)
            $0.trailing.lessThanOrEqualTo(priceBlock.snp.leading).offset(-16)
        }

        subtitleBlock.snp.makeConstraints {
            $0.leading.equalTo(titleBlock.snp.leading)
            $0.top.equalTo(titleBlock.snp.bottom).offset(6)
        }

        priceBlock.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(16)
            $0.top.equalTo(titleBlock.snp.top)
        }

        changeBlock.snp.makeConstraints {
            $0.trailing.equalTo(priceBlock.snp.trailing)
            $0.top.equalTo(priceBlock.snp.bottom).offset(6)
        }

        return view
    }

    func makeDetailHeaderView() -> UIView {
        let view: UIView = .init()
        let imageBlock: SkeletonBlockView = makeBlock(height: 56, width: 56, cornerRadius: 28)
        let titleBlock: SkeletonBlockView = makeBlock(height: 24, width: 180, cornerRadius: 8)
        let subtitleBlock: SkeletonBlockView = makeBlock(height: 14, width: 72, cornerRadius: 7)
        let rankBlock: SkeletonBlockView = makeBlock(height: 28, width: 48, cornerRadius: 14)

        [imageBlock, titleBlock, subtitleBlock, rankBlock].forEach {
            view.addSubview($0)
        }

        imageBlock.snp.makeConstraints {
            $0.top.leading.bottom.equalToSuperview()
        }

        titleBlock.snp.makeConstraints {
            $0.leading.equalTo(imageBlock.snp.trailing).offset(12)
            $0.top.equalToSuperview().offset(4)
            $0.trailing.lessThanOrEqualTo(rankBlock.snp.leading).offset(-12)
        }

        subtitleBlock.snp.makeConstraints {
            $0.leading.equalTo(titleBlock.snp.leading)
            $0.top.equalTo(titleBlock.snp.bottom).offset(8)
        }

        rankBlock.snp.makeConstraints {
            $0.trailing.equalToSuperview()
            $0.centerY.equalTo(imageBlock.snp.centerY)
        }

        return view
    }

    func makePriceView() -> UIView {
        let view: UIView = .init()
        let priceBlock: SkeletonBlockView = makeBlock(height: 30, width: 140, cornerRadius: 8)
        let changeBlock: SkeletonBlockView = makeBlock(height: 16, width: 82, cornerRadius: 6)

        view.addSubview(priceBlock)
        view.addSubview(changeBlock)

        priceBlock.snp.makeConstraints {
            $0.top.leading.equalToSuperview()
        }

        changeBlock.snp.makeConstraints {
            $0.top.equalTo(priceBlock.snp.bottom).offset(8)
            $0.leading.bottom.equalToSuperview()
        }

        return view
    }

    func makeStatsGridView() -> UIView {
        let stackView: UIStackView = .init()
        stackView.axis = .vertical
        stackView.spacing = 8

        for _ in 0..<3 {
            let rowStackView: UIStackView = .init()
            rowStackView.axis = .horizontal
            rowStackView.spacing = 8
            rowStackView.distribution = .fillEqually
            rowStackView.addArrangedSubview(makeStatCardView())
            rowStackView.addArrangedSubview(makeStatCardView())
            stackView.addArrangedSubview(rowStackView)
        }

        return stackView
    }

    func makeStatCardView() -> UIView {
        let view: UIView = .init()
        let titleBlock: SkeletonBlockView = makeBlock(height: 10, width: 74, cornerRadius: 5)
        let valueBlock: SkeletonBlockView = makeBlock(height: 16, width: 96, cornerRadius: 6)

        view.backgroundColor = .secondarySystemBackground
        view.layer.cornerRadius = 8
        view.addSubview(titleBlock)
        view.addSubview(valueBlock)

        view.snp.makeConstraints {
            $0.height.equalTo(62)
        }

        titleBlock.snp.makeConstraints {
            $0.top.leading.equalToSuperview().offset(12)
        }

        valueBlock.snp.makeConstraints {
            $0.leading.equalTo(titleBlock.snp.leading)
            $0.top.equalTo(titleBlock.snp.bottom).offset(8)
        }

        return view
    }

    func makeLinksView() -> UIView {
        let stackView: UIStackView = .init()
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.distribution = .fillEqually
        stackView.addArrangedSubview(makeBlock(height: 40, cornerRadius: 20))
        stackView.addArrangedSubview(makeBlock(height: 40, cornerRadius: 20))
        return stackView
    }

    func makeTextLinesView(linesCount: Int) -> UIView {
        let stackView: UIStackView = .init()
        stackView.axis = .vertical
        stackView.spacing = 8

        for index in 0..<linesCount {
            let widthMultiplier: CGFloat? = index == linesCount - 1 ? 0.72 : nil

            if let widthMultiplier {
                let containerView: UIView = .init()
                let blockView: SkeletonBlockView = makeBlock(height: 16, cornerRadius: 6)
                containerView.addSubview(blockView)

                blockView.snp.makeConstraints {
                    $0.top.leading.bottom.equalToSuperview()
                    $0.width.equalToSuperview().multipliedBy(widthMultiplier)
                }

                stackView.addArrangedSubview(containerView)
            } else {
                stackView.addArrangedSubview(makeBlock(height: 16, cornerRadius: 6))
            }
        }

        return stackView
    }

    func makeTitleBlock(width: CGFloat) -> SkeletonBlockView {
        makeBlock(height: 22, width: width, cornerRadius: 7)
    }

    func makeBlock(height: CGFloat, width: CGFloat? = nil, cornerRadius: CGFloat) -> SkeletonBlockView {
        let view: SkeletonBlockView = .init(cornerRadius: cornerRadius)
        blocks.append(view)

        view.snp.makeConstraints {
            $0.height.equalTo(height)

            if let width {
                $0.width.equalTo(width)
            }
        }

        return view
    }
}

private final class SkeletonBlockView: UIView {

    // MARK: - Private properties

    private let gradientLayer: CAGradientLayer = .init()
    private let animationKey: String = "skeleton.shimmer.animation"

    // MARK: - Init

    init(cornerRadius: CGFloat) {
        super.init(frame: .zero)
        layer.cornerRadius = cornerRadius
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
    }

    // MARK: - Public methods

    func startAnimating() {
        guard gradientLayer.animation(forKey: animationKey) == nil else { return }

        let animation: CABasicAnimation = .init(keyPath: "locations")
        animation.fromValue = [
            NSNumber(value: -1.0),
            NSNumber(value: -0.5),
            NSNumber(value: 0.0)
        ]
        animation.toValue = [
            NSNumber(value: 1.0),
            NSNumber(value: 1.5),
            NSNumber(value: 2.0)
        ]
        animation.duration = 1.25
        animation.repeatCount = .infinity
        gradientLayer.add(animation, forKey: animationKey)
    }

    func stopAnimating() {
        gradientLayer.removeAnimation(forKey: animationKey)
    }
}

// MARK: - Private methods

private extension SkeletonBlockView {

    func setupView() {
        backgroundColor = .tertiarySystemFill
        clipsToBounds = true
        gradientLayer.startPoint = .init(x: 0, y: 0.5)
        gradientLayer.endPoint = .init(x: 1, y: 0.5)
        gradientLayer.locations = [
            NSNumber(value: -1.0),
            NSNumber(value: -0.5),
            NSNumber(value: 0.0)
        ]
        gradientLayer.colors = [
            UIColor.tertiarySystemFill.cgColor,
            UIColor.systemBackground.withAlphaComponent(0.85).cgColor,
            UIColor.tertiarySystemFill.cgColor
        ]
        layer.addSublayer(gradientLayer)
    }
}
