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
    let rates: [String: Double]
    let timestamp: Int
}

    // MARK: - OpenWeather

struct WeatherData: Codable {
    let main: Main
    let weather: [Weather]
    let name: String
}

struct Main: Codable {
    let temp: Double
}

struct Weather: Codable {
    let id: Int
    let description: String
}

    // MARK: - GoogleDetectLanguages

struct DetectData: Codable {
    let data: DetectedList
}

struct DetectedList: Codable {
    let detections: [[Detection]]
}

struct Detection: Codable {
    let language: String
}

    // MARK: - GoogleSupportedLanguages

struct LanguageData: Codable {
    let data: LanguageList
}

struct LanguageList: Codable {
    let languages: [Language]
}

struct Language: Codable {
    let language, name: String
}

    // MARK: - GoogleTranslate

struct TranslateData: Codable {
    let data: TranslateList
}

struct TranslateList: Codable {
    let translations: [Translation]
}

struct Translation: Codable {
    let translatedText: String
    let detectedSourceLanguage: String?
}

