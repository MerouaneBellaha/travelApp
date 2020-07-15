//
//  UIViewController + setAlertVc.swift
//  travelApp
//
//  Created by Merouane Bellaha on 15/07/2020.
//  Copyright © 2020 Merouane Bellaha. All rights reserved.
//

import UIKit

extension UIViewController {
    func setAlertVc(with message: String) {
        let alertVC = UIAlertController(title: "Oups!", message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alertVC, animated: true, completion: nil)
    }
}
