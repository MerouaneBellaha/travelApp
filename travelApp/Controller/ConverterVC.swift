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
    
    @IBOutlet weak var lastUpdateLabel: UILabel!
    @IBOutlet var currencyLabels: [UILabel]!
    @IBOutlet var textFields: [UITextField]!
    @IBOutlet weak var currentRatesLabel: UILabel!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Properties
    
    var coreDataManager: CoreDataManager?
    private var httpClient = HTTPClient()
    private let defaults = UserDefaults.standard
    private let rateManager = RateManager()
    private var dateManager: DateManager { setDateManager() }
    private var currencyList: [Rate] { setCurrencyList() }
    
    // MARK: - ViewLifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpKeyboardBehaviour()
        setLabels()
        performRequestDaily()
        setLastUpdateLabel()

        NotificationCenter.default.addObserver(self, selector: #selector(updateDefaultCurrency(notification:)), name: .updateCurrency, object: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        textFields.forEach { $0.text?.removeAll() }
    }
    
    // MARK: - IBAction methods
    
    @IBAction func textFieldDidChange(_ sender: UITextField) {
        guard isTextUsable(from: sender) else { return }
        guard let amount = Double(sender.text!) else { return }
        let result = performConversion(with: amount, senderTag: sender.tag)
        textFields.first(where: { $0.tag != sender.tag })?.text = result
    }
    
    @IBAction func refreshRatesTapped(_ sender: UIBarButtonItem) {
        guard dateManager.didOneHourHasPass else {
            setAlertVc(with: K.oneByHour)
            return
        }
        httpClient.request(baseUrl: K.baseURLfixer, parameters: [K.fixerQuery]) { [unowned self] result in
            self.manageResult(with: result) }
    }
    
    // MARK: - @objc method
    
    // retrieve currency chosen in settings tab
    @objc
    func updateDefaultCurrency(notification: Notification) {
        guard let currency = notification.userInfo?[K.currency] as? String else { return }
        print(currency)
        currencyLabels.last?.text = currency
        currentRatesLabel.text = K.currentRates + (currencyLabels.last?.text ?? K.emptyString)
        performRequestDaily()
    }
    
    // MARK: - Methods

    private func isTextUsable(from sender: UITextField) -> Bool {
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
    
    private func performConversion(with amount: Double, senderTag: Int) -> String {
        guard let rates = getRatesForConversion(senderTag: senderTag) else { return "" }
        let result = rateManager.calculConversion(of: amount, with: rates.0, and: rates.1)
        return result
    }
    
    // get rates for 1 euro for both currencies currently chosen by the user
    private func getRatesForConversion(senderTag: Int) -> (Double, Double)? {
        guard let firstCurrency = currencyLabels.first(where: { $0.tag == senderTag })?.text,
            let firstRate = getRateInEuro(for: firstCurrency) else { return nil }
        guard let secondCurrency = currencyLabels.first(where: { $0.tag != senderTag })?.text,
            let secondRate = getRateInEuro(for: secondCurrency) else { return nil }
        return (firstRate, secondRate)
    }
    
    private func getRateInEuro(for currency: String) -> Double? {
        guard let rate = coreDataManager?.loadItems(entity: Rate.self, predicate: .currency(currency)).first?.rate else { return nil }
        return rate
    }
    
    private func performRequestDaily() {
        if dateManager.didOneDayHasPass {
            httpClient.request(baseUrl: K.baseURLfixer, parameters: [K.fixerQuery]) { [unowned self] result in
                self.manageResult(with: result) }
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
                convertedCurrency.rates.forEach { item in
                    self.coreDataManager?.createItem(entity: Rate.self) { rate in
                        rate.currency = item.key
                        rate.rate = item.value
                    }}
                self.setLastUpdateLabel()
                self.tableView.reloadData()
            }
        }
    }
    
    // return full currency list or currency list filtered by the text entered in searchBar
    private func setCurrencyList() -> [Rate] {
        switch searchBar.text?.isEmpty {
        case true:
            guard let currencyList = (coreDataManager?.loadItems(entity: Rate.self, sortBy: K.currency)) else { return [] }
            return currencyList
        case false:
            guard let text = searchBar.text else { return [] }
            guard let currencyList = coreDataManager?.loadItems(entity: Rate.self, predicate: .currency(text), sortBy: K.currency) else { return [] }
            return currencyList
        default: return []
        }
    }
    
    private func setUpKeyboardBehaviour() {
        hideKeyboardWhenTappedAround()
        setUpToolbar(for: textFields)
        tableView.keyboardDismissMode = .onDrag
    }

    private func setDateManager() -> DateManager {
        var dateManager = DateManager()
        dateManager.apiTimeStamp = defaults.integer(forKey: K.timeStamp)
        dateManager.presentDate = Int(Date().timeIntervalSince1970)
        return dateManager
    }
    
    private func setLabels() {
        currencyLabels.last?.text = defaults.string(forKey: K.currency) ?? K.defaultCurrency
        currentRatesLabel.text = K.currentRates + (currencyLabels.last?.text)!
    }
    
    private func setLastUpdateLabel() {
        guard dateManager.apiTimeStamp != 0 else { return }
        let date = dateManager.lastUpdateDate
        lastUpdateLabel.text = K.lastUpdate + date + K.refresh
    }
}


// MARK: - UITableViewDelegate

extension ConverterVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.animateCellBackground()
        currencyLabels.first?.text = currencyList[indexPath.row].currency
        defaults.set(currencyList[indexPath.row].currency, forKey: K.currency)
        textFields.forEach { $0.text?.removeAll() }
        searchBar.text?.removeAll()
        tableView.reloadData()
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
            let secondRate = getRateInEuro(for: secondCurrency) else { return cell }
        
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
