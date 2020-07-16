//
//  Data.swift
//  travelApp
//
//  Created by Merouane Bellaha on 14/07/2020.
//  Copyright © 2020 Merouane Bellaha. All rights reserved.
//

import Foundation

struct ConvertedCurrency: Codable {
    var rates: [String: Double]
    var timestamp: Int
}
