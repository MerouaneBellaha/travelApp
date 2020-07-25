//
//  TranslatorAPI.swift
//  travelApp
//
//  Created by Merouane Bellaha on 25/07/2020.
//  Copyright © 2020 Merouane Bellaha. All rights reserved.
//

import Foundation

enum TranslatorAPI {
    case detect, translate, languages

    func getBaseURL() -> String {
        switch self {
        case .detect:
            return "https://translation.googleapis.com/language/translate/v2/detect"
        case .translate:
            return "https://translation.googleapis.com/language/translate/v2"
        case .languages:
            return "https://translation.googleapis.com/language/translate/v2/languages"
        }
    }

    func setHTTTPmethod() -> String {
        guard self == .languages else {
            return "POST"
        }
        return "GET"
    }
}
