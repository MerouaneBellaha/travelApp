//
//  RequestError.swift
//  travelApp
//
//  Created by Merouane Bellaha on 14/07/2020.
//  Copyright © 2020 Merouane Bellaha. All rights reserved.
//

import Foundation

enum RequestError: Error {
    case incorrectUrl, noData, incorrectResponse, undecodableData
    
    var description: String {
        switch self {
        case .incorrectUrl:
            return "incorrect URL"
        case .noData:
            return "Found no data"
        case .incorrectResponse:
            return "incorrect response"
        case .undecodableData:
            return "undecodable data"
        }
    }
}
