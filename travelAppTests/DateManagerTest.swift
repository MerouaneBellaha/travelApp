//
//  DateManagerTest.swift
//  travelAppTests
//
//  Created by Merouane Bellaha on 21/07/2020.
//  Copyright © 2020 Merouane Bellaha. All rights reserved.
//

import XCTest
@testable import travelApp

class DateManagerTest: XCTestCase {

    var dateManager: DateManager!

    override func setUp() {
        dateManager = DateManager()
    }

    override func tearDown() {
        dateManager = nil
    }

    func testGivenTimeBetweenTimeStampAndDateIsLessThanOneHour_WhenCallingDidOneHourPassed_ThenResultShouldBeFalse() {
        setDateManager(date: 10000, timeStamp: 8000)

        XCTAssertEqual(dateManager.didOneHourHasPass, false)
    }

    func testGivenTimeBetweenTimeStampAndDateIsMoreThanOneHour_WhenCallingDidOneHourPassed_ThenResultShouldBeTrue() {
        setDateManager(date: 10_000, timeStamp: 2_000)

        XCTAssertEqual(dateManager.didOneHourHasPass, true)
    }

    func testGivenTimeBetweenTimeStampAndDateIsLessThanOneDay_WhenCallingDidOneDayPassed_ThenResultShouldBeFalse() {
        setDateManager(date: 10_000, timeStamp: 2_000)

        XCTAssertEqual(dateManager.didOneDayHasPass, false)
    }

    func testGivenTimeBetweenTimeStampAndDateIsMoreThanOneDay_WhenCallingDidOneDayPassed_ThenResultShouldBeTrue() {
        setDateManager(date: 100_000, timeStamp: 2_000)

        XCTAssertEqual(dateManager.didOneDayHasPass, true)
    }

    func testGivenDateIsTody_WhenCallingLastUpdateDate_ThenResultCountShouldBe16() {
        setDateManager(date: 0, timeStamp: 0)

        XCTAssertEqual(dateManager.lastUpdateDate.count, 16)
    }

    private func setDateManager(date: Int, timeStamp: Int) {
        dateManager.presentDate = date
        dateManager.apiTimeStamp = timeStamp
    }
}
