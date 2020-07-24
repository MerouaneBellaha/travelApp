//
//  HTTPClientTest.swift
//  travelAppTests
//
//  Created by Merouane Bellaha on 24/07/2020.
//  Copyright © 2020 Merouane Bellaha. All rights reserved.
//

import XCTest
@testable import travelApp

class HTTPClientTest: XCTestCase {

    var httpClient: HTTPClient!
    var requestResult: (WeatherData?, Error?)


    private func manageResult(with result: Result<WeatherData, RequestError>) {
        switch result {
        case .failure(let error):
            requestResult = (nil, error)
        case .success(let data):
            requestResult = (data, nil)
        }
    }

    func testRequestShouldPostFailureIfError() {
        let URLSession = URLSessionFake(data: nil, response: nil, error: FakeResponseData.error)
        httpClient = HTTPClient(httpEngine: HTTPEngine(session: URLSession))


        httpClient.request(baseUrl: K.baseURLweather) { self.manageResult(with: $0) }

        XCTAssertNil(requestResult.0)
        XCTAssertNotNil(requestResult.1)
        XCTAssertEqual((requestResult.1 as! RequestError).description, "Error")
    }

    func testRequestShouldPostFailureIfNoData() {
        let URLSession = URLSessionFake(data: nil, response: nil, error: nil)
        httpClient = HTTPClient(httpEngine: HTTPEngine(session: URLSession))

        httpClient.request(baseUrl: K.baseURLweather) { self.manageResult(with: $0) }

        XCTAssertNil(requestResult.0)
        XCTAssertNotNil(requestResult.1)
        XCTAssertEqual((requestResult.1 as! RequestError).description, "Can't reach the server, please retry.")
    }

    func testRequestShouldPostFailureIfIncorrestResponse() {
        let URLSession = URLSessionFake(data: FakeResponseData.weatherCorrectData, response: FakeResponseData.responseKO, error: nil)
        httpClient = HTTPClient(httpEngine: HTTPEngine(session: URLSession))

        httpClient.request(baseUrl: K.baseURLweather) { self.manageResult(with: $0) }

        XCTAssertNil(requestResult.0)
        XCTAssertNotNil(requestResult.1)
        XCTAssertEqual((requestResult.1 as! RequestError).description, "Incorrect response")
    }

    func testRequestShouldPostFailureIfIncorrectData() {
        let URLSession = URLSessionFake(data: FakeResponseData.weatherIncorrectData, response: FakeResponseData.responseOK, error: nil)
        httpClient = HTTPClient(httpEngine: HTTPEngine(session: URLSession))

        httpClient.request(baseUrl: K.baseURLweather) { self.manageResult(with: $0) }

        XCTAssertNil(requestResult.0)
        XCTAssertNotNil(requestResult.1)
        XCTAssertEqual((requestResult.1 as! RequestError).description, "Undecodable data")
    }

    func testRequestShouldPostSuccessIfNoErrorAndCorrectData() {
        let URLSession = URLSessionFake(data: FakeResponseData.weatherCorrectData, response: FakeResponseData.responseOK, error: nil)
        httpClient = HTTPClient(httpEngine: HTTPEngine(session: URLSession))

        httpClient.request(baseUrl: K.baseURLweather) { self.manageResult(with: $0) }

        XCTAssertNotNil(requestResult.0)
        XCTAssertNil(requestResult.1)


        let id = 804
        let description = "overcast clouds"
        let temp = 19.11
        let name = "London"

        XCTAssertEqual(requestResult.0?.weather.first?.id, id)
        XCTAssertEqual(requestResult.0?.weather.first?.description, description)
        XCTAssertEqual(requestResult.0?.main.temp, temp)
        XCTAssertEqual(requestResult.0?.name, name)
    }

    override func tearDown() {
        super.tearDown()
        httpClient = nil
        requestResult = (nil, nil)
    }
}
