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
    var coreDataManager: CoreDataManager?

    var currencies: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        guard let currencies = (coreDataManager?.loadItems().compactMap { $0.currency }) else { return }
        self.currencies = currencies
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
