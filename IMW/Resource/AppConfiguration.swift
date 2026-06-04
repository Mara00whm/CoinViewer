//
//  AppConfiguration.swift
//  IMW
//
//  Created by Марат Саляхетдинов on 03.06.2026.
//

import Foundation

enum AppConfiguration {

    // MARK: - Computed properties

    static var coinGeckoAPIKey: String? {
        guard let value: String = Bundle.main.object(forInfoDictionaryKey: "CoinGeckoAPIKey") as? String else { return nil }

        let trimmedValue: String = value.trimmingCharacters(in: .whitespacesAndNewlines)
        guard trimmedValue.isEmpty == false,
              trimmedValue != "$(COINGECKO_API_KEY)",
              trimmedValue != "paste_your_key_here" else { return nil }

        return trimmedValue
    }
}
