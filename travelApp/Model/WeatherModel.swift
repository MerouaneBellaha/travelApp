//
//  WeatherModel.swift
//  travelApp
//
//  Created by Merouane Bellaha on 19/07/2020.
//  Copyright © 2020 Merouane Bellaha. All rights reserved.
//

import Foundation

struct WeatherModel {

    let weatherData: WeatherData!
    let conditionId: Int
    let cityName: String
    let temperature: Double
    let description: String

    init(weatherData: WeatherData) {
        self.weatherData = weatherData
        self.conditionId = weatherData.weather.first?.id ?? 0
        self.cityName = weatherData.name
        self.temperature = weatherData.main.temp
        self.description = weatherData.weather.first?.description ?? "N/A"
    }

    var temperatureString: String {
        return String(format: "%.1f", temperature)
    }

    var conditionName: String {
        switch conditionId {
        case 0..<300:
            return "cloud.bolt"
        case 300..<400:
            return "cloud.drizzle"
        case 500..<600:
            return "cloud.rain"
        case 600..<700:
            return "cloud.snow"
        case 700..<800:
            return "cloud.fog"
        case 800:
            return "sun.min"
        default:
            return "cloud"
        }
    }
}
