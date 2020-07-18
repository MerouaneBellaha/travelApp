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

    @IBOutlet weak var timeStampLabel: UILabel!
    @IBOutlet var textFields: [UITextField]!
    @IBOutlet var currencies: [UILabel]!


    // MARK: - Properties

    var coreDataManager: CoreDataManager?
    private var httpClient = HTTPClient()
    private let defaults = UserDefaults.standard

    private var rate: Double!
    private var timeStamp: Int { defaults.integer(forKey: K.timeStamp) }
    private var date: Int { Int(Date().timeIntervalSince1970) }
    
    // MARK: - ViewLifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()

        rate = defaults.double(forKey: K.rate)
        currencies.first?.text = defaults.string(forKey: K.currency) ?? K.USD
        setUpRate()
        setTimeStampLabel()

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
            sender.tag == 0 ? String(format: K.twoDecimals, amount / rate) : String(format: K.twoDecimals, amount * rate)
        }
        self.textFields.first(where: { $0.tag != sender.tag })?.text = result
    }

    @IBAction func refreshRatesTapped(_ sender: UIBarButtonItem) {
        let hourInSeconds = 3600
        guard (date - timeStamp) > hourInSeconds else {
            setAlertVc(with: K.oneByHour)
            return
        }
        httpClient.request(baseUrl: (K.baseURLfixer+K.fixerAPI)) { self.manageResult(with: $0) }
    }
    // MARK: - @objc method

    @objc
    func updateCurrency(notification: Notification) {
        guard let currency = notification.userInfo?[K.currency] as? String else { return }
        currencies.first?.text = currency
        setUpRate()
        defaults.set(currency, forKey: K.currency)
    }

    // MARK: - Methods

    private func textFieldIsUsable(_ sender: UITextField) -> Bool {
        guard sender.text?.isEmpty == false,
            let text = sender.text else {
                textFields.forEach { $0.text?.removeAll() }
                return false
        }
        guard text != K.point else {
            setAlertVc(with: K.startWithPoint)
            sender.text?.removeAll()
            return false
        }
        guard (text.filter { $0 == Character(K.point) }.count) < 2 else {
            setAlertVc(with: K.twoPoints)
            sender.text?.removeLast()
            return false
        }
        return true
    }

    private func shouldNetworkRequest() {
        let dayInSeconds = 86400
        if rate == 0 || timeStamp == 0 || (date - timeStamp) > dayInSeconds {
        httpClient.request(baseUrl: (K.baseURLfixer+K.fixerAPI)) { self.manageResult(with: $0) }
        }
    }

    private func setUpRate() {
        shouldNetworkRequest()
        let currentCurrency = currencies.first?.text
        rate = coreDataManager?.loadItems(entity: Rate.self, currency: currentCurrency).first?.rate
        defaults.set(rate, forKey: K.rate)
    }

    /// Fixer.io free plan allows only hourly update 
    private func setTimeStampLabel() {
        guard timeStamp != 0 else { return }
        let lastUpdate = Date(timeIntervalSince1970: TimeInterval(timeStamp))

        let formatter = DateFormatter()
        formatter.timeZone = TimeZone.current
        formatter.dateFormat = K.dateFormat
        let dateString = formatter.string(from: lastUpdate)
        self.timeStampLabel.text = K.lastUpdate + dateString + K.refresh

    }

    private func manageResult(with result: Result<ConvertedCurrency, RequestError>) {
        switch result {
        case .failure(let error):
            DispatchQueue.main.async {
                self.setAlertVc(with: error.description)
            }
        case .success(let convertedCurrency):
            DispatchQueue.main.async {
                print(convertedCurrency.rates)
                self.defaults.set(convertedCurrency.timestamp, forKey: K.timeStamp)
                convertedCurrency.rates.forEach { object in
                    self.coreDataManager?.createItem(entity: Rate.self) { rate in
                        rate.currency = object.key
                        rate.rate = object.value
                    }}
                let currentCurrency = self.currencies.first?.text
                self.rate = self.coreDataManager?.loadItems(entity: Rate.self, currency: currentCurrency).first?.rate
                self.setTimeStampLabel()
            }
        }
    }
}

