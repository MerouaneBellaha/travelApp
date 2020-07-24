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

    func testRequestShouldPostFailureIfError() {
        performRequest(data: nil, response: nil, error: FakeResponseData.error)
        testRequestResult(description: "Error")
    }

    func testRequestShouldPostFailureIfNoData() {
        performRequest(data: nil, response: nil, error: nil)
        testRequestResult(description: "Can't reach the server, please retry.")
    }

    func testRequestShouldPostFailureIfIncorrestResponse() {
        performRequest(data: FakeResponseData.weatherCorrectData, response: FakeResponseData.responseKO, error: nil)
        testRequestResult(description: "Incorrect response")
    }

    func testRequestShouldPostFailureIfIncorrectData() {
        performRequest(data: FakeResponseData.weatherIncorrectData, response: FakeResponseData.responseOK, error: nil)
        testRequestResult(description: "Undecodable data")
    }

    func testRequestShouldPostSuccessIfNoErrorAndCorrectData() {
        performRequest(data: FakeResponseData.weatherCorrectData, response: FakeResponseData.responseOK, error: nil)

        XCTAssertNotNil(requestResult.0)
        XCTAssertNil(requestResult.1)

        testRetrivedData()
    }

    private func performRequest(data: Data?, response: URLResponse?, error: Error?) {
        let URLSession = URLSessionFake(data: data, response: response, error: error)
        httpClient = HTTPClient(httpEngine: HTTPEngine(session: URLSession))
        httpClient.request(baseUrl: K.baseURLweather) { self.manageResult(with: $0) }
    }

    private func testRequestResult(description: String) {
        XCTAssertNil(requestResult.0)
        XCTAssertNotNil(requestResult.1)
        XCTAssertEqual((requestResult.1 as! RequestError).description, description)
    }

    private func testRetrivedData() {
        let id = 804
        let description = "overcast clouds"
        let temp = 19.11
        let name = "London"

        XCTAssertEqual(requestResult.0?.weather.first?.id, id)
        XCTAssertEqual(requestResult.0?.weather.first?.description, description)
        XCTAssertEqual(requestResult.0?.main.temp, temp)
        XCTAssertEqual(requestResult.0?.name, name)
    }

    private func manageResult(with result: Result<WeatherData, RequestError>) {
        switch result {
        case .failure(let error):
            requestResult = (nil, error)
        case .success(let data):
            requestResult = (data, nil)
        }
    }

    override func tearDown() {
        super.tearDown()
        httpClient = nil
        requestResult = (nil, nil)
    }
}
