//
//  BaseViewController.swift
//  IMW
//
//  Created by Марат Саляхетдинов on 02.06.2026.
//

import SnapKit
import UIKit

@MainActor
protocol BaseViewControllerInterface: AnyObject {
    func showLoading()
    func hideLoading()
    func showEmptyResult()
    func hideEmptyResult()
    func showErrorAlert(_ message: String, retryHandler: (() -> Void)?)
}

@MainActor
class BaseViewController: UIViewController, BaseViewControllerInterface {

    // MARK: - Private properties

    private let loadingView: SimpleLoadingView = .init()
    private let emptyResultPresenter: any EmptyResultPresenting = EmptyResultOverlayPresenter()
    private let alertPresenter: any AlertPresenting = AlertPresenter()

    // MARK: - Public methods

    func showLoading() {
        setupLoadingViewIfNeeded()
        view.bringSubviewToFront(loadingView)
        loadingView.show()
    }

    func hideLoading() {
        loadingView.hide()
    }

    func showEmptyResult() {
        emptyResultPresenter.show(model: .default, on: view)
    }

    func hideEmptyResult() {
        emptyResultPresenter.hide()
    }

    func showErrorAlert(_ message: String, retryHandler: (() -> Void)? = nil) {
        showAlert(title: "Something went wrong", message: message, retryHandler: retryHandler)
    }

    func showAlert(title: String?, message: String?, actionTitle: String = "OK", retryActionTitle: String = "Повторить", retryHandler: (() -> Void)? = nil) {
        alertPresenter.showAlert(title: title, message: message, actionTitle: actionTitle, retryActionTitle: retryActionTitle, on: self, retryHandler: retryHandler)
    }

    var shouldCancelTasksOnDisappear: Bool {
        isMovingFromParent || isBeingDismissed || navigationController?.isBeingDismissed == true || tabBarController?.isBeingDismissed == true || navigationController?.topViewController !== self
    }
}

// MARK: - Private methods

private extension BaseViewController {

    func setupLoadingViewIfNeeded() {
        guard loadingView.superview == nil else { return }

        view.addSubview(loadingView)
        loadingView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}

// MARK: - BaseViewControllerInterface

extension BaseViewControllerInterface {

    func showErrorAlert(_ message: String) {
        showErrorAlert(message, retryHandler: nil)
    }
}
