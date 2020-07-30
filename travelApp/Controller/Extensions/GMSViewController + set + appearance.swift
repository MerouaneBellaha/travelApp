//
//  GMSViewController + set + appearance.swift
//  travelApp
//
//  Created by Merouane Bellaha on 30/07/2020.
//  Copyright © 2020 Merouane Bellaha. All rights reserved.
//

import GooglePlaces

extension GMSAutocompleteViewController {
    func setup() {
        let filter = GMSAutocompleteFilter()
        filter.type = .city
        autocompleteFilter = .some(filter)
    }

    func appearanceSetup() {
        tableCellBackgroundColor = #colorLiteral(red: 0.2215721905, green: 0.3624178171, blue: 0.4913087487, alpha: 1)
        primaryTextHighlightColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        primaryTextColor = UIColor.lightGray
        secondaryTextColor = UIColor.lightGray
    }
}
