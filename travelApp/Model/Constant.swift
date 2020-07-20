//
//  Constant.swift
//  travelApp
//
//  Created by Merouane Bellaha on 18/07/2020.
//  Copyright © 2020 Merouane Bellaha. All rights reserved.
//

import Foundation

struct K {

    // MARK: - Networking

    static let baseURLfixer = "http://data.fixer.io/api/latest"
    static let fixerAPI = "?access_key=873a90d1ce1ba971ee5c9051fd3039e6"

    static let baseURLweather = "https://api.openweathermap.org/data/2.5/weather?&units=metric"
    static let weatherAPI = "&appid=74545f40e1c347860514c74fe580b0a4"

    static let query = "&q="
    static let queryLat = "&lat="
    static let queryLon = "&lon="

    // MARK: - Predicate

    /// "currency CONTAINS[cd] %@"
    static let currencyFormat = "currency CONTAINS[cd] %@"
    /// "taskName CONTAINS[cd] %@"
    static let taskFormat = "taskName CONTAINS[cd] %@"

    // MARK: - Keys

    static let taskName = "taskName"
    static let timeStamp = "timestamp"
    static let rate = "rate"
    static let currency = "currency"
    static let city = "city"
    static let defaultCity = "New york"


    // MARK: - cells

    static let taskCell = "taskCell"
    static let rateCell = "rateCell"

    // MARK: - Basic

    static let USD = "USD"
    /// "."
    static let point = "."
    /// "no Task"
    static let noTask = "no Task"

    // MARK: - Formats

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
    /// "Currency non valable"
    static let unvailableCurrency = "Currency non valable"
    /// ""City entered in settings page doesn't exist. Please try again."
    static let cityErrorSettings = "City entered in settings page doesn't exist. Please try again."
    /// "Searched city doesn't exist. Please try again"
    static let cityErrorSearched = "Searched city doesn't exist. Please try again"

}
