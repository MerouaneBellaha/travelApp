//
//  Data.swift
//  travelApp
//
//  Created by Merouane Bellaha on 14/07/2020.
//  Copyright © 2020 Merouane Bellaha. All rights reserved.
//

import Foundation

struct CurrencyData: Codable {
    var rates: [String: Double]
    var timestamp: Int
}


struct WeatherData: Decodable {
    let main: Main
    let weather: [Weather]
    let name: String
}

struct Main: Decodable {
    var temp: Double
}

struct Weather: Decodable {
    var id: Int
    var description: String
}
