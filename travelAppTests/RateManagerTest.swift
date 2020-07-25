//
//  RateManagerTest.swift
//  travelAppTests
//
//  Created by Merouane Bellaha on 23/07/2020.
//  Copyright © 2020 Merouane Bellaha. All rights reserved.
//

import XCTest
@testable import travelApp

class RateManagerTest: XCTestCase {

    var rateManager: RateManager!

    override func setUp() {
        rateManager = RateManager()
    }

    override func tearDown() {
        rateManager = nil
    }

    func testGivenRandomAmountAndRates_WhenCalculConversion_ThenResultIsAString() {
        let result = rateManager.calculConversion(of: 2.4, with: 1.245, and: 0.3456)

        XCTAssertTrue(type(of: result) == String.self )
    }

    func testGivenRandomAmountAndRates_WhenCalculConversion_ThenResultHave2Decimals() {
        let result = rateManager.calculConversion(of: 2.4, with: 1.245, and: 0.3456)

        let decimals = result.components(separatedBy: ".")[1]

        XCTAssertEqual(decimals.count, 2)
    }


    func testGivenAmountIs7AndRatesAre1And1_165605_WhenCalculConversion_ThenResultIs8_16() {
        let result = rateManager.calculConversion(of: 7, with: 1, and: 1.165605)

        XCTAssertEqual(result, "8.16")
    }
}
