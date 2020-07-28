//
//  WeatherVC.swift
//  travelApp
//
//  Created by Merouane Bellaha on 14/07/2020.
//  Copyright © 2020 Merouane Bellaha. All rights reserved.
//

import UIKit
import CoreLocation
import GooglePlaces

class WeatherVC: UIViewController {

    // MARK: - IBOutlet properties

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet var cityLabels: [UILabel]!
    @IBOutlet var conditionLabels: [UILabel]!
    @IBOutlet var temperaturesLabels: [UILabel]!
    @IBOutlet var weatherIcons: [UIImageView]!
    @IBOutlet weak var overlay: UIView!
    @IBOutlet weak var topForecastView: UIStackView!
    
    // MARK: - Properties

    private var httpClient = HTTPClient()
    private var weatherData: WeatherModel!
    private var defaults = UserDefaults.standard
    private var activityIndicator: UIAlertController!
    private let locationManager = CLLocationManager()

    // MARK: - ViewLifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        hideKeyboardWhenTappedAround()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        performRequestWithUserCity()
    }

    // MARK: - IBAction methods

    @IBAction func getUserLocation(_ sender: UIButton? = nil) {
        setActivityAlert(withTitle: K.wait, message: K.localForecast) { alertController in
            self.locationManager.requestLocation()
            self.activityIndicator = alertController
        }
    }

    // MARK: - Methods

    private func manageResult(with result: Result<WeatherData, RequestError>, forUserCity: Bool = false) {
        switch result {
        case .failure(let error):
            DispatchQueue.main.async {
                guard error != .error else { return }
                var message: String {
                    if error == .incorrectResponse {
                        return forUserCity ? K.cityErrorSettings : K.cityErrorSearched
                    } else { return error.description }
                }
                self.setAlertVc(with: message)
            }
        case .success(let weatherData):
            DispatchQueue.main.async {
                var index: Int { forUserCity ? 1 : 0 }
                self.weatherData = WeatherModel(weatherData: weatherData)
                self.weatherIcons[index].image = UIImage(named: self.weatherData.conditionName)
                self.cityLabels[index].text = self.weatherData.cityName
                self.temperaturesLabels[index].text = self.weatherData.temperatureString
                self.conditionLabels[index].text = self.weatherData.description
            }
        }
    }

    private func performRequestWithUserCity() {
        let userCity = defaults.string(forKey: K.city) ?? K.defaultCity
        httpClient.request(baseUrl: K.baseURLweather,
                           parameters: [K.weatherQuery, K.metric, (K.query, userCity)]) { [unowned self] result in
        self.manageResult(with: result, forUserCity: true) }
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

// MARK: - UISearchBarDelegate

extension WeatherVC: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        presentSearchPlacesVC()
    }
}

// MARK: - CLLocationManagerDelegate

extension WeatherVC: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let currentLocation = locations.last else { return }
        locationManager.stopUpdatingLocation()
        let lon = String(currentLocation.coordinate.longitude)
        let lat = String(currentLocation.coordinate.latitude)
        activityIndicator.dismiss(animated: true)
        overlay.isHidden = true
        topForecastView.isHidden = false
        httpClient.request(baseUrl: K.baseURLweather,
                           parameters: [K.weatherQuery, K.metric, (K.queryLat, lat), (K.queryLon, lon)]) { [unowned self] result in
            self.manageResult(with: result)
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) { print(error) }
}

// MARK: - GMSAutocompleteViewControllerDelegate

extension WeatherVC: GMSAutocompleteViewControllerDelegate {
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        guard let city = place.name else { return }
        overlay.isHidden = true
        topForecastView.isHidden = false
        dismiss(animated: true) {
            self.httpClient.request(baseUrl: K.baseURLweather,
                                    parameters: [K.weatherQuery, K.metric, (K.query, city)]) { [unowned self] result in
                self.manageResult(with: result) }
        }
    }

    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        print(error.localizedDescription)
    }

    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true)
    }
}
