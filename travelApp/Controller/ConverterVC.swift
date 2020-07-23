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
    @IBOutlet weak var currentRatesLabel: UILabel!
    

    // MARK: - Properties

    var coreDataManager: CoreDataManager?
    private var httpClient = HTTPClient()
    private let defaults = UserDefaults.standard
    private let rateManager = RateManager()
    private var dateManager: DateManager {
        var dateManager = DateManager()
        dateManager.timeStamp = defaults.integer(forKey: K.timeStamp)
        dateManager.date = Int(Date().timeIntervalSince1970)
        return dateManager
    }
    private var currencyList: [Rate] { getCurrencyList() }
    
    // MARK: - ViewLifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self

        tableView.keyboardDismissMode = .onDrag
        setUpKeyboard(textFields: textFields)

        currencyLabels.last?.text = defaults.string(forKey: K.currency) ?? K.USD
        currentRatesLabel.text = K.currentRates + (currencyLabels.last?.text)!

        shouldNetworkRequest()

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
        updateResult(with: amount, senderTag: sender.tag)
    }

    @IBAction func refreshRatesTapped(_ sender: UIBarButtonItem) {
        guard dateManager.didOneHourPassed else {
            setAlertVc(with: K.oneByHour)
            return
        }
        httpClient.request(baseUrl: K.baseURLfixer, parameters: [K.fixerQuery]){ self.manageResult(with: $0) }
        }

    // MARK: - @objc method

    @objc
    func updateCurrency(notification: Notification) {
        guard let currency = notification.userInfo?[K.currency] as? String else { return }
        currencyLabels.last?.text = currency
        currentRatesLabel.text = K.currentRates + (currencyLabels.last?.text)!
        defaults.set(currency, forKey: K.currency)
        shouldNetworkRequest()
    }

    // MARK: - Methods

    private func textFieldIsUsable(_ sender: UITextField) -> Bool {
        guard sender.text?.isEmpty == false,
            let text = sender.text else {
                textFields.forEach { $0.text?.removeAll() } //
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

    private func updateResult(with amount: Double, senderTag: Int) {
        guard let firstCurrency = currencyLabels.first(where: { $0.tag == senderTag })?.text,
            let firstRate = coreDataManager?.loadItems(entity: Rate.self, predicate: .currency(firstCurrency)).first?.rate else { return }
        guard let secondCurrency = currencyLabels.first(where: { $0.tag != senderTag })?.text,
            let secondRate = coreDataManager?.loadItems(entity: Rate.self, predicate: .currency(secondCurrency)).first?.rate else { return }

        let result = rateManager.calculConversion(of: amount, with: firstRate, and: secondRate)
        textFields.first(where: { $0.tag != senderTag })?.text = result
    }

    private func shouldNetworkRequest() {
        if dateManager.didOneDayPassed {
            httpClient.request(baseUrl: K.baseURLfixer, parameters: [K.fixerQuery]) { self.manageResult(with: $0) }
        }
    }

    private func setTimeStampLabel() {
        guard dateManager.timeStamp != 0 else { return }
        let date = dateManager.lastUpdateDate
        self.timeStampLabel.text = K.lastUpdate + date + K.refresh

    }

    private func getCurrencyList() -> [Rate] {
        switch searchBar.text?.isEmpty {
        case true:
            guard let currencies = (coreDataManager?.loadItems(entity: Rate.self, sortBy: K.currency)) else { return [] }
            return currencies
        case false:
            guard let text = searchBar.text else { return [] }
            guard let currencies = coreDataManager?.loadItems(entity: Rate.self, predicate: .currency(text), sortBy: K.currency) else { return [] }
            return currencies
        default: return []
        }
    }

    private func manageResult(with result: Result<CurrencyData, RequestError>) {
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
        cell.textLabel?.text = currencyList[indexPath.row].currency

        let firstRate = currencyList[indexPath.row].rate
        guard let secondCurrency = currencyLabels.last?.text,
            let secondRate = (coreDataManager?.loadItems(entity: Rate.self, predicate: .currency(secondCurrency)).first?.rate) else { return cell }
        
        cell.detailTextLabel?.text = rateManager.getActualRate(of: firstRate, and: secondRate, format: K.sixDecimals)

        return cell
    }
}

    // MARK: - UISearchBarDelegate

extension ConverterVC: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        tableView.reloadData()
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
    }
}
