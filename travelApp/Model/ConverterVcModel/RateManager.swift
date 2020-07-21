//
//  RateManager.swift
//  travelApp
//
//  Created by Merouane Bellaha on 21/07/2020.
//  Copyright © 2020 Merouane Bellaha. All rights reserved.
//

import Foundation

struct RateManager {

    func calculConversion(of amount: Double, with firstRate: Double, and secondRate: Double) -> String {
        guard let actualRate = Double(getActualRate(of: firstRate, and: secondRate)) else { return "" }
        return String(format: K.twoDecimals, amount / actualRate)
    }

    func getActualRate(of firsRate: Double, and secondRate: Double, format: String? = nil) -> String {
        guard let format = format else { return String(firsRate / secondRate)}
        return String(format: format, firsRate / secondRate)
    }
}

