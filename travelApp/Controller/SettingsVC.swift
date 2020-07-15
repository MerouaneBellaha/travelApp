//
//  SettingsVC.swift
//  travelApp
//
//  Created by Merouane Bellaha on 14/07/2020.
//  Copyright © 2020 Merouane Bellaha. All rights reserved.
//

import UIKit

class SettingsVC: UIViewController {

    @IBOutlet weak var textField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

    }


    @IBAction func buttonTapped(_ sender: UIButton) {
        guard let currency = textField.text else {
            return
        }
         NotificationCenter.default.post(name: .updateCurrency, object: nil, userInfo: ["currency": currency])
    }
}
