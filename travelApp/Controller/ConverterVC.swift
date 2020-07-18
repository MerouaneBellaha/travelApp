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
    @IBOutlet var currencyLabels: [UILabel]!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    

    // MARK: - Properties

    var coreDataManager: CoreDataManager?
    private var httpClient = HTTPClient()
    private let defaults = UserDefaults.standard

    private var rate: Double!
    private var timeStamp: Int { defaults.integer(forKey: K.timeStamp) }
    private var date: Int { Int(Date().timeIntervalSince1970) }
    private var currencyList: [Rate] {
        switch searchBar.text?.isEmpty {
        case true:
            guard let currencies = (coreDataManager?.loadItems(entity: Rate.self)) else { return [] }
            return currencies
            case false:
            guard let currencies = (coreDataManager?.loadItems(entity: Rate.self, currency: searchBar.text)) else { return [] }
            return currencies
        default: return []
        }
    }
    
    // MARK: - ViewLifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self

        rate = defaults.double(forKey: K.rate)
        currencyLabels.first?.text = defaults.string(forKey: K.currency) ?? K.USD
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
        currencyLabels.first?.text = currency
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
        let currentCurrency = currencyLabels.first?.text
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
                self.coreDataManager?.deleteItems(entity: Rate.self)
                self.defaults.set(convertedCurrency.timestamp, forKey: K.timeStamp)
                convertedCurrency.rates.forEach { object in
                    self.coreDataManager?.createItem(entity: Rate.self) { rate in
                        rate.currency = object.key
                        rate.rate = object.value
                    }}
                let currentCurrency = self.currencyLabels.first?.text
                self.rate = self.coreDataManager?.loadItems(entity: Rate.self, currency: currentCurrency).first?.rate
                self.setTimeStampLabel()
                self.tableView.reloadData()
            }
        }
    }
}

    // MARK: - UITableViewDelegate

extension ConverterVC: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.animateCellBackground()
        currencyLabels.first?.text = currencyList[indexPath.row].currency
        setUpRate()
        defaults.set(currencyList[indexPath.row].currency, forKey: K.currency)
        textFields.forEach { $0.text?.removeAll() }
    }
}

    // MARK: - UITableViewDataSource

extension ConverterVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currencyList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.rateCell, for: indexPath)
        cell.detailTextLabel?.text = (String(currencyList[indexPath.row].rate))
        cell.textLabel?.text = currencyList[indexPath.row].currency
        return cell
    }
}

extension ConverterVC: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        tableView.reloadData()
    }
}
