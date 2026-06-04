//
//  MainTab.swift
//  IMW
//
//  Created by Марат Саляхетдинов on 01.06.2026.
//

import UIKit

enum MainTab: Int, CaseIterable {
    case market
    case watchlist
}

extension MainTab {

    // MARK: - Computed properties

    var title: String {
        switch self {
        case .market:
            return "Market"
        case .watchlist:
            return "Watchlist"
        }
    }

    var icon: UIImage? {
        switch self {
        case .market:
            return UIImage(systemName: "chart.line.uptrend.xyaxis")
        case .watchlist:
            return UIImage(systemName: "star")
        }
    }

    var selectedIcon: UIImage? {
        switch self {
        case .market:
            return UIImage(systemName: "chart.line.uptrend.xyaxis")
        case .watchlist:
            return UIImage(systemName: "star.fill")
        }
    }
}
