//
//  HTTPEngine.swift
//  travelApp
//
//  Created by Merouane Bellaha on 18/07/2020.
//  Copyright © 2020 Merouane Bellaha. All rights reserved.
//

import Foundation

typealias HTTPResponse = (Data?, HTTPURLResponse?, Error?) -> Void

final class HTTPEngine {

    // MARK: - Properties
    
    private let session: URLSession
    private var task: URLSessionDataTask?

    // MARK: - Init

    init(session: URLSession = URLSession(configuration: .default)) {
        self.session = session
    }

    // MARK: - Methods
    
    func request(baseUrl: String, parameters: [(String, Any)]?, callback: @escaping HTTPResponse) {
        guard let baseUrl = URL(string: baseUrl) else { return }
        let url = encode(baseUrl: baseUrl, with: parameters)
        task?.cancel()
        task = session.dataTask(with: url) { data, response, error in
            guard let response = response as? HTTPURLResponse else {
                callback(data, nil, error)
                return
            }
            callback(data, response, error)
        }
        task?.resume()
    }

    private func encode(baseUrl: URL, with parameters: [(String, Any)]?) -> URL {
        guard var urlComponents = URLComponents(url: baseUrl, resolvingAgainstBaseURL: false), let parameters = parameters, !parameters.isEmpty else { return baseUrl }
        urlComponents.queryItems = [URLQueryItem]()
        for (key, value) in parameters {
            let queryItem = URLQueryItem(name: key, value: "\(value)")
            urlComponents.queryItems?.append(queryItem)
        }
        guard let url = urlComponents.url else { return baseUrl }
        return url
    }
}
