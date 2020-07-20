//
//  UIView + animateCellBackground.swift
//  travelApp
//
//  Created by Merouane Bellaha on 18/07/2020.
//  Copyright © 2020 Merouane Bellaha. All rights reserved.
//

import UIKit

extension UITableViewCell {
    func animateCellBackground() {
        UIView.animate(withDuration: 0.5) {
            self.backgroundColor = #colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 1)
        }
        UIView.animate(withDuration: 0.3) {
            self.backgroundColor = .white
        }
    }
}
