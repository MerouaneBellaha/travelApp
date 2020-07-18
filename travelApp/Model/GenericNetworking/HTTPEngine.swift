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
    func request(baseUrl: String, parameters: [String] = [], callback: @escaping HTTPResponse) {
        guard let url = URL(string: baseUrl + parameters.joined()) else { return }
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
}
