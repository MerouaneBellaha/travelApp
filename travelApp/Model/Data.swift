//
//  Data.swift
//  travelApp
//
//  Created by Merouane Bellaha on 14/07/2020.
//  Copyright © 2020 Merouane Bellaha. All rights reserved.
//

import Foundation

    // MARK: - Fixer

struct CurrencyData: Decodable {
    let rates: [String: Double]
    let timestamp: Int
}

    // MARK: - OpenWeather

struct WeatherData: Decodable {
    let main: Main
    let weather: [Weather]
    let name: String
}

struct Main: Decodable {
    let temp: Double
}

struct Weather: Decodable {
    let id: Int
    let description: String
}

    // MARK: - GoogleDetectLanguages

struct DetectData: Decodable {
    let data: DetectedList
}

struct DetectedList: Decodable {
    let detections: [[Detection]]
}

struct Detection: Decodable {
    let language: String
}

    // MARK: - GoogleSupportedLanguages

struct LanguageData: Decodable {
    let data: LanguageList
}

struct LanguageList: Decodable {
    let languages: [Language]
}

struct Language: Decodable {
    let language, name: String
}

    // MARK: - GoogleTranslate

struct TranslateData: Decodable {
    let data: TranslateList
}

struct TranslateList: Decodable {
    let translations: [Translation]
}

struct Translation: Decodable {
    let translatedText: String
    let detectedSourceLanguage: String?
}

