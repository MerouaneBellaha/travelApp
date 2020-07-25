//
//  Data.swift
//  travelApp
//
//  Created by Merouane Bellaha on 14/07/2020.
//  Copyright © 2020 Merouane Bellaha. All rights reserved.
//

import Foundation

    // MARK: - Fixer

struct CurrencyData: Codable {
    var rates: [String: Double]
    var timestamp: Int
}

    // MARK: - OpenWeather

struct WeatherData: Codable {
    let main: Main
    let weather: [Weather]
    let name: String
}

struct Main: Codable {
    var temp: Double
}

struct Weather: Codable {
    var id: Int
    var description: String
}

    // MARK: - GoogleDetectLanguages

struct DetectData: Codable {
    var data: DetectedList
}

struct DetectedList: Codable {
    let detections: [[Detection]]
}

struct Detection: Codable {
    let language: String
}

    // MARK: - GoogleSupportedLanguages

struct LanguageData: Codable {
    var data: LanguageList
}

struct LanguageList: Codable {
    let languages: [Language]
}

struct Language: Codable {
    let language, name: String
}

    // MARK: - GoogleTranslate

struct TranslateData: Codable {
    var data: TranslateList
}

struct TranslateList: Codable {
    let translations: [Translation]
}

struct Translation: Codable {
    let translatedText, detectedSourceLanguage: String
}

