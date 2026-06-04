//
//  AlertPresenter.swift
//  IMW
//
//  Created by Марат Саляхетдинов on 04.06.2026.
//

import UIKit

@MainActor
protocol AlertPresenting: AnyObject {
    func showAlert(title: String?, message: String?, actionTitle: String, retryActionTitle: String?, on viewController: UIViewController, retryHandler: (() -> Void)?)
}

@MainActor
final class AlertPresenter: AlertPresenting {

    // MARK: - Public methods

    func showAlert(title: String?, message: String?, actionTitle: String, retryActionTitle: String?, on viewController: UIViewController, retryHandler: (() -> Void)?) {
        let alertController: UIAlertController = .init(title: title, message: message, preferredStyle: .alert)

        if let retryActionTitle, let retryHandler {
            alertController.addAction(.init(title: retryActionTitle, style: .default) { _ in
                retryHandler()
            })
        }

        alertController.addAction(.init(title: actionTitle, style: .default))
        viewController.present(alertController, animated: true)
    }
}
