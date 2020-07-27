//
//  HTTPClient.swift
//  travelApp
//
//  Created by Merouane Bellaha on 18/07/2020.
//  Copyright © 2020 Merouane Bellaha. All rights reserved.
//

import Foundation

final class HTTPClient {

    // MARK: - Properties

    private let httpEngine: HTTPEngine

    // MARK: - Init

    init(httpEngine: HTTPEngine = HTTPEngine(session: URLSession(configuration: .default))) {
        self.httpEngine = httpEngine
    }

    func request<T: Decodable>(baseUrl: String, parameters: [(String, Any)]? = nil, callback: @escaping (Result<T, RequestError>) -> Void) {
        httpEngine.request(baseUrl: baseUrl, parameters: parameters) { data, response, error in
            guard error == nil else {
                callback(.failure(.error))
                return
            }
            guard let data = data else {
                callback(.failure(.noData))
                return
            }
            guard let response = response, response.statusCode == 200 else {
                callback(.failure(.incorrectResponse))
                return
            }
            guard let dataDecoded = try? JSONDecoder().decode(T.self, from: data) else {
                callback(.failure(.undecodableData))
                return
            }
            callback(.success(dataDecoded))
        }
    }
}
