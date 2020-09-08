//
//  WeatherModelTest.swift
//  travelAppTests
//
//  Created by Merouane Bellaha on 19/07/2020.
//  Copyright © 2020 Merouane Bellaha. All rights reserved.
//

import XCTest
@testable import travelApp

class WeatherModelTest: XCTestCase {

    var weatherData: WeatherModel!

    override func setUp() {
        weatherData = WeatherModel(weatherData: nil)
    }

    override func tearDown() {
        weatherData = nil
    }

    func testGivenTemperatureIs20Point422_WhenWeatherModelIsCreated_ThenTemperatureStringIsAStringWithOneDecimal() {
        weatherData.temperature = 20.422

        XCTAssertEqual(weatherData.temperatureString, "20.4")
    }

    func testGivenConditionIdIsUnder300_WhenWeatherModelIsIsCreated_ThenConditionNameIsCloudBolt() {
        weatherData.conditionId = 24

        XCTAssertEqual(weatherData.conditionName, "cloud.bolt")
    }

    func testGivenConditionIdIsBetween300and399_WhenWeatherModelIsIsCreated_ThenConditionNameIsCloudDrizzle() {
        weatherData.conditionId = 320

        XCTAssertEqual(weatherData.conditionName, "cloud.drizzle")
    }

    func testGivenConditionIdIsBetween500and599_WhenWeatherModelIsIsCreated_ThenConditionNameIsCloudRain() {
        weatherData.conditionId = 520

        XCTAssertEqual(weatherData.conditionName, "cloud.rain")
    }

    func testGivenConditionIdIsBetween600and699_WhenWeatherModelIsIsCreated_ThenConditionNameIsCloudSnow() {
        weatherData.conditionId = 620

        XCTAssertEqual(weatherData.conditionName, "cloud.snow")
    }

    func testGivenConditionIdIsBetween700and799_WhenWeatherModelIsIsCreated_ThenConditionNameIsCloudFog() {
        weatherData.conditionId = 720

        XCTAssertEqual(weatherData.conditionName, "cloud.fog")
    }

    func testGivenConditionIdIs800_WhenWeatherModelIsIsCreated_ThenConditionNameIsSunMin() {
        weatherData.conditionId = 800

        XCTAssertEqual(weatherData.conditionName, "sun.min")
    }

    func testGivenConditionIdIsOver800_WhenWeatherModelIsIsCreated_ThenConditionNameIsDefaultCloud() {
        weatherData.conditionId = 978

        XCTAssertEqual(weatherData.conditionName, "cloud")
    }

}
