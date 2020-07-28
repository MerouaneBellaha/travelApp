//
//  UITabBarController + appearance.swift
//  travelApp
//
//  Created by Merouane Bellaha on 27/07/2020.
//  Copyright © 2020 Merouane Bellaha. All rights reserved.
//

import UIKit

extension UITabBarController {
    override open func viewDidLoad() {
        super.viewDidLoad()
        tabBar.clipsToBounds = true
        tabBar.barTintColor = #colorLiteral(red: 0.1575194299, green: 0.2418842614, blue: 0.3167798817, alpha: 1)
        let layer = CAShapeLayer()
        layer.path = UIBezierPath(roundedRect: CGRect(x: 30, y: tabBar.bounds.minY + 5, width: tabBar.bounds.width - 60, height: tabBar.bounds.height + 10), cornerRadius: (tabBar.frame.width/2)).cgPath
        layer.borderWidth = 5
        layer.opacity = 1.0
        layer.isHidden = false
        layer.masksToBounds = false
        layer.fillColor = #colorLiteral(red: 0.2258040011, green: 0.3627184033, blue: 0.479197979, alpha: 1)

        tabBar.layer.insertSublayer(layer, at: 0)

        if let items = tabBar.items {
            items.forEach { $0.imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: -15, right: 0) }
        }

        tabBar.itemWidth = 30.0
        tabBar.itemPositioning = .centered
    }
}
