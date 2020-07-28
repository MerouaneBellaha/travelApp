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

    @IBOutlet weak var tableView: UITableView!
    
    var coreDataManager: CoreDataManager?
    private var httpClient = HTTPClient()
    private var defaults = UserDefaults.standard
    private var language: [String]?
    private var currencies: [String] { setCurrencies() }
    private var settingsCategory: [(String, String)] {
        [("Currency", defaults.string(forKey: K.currency) ?? K.USD),
         ("Language", defaults.string(forKey: "language") ?? "english"),
         ("Weather", defaults.string(forKey: "city") ?? "New York")]
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        requestLanguages()
    }

    private func setCurrencies() -> [String] {
        guard let currencies = (coreDataManager?.loadItems(entity: Rate.self).compactMap { $0.currency }) else { return [] }
        return currencies
    }

    private func requestLanguages() {
        let deviceLanguage = Locale.current.languageCode ?? "en"
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
                self.language = language.data.languages.map { $0.name }
            }
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destinationVc = segue.destination as? SettingsTableVC else { return }
        guard let indexPathRow = sender as? Int else { return }
        destinationVc.senderIndexPathRow = indexPathRow
        destinationVc.delegate = self
        destinationVc.content = indexPathRow == 0 ? currencies : language ?? []
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

extension SettingsVC: SettingProtocol {
    func didUpdateLanguage(with language: String) {
        defaults.removeObject(forKey: "language")
        defaults.set(language, forKey: "language")
        tableView.reloadData()
        NotificationCenter.default.post(name: .updateLanguage, object: nil, userInfo: ["language": language])
    }

    func didUpdateCurrency(with currency: String) {
        defaults.removeObject(forKey: K.currency)
        defaults.set(currency, forKey: K.currency)
        tableView.reloadData()
        NotificationCenter.default.post(name: .updateCurrency, object: nil, userInfo: [K.currency: currency])
    }
}


extension SettingsVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingsCategory.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "settingCell", for: indexPath)
        cell.textLabel?.text = settingsCategory[indexPath.row].0
        cell.detailTextLabel?.text = settingsCategory[indexPath.row].1
        //        change accessory color
        return cell
    }
}

extension SettingsVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        switch indexPath.row {
        case 0, 1:
            performSegue(withIdentifier: "toSettingsTVC", sender: indexPath.row)
        case 2:
            presentSearchPlacesVC()
        default: break
        }
    }
}

extension SettingsVC: GMSAutocompleteViewControllerDelegate {
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        guard let city = place.name else { return }
        defaults.removeObject(forKey: "city")
        defaults.set(city, forKey: "city")
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
