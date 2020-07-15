//
//  ConvertedCurrencyModel.swift
//  travelApp
//
//  Created by Merouane Bellaha on 15/07/2020.
//  Copyright © 2020 Merouane Bellaha. All rights reserved.
//

import Foundation

struct ConvertedCurrencyModel {

    // MARK: - Properties

    let convertedCurrencyData: ConvertedCurrency
    let currency: String

    var rate: Double {
        convertedCurrencyData.rates[currency] ?? 0
    }

    var currencies: String {
        convertedCurrencyData.rates.map { $0.key }.joined(separator: "-")
    }

    // MARK: - Init

    init(convertedCurrencyData: ConvertedCurrency, currency: String) {
        self.convertedCurrencyData = convertedCurrencyData
        self.currency = currency
    }
}
