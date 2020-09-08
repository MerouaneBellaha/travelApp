//
//  RequestError.swift
//  travelApp
//
//  Created by Merouane Bellaha on 14/07/2020.
//  Copyright © 2020 Merouane Bellaha. All rights reserved.
//

import Foundation

enum RequestError: Error {
    case noData, incorrectResponse, undecodableData, error
    
    var description: String {
        switch self {
        case .noData:
            return "Can't reach the server, please retry."
        case .incorrectResponse:
            return "Incorrect response"
        case .undecodableData:
            return "Undecodable data"
        case .error:
            return "Error"
        }
    }
}
