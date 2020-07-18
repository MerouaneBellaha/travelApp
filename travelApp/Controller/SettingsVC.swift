//
//  SettingsVC.swift
//  travelApp
//
//  Created by Merouane Bellaha on 14/07/2020.
//  Copyright © 2020 Merouane Bellaha. All rights reserved.
//

import UIKit

final class SettingsVC: UIViewController {

    @IBOutlet weak var textField: UITextField!
    var coreDataManager: CoreDataManager?

    private var currencies: [String] {
        guard let currencies = (coreDataManager?.loadItems(entity: Rate.self).compactMap { $0.currency }) else { return [] }
        return currencies
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        let result = currencyIsAvailable()
        guard result.0, let currency = result.1 else { return }
        NotificationCenter.default.post(name: .updateCurrency, object: nil, userInfo: ["currency": currency])
    }

    private func currencyIsAvailable() -> (Bool, String?) {
        guard let currency = textField.text?.uppercased() else {
            return (false, nil)
        }
        guard textField.text?.count == 3 else {
            setAlertVc(with: "Devise doit comporter 3 lettres")
            return (false, nil)
        }
        guard currencies.contains(currency) else {
            setAlertVc(with: "Currency non valable")
            textField.text?.removeAll()
            return (false, nil)
        }
        return (true, currency)
    }
}
