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

        UIView.animate(withDuration: 0.3, animations: {
           self.backgroundColor = #colorLiteral(red: 0.2711130977, green: 0.7006032263, blue: 0.570782236, alpha: 1)
        }) { _ in
            UIView.animate(withDuration: 0.3) {
                self.backgroundColor = .none
            }
        }
    }
}
