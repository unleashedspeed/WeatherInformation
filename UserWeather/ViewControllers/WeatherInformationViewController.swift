//
//  WeatherInformationViewController.swift
//  UserWeather
//
//  Created by Saurabh Gupta on 16/07/20.
//  Copyright © 2020 Saurabh Gupta. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class WeatherInformationViewController: UIViewController {

    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var weatherIconImageView: UIImageView!
    @IBOutlet weak var weatherTitleLabel: UILabel!
    @IBOutlet weak var weatherDescriptionLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var sunriseLabel: UILabel!
    @IBOutlet weak var sunsetLabel: UILabel!
    @IBOutlet weak var feelsLikeLabel: UILabel!
    @IBOutlet weak var cloudsCoverageLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var pressureLabel: UILabel!
    @IBOutlet weak var windSpeedLabel: UILabel!
    @IBOutlet weak var coordinateLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    
    var coordinate: CLLocationCoordinate2D!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        showWeatherInformation(for: coordinate)
    }
    
    private func showWeatherInformation(for coordinate: CLLocationCoordinate2D) {
        APIManager.shared.getWeatherData(for: coordinate) { (weatherData, error) in
            guard let weatherData = weatherData else { return }
            DispatchQueue.main.async {
                self.navBar.topItem?.title = weatherData.cityName
                self.timeLabel.text = Date.getString(fromDate: Date(timeIntervalSince1970: weatherData.dt ?? 0), timeZone: .current, dateFormat: .hourAndMinutes)
                self.weatherTitleLabel.text = weatherData.weather?.first?.main
                self.weatherDescriptionLabel.text = weatherData.weather?.first?.description
                self.temperatureLabel.text = "\(getCelsius(valueInKelvin: weatherData.main?.tempKelvin).roundToDecimal(2))°C"
                self.sunriseLabel.text = Date.getString(fromDate: Date(timeIntervalSince1970: weatherData.sys?.sunrise ?? 0), timeZone: .current, dateFormat: .hourAndMinutes)
                self.sunsetLabel.text = Date.getString(fromDate: Date(timeIntervalSince1970: weatherData.sys?.sunset ?? 0), timeZone: .current, dateFormat: .hourAndMinutes)
                if let cloudsInformation = weatherData.clouds?.all {
                    self.cloudsCoverageLabel.text = "\(cloudsInformation)%"
                }
                if let feelsLikeTemperature = weatherData.main?.feelsLike {
                    self.feelsLikeLabel.text = "\(getCelsius(valueInKelvin: feelsLikeTemperature).roundToDecimal(2))°C"
                }
                if let humidityInformation = weatherData.main?.humidity {
                    self.humidityLabel.text = "\(humidityInformation)%"
                }
                if let pressureInformation = weatherData.main?.pressure {
                    self.pressureLabel.text = "\(pressureInformation)"
                }
                if let windSpeedInformation = weatherData.wind?.speed {
                    self.windSpeedLabel.text = "\(windSpeedInformation)km/h"
                }
                if let latitude = weatherData.coord?.lat, let longitude = weatherData.coord?.lon {
                    self.coordinateLabel.text = "\(latitude), \(longitude)"
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = self.coordinate
                    annotation.title = weatherData.cityName
                    self.mapView.showAnnotations([annotation], animated: false)
                }
                if let icon = weatherData.weather?.first?.icon {
                    self.weatherIconImageView.image = UIImage(url: URL(string: "\(APIManager.shared.iconURL)\(icon)@2x.png"))
                }
            }
        }
    }

}
