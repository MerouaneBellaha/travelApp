//
//  UIViewController + setSwipe.swift
//  travelApp
//
//  Created by Merouane Bellaha on 30/07/2020.
//  Copyright © 2020 Merouane Bellaha. All rights reserved.
//

import UIKit

extension UIViewController {
    func setSwipe() {
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeGesture))
        swipeRight.direction = .right
        self.view.addGestureRecognizer(swipeRight)

        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeGesture))
        swipeLeft.direction = .left
        self.view.addGestureRecognizer(swipeLeft)
    }

    @objc
    private func handleSwipeGesture(_ gesture: UISwipeGestureRecognizer) {
      guard let tabBarController = tabBarController, let viewControllers = tabBarController.viewControllers else { return }
      let tabs = viewControllers.count
      if gesture.direction == .left {
          if (tabBarController.selectedIndex) < tabs {
              tabBarController.selectedIndex += 1
          }
      } else if gesture.direction == .right {
          if (tabBarController.selectedIndex) > 0 {
              tabBarController.selectedIndex -= 1
          }
      }
    }
}
