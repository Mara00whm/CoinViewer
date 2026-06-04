//
//  EmptyResultOverlayPresenter.swift
//  IMW
//
//  Created by Марат Саляхетдинов on 04.06.2026.
//

import SnapKit
import UIKit

@MainActor
protocol EmptyResultPresenting: AnyObject {
    func show(model: EmptyResultViewModel, on view: UIView)
    func hide()
}

@MainActor
final class EmptyResultOverlayPresenter: EmptyResultPresenting {

    // MARK: - Private properties

    private var emptyResultView: EmptyResultView?

    // MARK: - Public methods

    func show(model: EmptyResultViewModel, on view: UIView) {
        if let emptyResultView {
            emptyResultView.configure(model)
            view.bringSubviewToFront(emptyResultView)
            return
        }

        let emptyResultView: EmptyResultView = .init(viewModel: model)
        view.addSubview(emptyResultView)

        emptyResultView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }

        self.emptyResultView = emptyResultView
    }

    func hide() {
        emptyResultView?.removeFromSuperview()
        emptyResultView = nil
    }
}
