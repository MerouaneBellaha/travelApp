//
//  NetworkingRequest.swift
//  travelApp
//
//  Created by Merouane Bellaha on 14/07/2020.
//  Copyright © 2020 Merouane Bellaha. All rights reserved.
//

import Foundation

class NetworkingRequest {
    
    var baseURL = "http://data.fixer.io/api/latest"
    var fixerAPIKey = "?access_key=873a90d1ce1ba971ee5c9051fd3039e6"
    
    // MARK: - Properties
    
    private let session: URLSession
    private var task: URLSessionDataTask?
    
    // MARK: - Init
    
    init(session: URLSession = URLSession(configuration: .default)) {
        self.session = session
    }
    
    // MARK: - Methods
    
    func getConversionRate(callBack: @escaping (Result<ConvertedCurrency, RequestError>) -> ()) {
        
        guard let request = URL(string: baseURL+fixerAPIKey) else {
            callBack(.failure(.incorrectUrl))
            return
        }
        print(request.absoluteString)
        
        task?.cancel()
        
        task = session.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                callBack(.failure(.noData))
                return
            }
            
            guard let response = response as? HTTPURLResponse,
                response.statusCode == 200 else {
                    callBack(.failure(.incorrectResponse))
                    return
            }
            
            guard let responseJson = try? JSONDecoder().decode(ConvertedCurrency.self, from: data) else {
                callBack(.failure(.noData))

                return
            }
            callBack(.success(responseJson))
        }
        task?.resume()
    }
}
