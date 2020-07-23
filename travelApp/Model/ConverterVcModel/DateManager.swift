//
//  DateManager.swift
//  travelApp
//
//  Created by Merouane Bellaha on 21/07/2020.
//  Copyright © 2020 Merouane Bellaha. All rights reserved.
//

import Foundation

struct DateManager {

    var date: Int?
    var timeStamp: Int?
    private let hourInSeconds = 3600
    private let dayInSeconds = 86400


    var didOneHourHasPass: Bool {
        guard let timeStamp = timeStamp else { return false }
        guard let date = date else { return false }
        return (date - timeStamp) > hourInSeconds ? true : false
    }

    var didOneDayHasPass: Bool {
        guard let timeStamp = timeStamp else { return false }
        guard let date = date else { return false }
        if timeStamp == 0 || (date - timeStamp) > dayInSeconds {
            return true
        }
        return false
    }

    var lastUpdateDate: String {
        guard let timeStamp = timeStamp else { return "no data" }
        let lastUpdate = Date(timeIntervalSince1970: TimeInterval(timeStamp))
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone.current
        formatter.dateFormat = K.dateFormat
        let dateString = formatter.string(from: lastUpdate)
        return dateString
    }

}
