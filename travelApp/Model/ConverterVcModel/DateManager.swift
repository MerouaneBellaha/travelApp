//
//  DateManager.swift
//  travelApp
//
//  Created by Merouane Bellaha on 21/07/2020.
//  Copyright © 2020 Merouane Bellaha. All rights reserved.
//

import Foundation

struct DateManager {

    var presentDate: Int
    var apiTimeStamp: Int
    private let hourInSeconds = 3600
    private let dayInSeconds = 86400

    init(presentDate: Int? = nil, apiTimeStamp: Int? = nil) {
        self.presentDate = presentDate ?? 0
        self.apiTimeStamp = apiTimeStamp ?? 0
        }

    var didOneHourHasPass: Bool {
        return (presentDate - apiTimeStamp) > hourInSeconds ? true : false
    }

    var didOneDayHasPass: Bool {
        guard apiTimeStamp == 0 || (presentDate - apiTimeStamp) > dayInSeconds else { return false }
        return true
    }

    var lastUpdateDate: String {
        let lastUpdate = Date(timeIntervalSince1970: TimeInterval(apiTimeStamp))
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone.current
        formatter.dateFormat = K.dateFormat
        let dateString = formatter.string(from: lastUpdate)
        return dateString
    }
}
