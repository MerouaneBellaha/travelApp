//
//  URLSessionFake.swift
//  travelAppTests
//
//  Created by Merouane Bellaha on 24/07/2020.
//  Copyright © 2020 Merouane Bellaha. All rights reserved.
//

import Foundation

class URLSessionFake: URLSession {

    var data: Data?
    var response: URLResponse?
    var error: Error?
    var task: URLSessionDataTaskFake

    init(data: Data?, response: URLResponse?, error: Error?) {
        self.data = data
        self.response = response
        self.error = error
        self.task = URLSessionDataTaskFake(data: data, urlResponse: response, responseError: error)
    }

    override func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
//        let task = URLSessionDataTaskFake(data: data, urlResponse: response, responseError: error)
        task.completionHandler = completionHandler
        return task
    }

    override func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
//        let task = URLSessionDataTaskFake(data: data, urlResponse: response, responseError: error)
        task.completionHandler = completionHandler
        return task
    }

}

class URLSessionDataTaskFake: URLSessionDataTask {

    var completionHandler: ((Data?, URLResponse?, Error?) -> Void)?

    var data: Data?
    var urlResponse: URLResponse?
    var responseError: Error?

    init(data: Data?, urlResponse: URLResponse?, responseError: Error?) {
        self.data = data
        self.urlResponse = urlResponse
        self.responseError = responseError
    }

    override func resume() {
        completionHandler?(data, urlResponse, responseError)
    }

    override func cancel() {}
}
