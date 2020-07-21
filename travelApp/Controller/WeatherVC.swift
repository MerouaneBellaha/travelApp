    //
    //  WeatherVC.swift
    //  travelApp
    //
    //  Created by Merouane Bellaha on 14/07/2020.
    //  Copyright © 2020 Merouane Bellaha. All rights reserved.
    //

    import UIKit
    import CoreLocation

    class WeatherVC: UIViewController {

        // MARK: - IBOutlet properties

        @IBOutlet weak var searchBar: UISearchBar!
        @IBOutlet var cityLabels: [UILabel]!
        @IBOutlet var conditionLabels: [UILabel]!
        @IBOutlet var temperaturesLabels: [UILabel]!
        @IBOutlet var weatherIcons: [UIImageView]!
        @IBOutlet weak var overlay: UIView!

        // MARK: - Properties

        private let locationManager = CLLocationManager()
        private var httpClient = HTTPClient()
        private var weatherData: WeatherModel!
        private var defaults = UserDefaults.standard

        // MARK: - ViewLifeCycle

        override func viewDidLoad() {
            super.viewDidLoad()
            locationManager.delegate = self
            locationManager.requestWhenInUseAuthorization()
            searchBar.delegate = self
            setUpKeyboard()
        }

        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            let userCity = defaults.string(forKey: K.city) ?? K.defaultCity
            self.httpClient.request(baseUrl: K.baseURLweather, parameters: [K.weatherAPI, K.metric, (K.query, userCity)]) { self.manageResult(with: $0, forUserCity: true) }

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.getLocationPressed()
            }
        }

        // MARK: - IBAction methods

        @IBAction func getLocationPressed(_ sender: UIButton? = nil) {
            self.overlay.isHidden = false
            locationManager.requestLocation()
        }

        @IBAction func searchPressed(_ sender: UIButton) {
            guard let city = searchBar.text else { return }
            httpClient.request(baseUrl: K.baseURLweather, parameters: [K.weatherAPI, K.metric, (K.query, city)]) { self.manageResult(with: $0) }
        }

        // MARK: - Methods

        private func manageResult(with result: Result<WeatherData, RequestError>, forUserCity: Bool = false) {
            switch result {
            case .failure(let error):
                DispatchQueue.main.async {
                    var message: String {
                        if error == .incorrectResponse {
                            return forUserCity ? K.cityErrorSettings : K.cityErrorSearched
                        } else { return error.description }
                    }
                    self.overlay.isHidden = true
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
                    if index == 0 { self.overlay.isHidden = true }
                }
            }
        }
    }

    // MARK: - UISearchBarDelegate

    extension WeatherVC: UISearchBarDelegate {
        func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
            view.endEditing(true)
            guard let city = searchBar.text else { return }
            httpClient.request(baseUrl: K.baseURLweather, parameters: [K.weatherAPI, K.metric, (K.query, city)]) { self.manageResult(with: $0) }
        }
    }

    // MARK: - CLLocationManagerDelegate

    extension WeatherVC: CLLocationManagerDelegate {

        func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            guard let currentLocation = locations.last else { return }
            locationManager.stopUpdatingLocation()
            let currentLocationLon = currentLocation.coordinate.longitude
            let currentLocationLat = currentLocation.coordinate.latitude
            httpClient.request(baseUrl: K.baseURLweather, parameters: [K.weatherAPI, K.metric, (K.queryLat, String(currentLocationLat)), (K.queryLon, String(currentLocationLon))]) { self.manageResult(with: $0) }
        }

        func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
            print(error)
        }
    }
