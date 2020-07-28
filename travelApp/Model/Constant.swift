//
//  Constant.swift
//  travelApp
//
//  Created by Merouane Bellaha on 18/07/2020.
//  Copyright © 2020 Merouane Bellaha. All rights reserved.
//

import Foundation

struct K {

    private func getAPIKey(named keyname:String) -> String {
        let filePath = Bundle.main.path(forResource: "ApiKeys", ofType: "plist")
        let plist = NSDictionary(contentsOfFile: filePath!)
        let value = plist?.object(forKey: keyname) as! String
        return value
    }

    static var fixerKey: String {
        K().getAPIKey(named: "fixerAPI")
    }

    static var weatherKey: String {
        K().getAPIKey(named: "weatherAPI")
    }

    static var googleKey: String {
        K().getAPIKey(named: "googleAPI")
    }


    // MARK: - Networking

    static let baseURLfixer = "http://data.fixer.io/api/latest?"
    static var fixerQuery: (String, String) {
        ("access_key", fixerKey)
    }

    static let baseURLweather = "https://api.openweathermap.org/data/2.5/weather?"
    static var weatherQuery: (String, String) {
        ("appId", weatherKey)
    }

    static let baseURLdetect = "https://translation.googleapis.com/language/translate/v2/detect"
    static let baseURLtranslate = "https://translation.googleapis.com/language/translate/v2"
    static let baseURLlanguages = "https://translation.googleapis.com/language/translate/v2/languages"
    static var googleQuery: (String, String) {
        ("key", googleKey)
    }

    static let textFormat = ("format", "text")
    static let target = "target"
    static let metric = ("units", "metric")
    static let query = "q"
    static let queryLat = "lat"
    static let queryLon = "lon"
    static let source = "source"

    // MARK: - Predicate

    /// "currency CONTAINS[cd] %@"
    static let currencyFormat = "currency CONTAINS[cd] %@"
    /// "taskName CONTAINS[cd] %@"
    static let taskFormat = "taskName CONTAINS[cd] %@"

    // MARK: - Keys

    static let taskName = "taskName"
    static let timeStamp = "timeStamp"
    static let rate = "rate"
    static let currency = "Currency"
    static let city = "city"
    static let language = "Language"
    static let weather = "Weather"
    static let background = "background"

    // MARK: - Defaults

    static let defaultLanguages = "en"
    static let defaultCurrency = "USD"
    static let defaultLanguage = "English"
    static let defaultCity = "New york"

    // MARK: - cells

    static let taskCell = "taskCell"
    static let rateCell = "rateCell"
    static let settingCell = "settingCell"
    static let languageCell = "languageCell"

    // MARK: - Segues

    static let toSettingsTVC = "toSettingsTVC"

    // MARK: - Basic

    /// ""
    static let emptyString = ""
    /// "."
    static let point = "."
    /// "Add a task by pressing +"
    static let noTask = "Add a task by pressing +"

    // MARK: - Formats

    static let sixDecimals = "%.6f"
    static let twoDecimals = "%.2f"
    /// "yyyy-MM-dd HH:mm"
    static let dateFormat = "yyyy-MM-dd HH:mm"

    // MARK: - Error / Label Message

    /// "One update / hour only allowed"
    static let oneByHour = "One update / hour only allowed"
    /// "Vous ne pouvez pas démarrer avec un point"
    static let startWithPoint = "Can't start with a point."
    /// "Vous ne pouvez pas ajouter un second point"
    static let twoPoints = "Can't add another point."
    /// "last rates update: "
    static let lastUpdate = "last rates update: "
    /// ". Refresh to get latest rates. (one refresh / hour)"
    static let refresh = ". Refresh to get latest rates. (one refresh / hour)"
    /// "Devise doit comporter 3 lettres"
    static let minThreeLetters = "Devise doit comporter 3 lettres"
    /// "Currency is unavailable."
    static let unavailableCurrency = "Currency is unavailable."
    /// ""City entered in settings page doesn't exist. Please try again."
    static let cityErrorSettings = "City entered in settings page doesn't exist. Please try again."
    /// "Searched city doesn't exist. Please try again"
    static let cityErrorSearched = "Search for a city or a country. Please try again."
    /// "Current rates for 1 "
    static let currentRates = "Current rates for 1 "
    /// "\n\n\n"
    static let spaces = "\n\n\n"
    /// "\n"
    static let returnKey = "\n"
    /// "Please wait..."
    static let wait = "Please wait..."
    /// "We're getting your local forecast."
    static let localForecast = "We're getting your local forecast."
    /// "N/A"
    static let NA = "N/A"
    /// "At least one language is missing for translation, please set your languages"
    static let missingLanguages = "At least one language is missing for translation, please set your languages"
    /// "Type a text to translate."
    static let missingText = "Type a text to translate."
    /// "Choose a language to translate to."
    static let missingTranslateLanguage = "Choose a language to translate to."
    /// "Type text to translate here..."
    static let typeHere = "Type text to translate here..."
    /// "no match found"
    static let noMatch = "no match found"

}
