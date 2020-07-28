//
//  SettingsVC.swift
//  travelApp
//
//  Created by Merouane Bellaha on 14/07/2020.
//  Copyright © 2020 Merouane Bellaha. All rights reserved.
//

import UIKit
import GooglePlaces

final class SettingsVC: UIViewController {

    // MARK: - IBOutlet properties

    @IBOutlet weak var tableView: UITableView!

    // MARK: - Properties

    var coreDataManager: CoreDataManager?
    private var httpClient = HTTPClient()
    private var defaults = UserDefaults.standard
    private var languages: [String]?
    private var currencies: [String] { setCurrencies() }
    private var settingsCategories: [(String, String)] {
        [(K.currency, defaults.string(forKey: K.currency) ?? K.defaultCurrency),
         (K.language, defaults.string(forKey: K.language) ?? K.defaultLanguage),
         (K.weather, defaults.string(forKey: K.city) ?? K.defaultCity)]
    }

    // MARK: - ViewLifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        requestLanguages()
    }

    // MARK: - Methods

    private func setCurrencies() -> [String] {
        guard let currencies = (coreDataManager?.loadItems(entity: Rate.self).compactMap { $0.currency }) else { return [] }
        return currencies
    }

    private func requestLanguages() {
        let deviceLanguage = Locale.current.languageCode ?? K.defaultLanguages
        httpClient.request(baseUrl: K.baseURLlanguages, parameters: [K.googleQuery, (K.target, deviceLanguage)]) { [unowned self] result in
            self.manageResult(with: result)}
    }

    private func manageResult(with result: Result<LanguageData, RequestError>) {
        switch result {
        case .failure(let error):
            DispatchQueue.main.async {
                self.setAlertVc(with: error.description)
            }
        case .success(let language):
            DispatchQueue.main.async {
                self.languages = language.data.languages.map { $0.name }
            }
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destinationVc = segue.destination as? SettingsTableVC else { return }
        guard let indexPathRow = sender as? Int else { return }
        destinationVc.senderIndexPathRow = indexPathRow
        destinationVc.delegate = self
        destinationVc.content = indexPathRow == 0 ? currencies : languages ?? []
    }

    private func presentSearchPlacesVC() {
        let searchPlaces = GMSAutocompleteViewController()
        let filter = GMSAutocompleteFilter()
        filter.type = .city
        searchPlaces.autocompleteFilter = .some(filter)
        searchPlaces.delegate = self
        present(searchPlaces, animated: true)
    }
}

// MARK: - SettingProtocol

extension SettingsVC: SettingProtocol {
    func didUpdateLanguage(with language: String) {
        defaults.removeObject(forKey: K.language)
        defaults.set(language, forKey: K.language)
        tableView.reloadData()
        NotificationCenter.default.post(name: .updateLanguage, object: nil, userInfo: [K.language: language])
    }

    func didUpdateCurrency(with currency: String) {
        defaults.removeObject(forKey: K.currency)
        defaults.set(currency, forKey: K.currency)
        tableView.reloadData()
        NotificationCenter.default.post(name: .updateCurrency, object: nil, userInfo: [K.currency: currency])
    }
}

// MARK: - UITableViewDataSource

extension SettingsVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingsCategories.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.settingCell, for: indexPath)
        cell.textLabel?.text = settingsCategories[indexPath.row].0
        cell.detailTextLabel?.text = settingsCategories[indexPath.row].1
        //        change accessory color
        return cell
    }
}

// MARK: - UITableViewDelegate

extension SettingsVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        switch indexPath.row {
        case 0, 1:
            performSegue(withIdentifier: K.toSettingsTVC, sender: indexPath.row)
        case 2:
            presentSearchPlacesVC()
        default: break
        }
    }
}

// MARK: - GMSAutocompleteViewControllerDelegate

extension SettingsVC: GMSAutocompleteViewControllerDelegate {
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        guard let city = place.name else { return }
        defaults.removeObject(forKey: K.city)
        defaults.set(city, forKey: K.city)
        tableView.reloadData()
        dismiss(animated: true)
    }

    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true)
    }

    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        print(error)
    }
}
