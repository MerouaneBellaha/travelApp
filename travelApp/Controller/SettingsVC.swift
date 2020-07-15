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

    var currencies: [String] {
        guard let currencies = UserDefaults.standard.string(forKey: "currencies")?.components(separatedBy: "-") else { return ["USD"] }
        return currencies
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }


    @IBAction func buttonTapped(_ sender: UIButton) {
        guard let currency = textField.text?.uppercased() else {
            return
        }
        guard currencies.contains(currency) else {
            setAlertVc(with: "Currency non valable")
            textField.text?.removeAll()
            return
        }
        NotificationCenter.default.post(name: .updateCurrency, object: nil, userInfo: ["currency": currency])
    }
}
