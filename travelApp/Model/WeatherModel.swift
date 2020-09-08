//
//  WeatherModel.swift
//  travelApp
//
//  Created by Merouane Bellaha on 19/07/2020.
//  Copyright © 2020 Merouane Bellaha. All rights reserved.
//

import Foundation

struct WeatherModel {

    private let weatherData: WeatherData?
    private var conditionId: Int?
    private var temperature: Double?
    let cityName: String?
    let description: String?

    init(weatherData: WeatherData?) {
        self.weatherData = weatherData
        self.conditionId = self.weatherData?.weather.first?.id ?? 0
        self.cityName = self.weatherData?.name
        self.temperature = self.weatherData?.main.temp
        self.description = self.weatherData?.weather.first?.description ?? "N/A"
    }

    var temperatureString: String {
        guard let temperature = temperature else { return "N/A" }
        return String(format: "%.1f", temperature)
    }

    var conditionName: String {
        guard let conditionId = conditionId else { return "cloud" }
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
