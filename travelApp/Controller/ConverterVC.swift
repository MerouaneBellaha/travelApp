//
//  ConverterVC.swift
//  travelApp
//
//  Created by Merouane Bellaha on 14/07/2020.
//  Copyright © 2020 Merouane Bellaha. All rights reserved.
//

import UIKit

class ConverterVC: UIViewController {
    
    // MARK: - IBOutlet properties

    @IBOutlet var textFields: [UITextField]!
    @IBOutlet var currencies: [UILabel]!


    // MARK: - Properties

    var coreDataManager: CoreDataManager?
    private var networkingRequest = NetworkingRequest()
    private let defaults = UserDefaults.standard

    var rate: Double!

    // MARK: - ViewLifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        rate = defaults.double(forKey: "rate")
        currencies.first?.text = defaults.string(forKey: "currency") ?? "USD"
        setUpRate()

        NotificationCenter.default.addObserver(self, selector: #selector(updateCurrency(notification:)), name: .updateCurrency, object: nil)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        textFields.forEach { $0.text?.removeAll() }
    }

    // MARK: - IBAction methods

    @IBAction func textFieldDidChange(_ sender: UITextField) {
        guard textFieldIsUsable(sender) else { return }
        guard let amount = Double(sender.text!) else { return }

        var result: String {
            sender.tag == 0 ? String(format: "%.2f", amount / rate) : String(format: "%.2f", amount * rate)
        }
        self.textFields.first(where: { $0.tag != sender.tag })?.text = result
    }


    // MARK: - @objc method


    @objc
    func updateCurrency(notification: Notification) {
        guard let currency = notification.userInfo?["currency"] as? String else { return }
        currencies.first?.text = currency
        setUpRate()
        defaults.set(currency, forKey: "currency")
    }

    // MARK: - Methods

    private func textFieldIsUsable(_ sender: UITextField) -> Bool {
        guard sender.text?.isEmpty == false,
            let text = sender.text else {
                textFields.forEach { $0.text?.removeAll() }
                return false
        }
        guard text != "." else {
            setAlertVc(with: "Vous ne pouvez pas démarrer avec un point")
            sender.text?.removeAll()
            return false
        }
        guard (text.filter { $0 == "." }.count) < 2 else {
            setAlertVc(with: "Vous ne pouvez pas ajouter un second point")
            sender.text?.removeLast()
            return false
        }
        return true
    }

    private func shouldNetworkRequest() {
        let timeInterval = Int(Date().timeIntervalSince1970)
        let timeStamp = defaults.integer(forKey: "timestamp")
        let dayInSeconds = 86400
        if rate == 0 || timeInterval == 0 || (timeInterval - timeStamp) > dayInSeconds {
            networkingRequest.getConversionRate() { self.manageResult(with: $0) }
        }
    }

    private func setUpRate() {
        shouldNetworkRequest()
        let currentCurrency = currencies.first?.text
        rate = coreDataManager?.loadItems(containing: currentCurrency).first?.rate
        defaults.set(rate, forKey: "rate")

    }

    private func manageResult(with result: Result<ConvertedCurrency, RequestError>) {
        switch result {
        case .failure(let error):
            DispatchQueue.main.async {
                self.setAlertVc(with: error.description)
            }
        case .success(let convertedCurrency):
            DispatchQueue.main.async {
                self.defaults.set(convertedCurrency.timestamp, forKey: "timestamp")
                convertedCurrency.rates.forEach { self.coreDataManager?.createItem(currency: $0.key, rate: $0.value) }
                let currentCurrency = self.currencies.first?.text
                self.rate = self.coreDataManager?.loadItems(containing: currentCurrency).first?.rate
            }
        }
    }
}
