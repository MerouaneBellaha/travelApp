//
//  WeatherVC.swift
//  travelApp
//
//  Created by Merouane Bellaha on 14/07/2020.
//  Copyright © 2020 Merouane Bellaha. All rights reserved.
//

import UIKit

class WeatherVC: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet var cityLabels: [UILabel]!
    @IBOutlet var conditionLabels: [UILabel]!
    @IBOutlet var temperaturesLabels: [UILabel]!
    @IBOutlet var weatherIcons: [UIImageView]!
    
    private var httpClient = HTTPClient()
    private var weatherData: WeatherModel!
    private var defaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self

        setUpKeyboard()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let userCity = defaults.string(forKey: "city") ?? "New york"
        httpClient.request(baseUrl: (K.baseURLweather + K.weatherAPI), parameters: [K.query + userCity]) { self.manageResult(with: $0, forUserCity: true) }
    }

    private func manageResult(with result: Result<WeatherData, RequestError>, forUserCity: Bool = false) {
        switch result {
        case .failure(let error):
            DispatchQueue.main.async {
                var message: String {
                    if error == .incorrectResponse {
                        return forUserCity ? "Ville inconnu, veuillez verifier la ville entré dans settings" : "Impossible de trouver cette ville, vérifier l'orthographe"
                    } else { return error.description }
                }
                self.setAlertVc(with: message)
            }
        case .success(let weatherData):
            DispatchQueue.main.async {
                var index: Int { forUserCity ? 1 : 0 }
                self.weatherData = WeatherModel(weatherData: weatherData)
                self.cityLabels[index].text = self.weatherData.cityName
                self.conditionLabels[index].text = self.weatherData.description
                self.temperaturesLabels[index].text = self.weatherData.temperatureString
                self.weatherIcons[index].image = UIImage(named: self.weatherData.conditionName)
            }
        }
    }
}

extension WeatherVC: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
        guard let city = searchBar.text else { return }
        httpClient.request(baseUrl: (K.baseURLweather + K.weatherAPI), parameters: [K.query + city]) { self.manageResult(with: $0) }
    }
}
