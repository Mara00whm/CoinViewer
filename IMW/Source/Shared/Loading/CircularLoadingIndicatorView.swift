//
//  CircularLoadingIndicatorView.swift
//  IMW
//
//  Created by Марат Саляхетдинов on 04.06.2026.
//

import UIKit

final class CircularLoadingIndicatorView: UIView {

    // MARK: - Private properties

    private let circleLayer: CAShapeLayer = .init()
    private let lineWidth: CGFloat
    private let strokeColor: UIColor
    private let animationKey: String = "rotationAnimation"

    // MARK: - Init

    init(lineWidth: CGFloat = 3, strokeColor: UIColor = .systemYellow) {
        self.lineWidth = lineWidth
        self.strokeColor = strokeColor
        super.init(frame: .zero)
        setupView()
        setupCircleLayer()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    override func layoutSubviews() {
        super.layoutSubviews()
        updateCircleLayerPath()
    }

    // MARK: - Public methods

    func startAnimating() {
        guard layer.animation(forKey: animationKey) == nil else { return }

        let animation: CABasicAnimation = .init(keyPath: "transform.rotation.z")
        animation.fromValue = 0
        animation.toValue = CGFloat.pi * 2
        animation.duration = 0.8
        animation.repeatCount = .infinity
        animation.timingFunction = .init(name: .linear)
        layer.add(animation, forKey: animationKey)
    }

    func stopAnimating() {
        layer.removeAnimation(forKey: animationKey)
    }
}

// MARK: - Private methods

private extension CircularLoadingIndicatorView {

    func setupView() {
        backgroundColor = .clear
        isUserInteractionEnabled = false
    }

    func setupCircleLayer() {
        circleLayer.fillColor = UIColor.clear.cgColor
        circleLayer.strokeColor = strokeColor.cgColor
        circleLayer.lineWidth = lineWidth
        circleLayer.lineCap = .round
        circleLayer.strokeStart = 0
        circleLayer.strokeEnd = 0.75
        layer.addSublayer(circleLayer)
    }

    func updateCircleLayerPath() {
        let side: CGFloat = min(bounds.width, bounds.height)
        guard side > lineWidth else {
            circleLayer.path = nil
            return
        }

        let inset: CGFloat = lineWidth / 2
        let rect: CGRect = .init(x: (bounds.width - side) / 2 + inset, y: (bounds.height - side) / 2 + inset, width: side - lineWidth, height: side - lineWidth)

        circleLayer.frame = bounds
        circleLayer.path = UIBezierPath(ovalIn: rect).cgPath
    }
}
