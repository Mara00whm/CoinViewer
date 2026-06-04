//
//  EmptyResultViewModel.swift
//  IMW
//
//  Created by Марат Саляхетдинов on 04.06.2026.
//

import UIKit

struct EmptyResultViewModel {
    let image: UIImage?
    let title: String
    let backgroundColor: UIColor

    static let `default`: EmptyResultViewModel = .init(image: UIImage(named: "icCoin") ?? UIImage(named: "ic_coin") ?? UIImage(systemName: "bitcoinsign.circle.fill"), title: "Ничего не найдено", backgroundColor: .systemBackground)
}
