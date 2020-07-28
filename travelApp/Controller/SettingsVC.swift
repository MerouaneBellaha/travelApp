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
    @IBOutlet weak var cityTextField: UITextField!

    var coreDataManager: CoreDataManager?
    var defaults = UserDefaults.standard

    private var currencies: [String] {
        guard let currencies = (coreDataManager?.loadItems(entity: Rate.self).compactMap { $0.currency }) else { return [] }
        return currencies
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
    }
    
    @IBAction func currencyButtonTapped(_ sender: UIButton) {
        guard let currency = currencyIsAvailable() else { return }
        NotificationCenter.default.post(name: .updateCurrency, object: nil, userInfo: [K.currency: currency])
        defaults.removeObject(forKey: K.currency)
        defaults.set(currency, forKey: K.currency)
    }

    @IBAction func cityButtonTapped(_ sender: UIButton) {
        defaults.set(cityTextField.text, forKey: "city")
    }

    private func currencyIsAvailable() -> String? {
        guard let currency = textField.text?.uppercased() else {
            return nil
        }
        guard textField.text?.count == 3 else {
            setAlertVc(with: K.minThreeLetters)
            return nil
        }
        guard currencies.contains(currency) else {
            setAlertVc(with: K.unavailableCurrency)
            textField.text?.removeAll()
            return nil
        }
        return currency
    }
}
