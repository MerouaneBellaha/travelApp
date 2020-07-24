//
//  URLSessionFake.swift
//  travelAppTests
//
//  Created by Merouane Bellaha on 24/07/2020.
//  Copyright © 2020 Merouane Bellaha. All rights reserved.
//

import Foundation

    // MARK: - URLSessionFake

class URLSessionFake: URLSession {

    // MARK: - Properties

    var data: Data?
    var response: URLResponse?
    var error: Error?
    var task: URLSessionDataTaskFake

    // MARK: - Init

    init(data: Data?, response: URLResponse?, error: Error?) {
        self.data = data
        self.response = response
        self.error = error
        self.task = URLSessionDataTaskFake(data: data, urlResponse: response, responseError: error)
    }

    // MARK: - Overriding Methods

    override func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        task.completionHandler = completionHandler
        return task
    }

    override func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        task.completionHandler = completionHandler
        return task
    }

}

    // MARK: - URLSessionDataTaskFake

class URLSessionDataTaskFake: URLSessionDataTask {

    // MARK: - Properties

    var completionHandler: ((Data?, URLResponse?, Error?) -> Void)?
    var data: Data?
    var urlResponse: URLResponse?
    var responseError: Error?

    // MARK: - Init

    init(data: Data?, urlResponse: URLResponse?, responseError: Error?) {
        self.data = data
        self.urlResponse = urlResponse
        self.responseError = responseError
    }

    // MARK: - Overriding Methods

    override func resume() {
        completionHandler?(data, urlResponse, responseError)
    }
}
