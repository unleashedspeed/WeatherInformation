//
//  UserLocationWeatherInformationViewController.swift
//  UserWeather
//
//  Created by Saurabh Gupta on 16/07/20.
//  Copyright © 2020 Saurabh Gupta. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class UserLocationWeatherInformationViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureLocationManager()
        configureMapView()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if CLLocationManager.authorizationStatus() == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
        } else if CLLocationManager.authorizationStatus() == .denied {
            //Can showAlert("Location services were previously denied. Please enable location services for this app in Settings.")
        } else if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            locationManager.startUpdatingLocation()
        }
    }
    
    fileprivate func configureLocationManager() {
        locationManager.delegate = self
        locationManager.distanceFilter = kCLLocationAccuracyNearestTenMeters;
        locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    }
    
    fileprivate func configureMapView() {
        mapView.delegate = self
        mapView.showsUserLocation = true
        
        let doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(mapViewDoubleTapped))
        doubleTapGesture.numberOfTapsRequired = 2
        doubleTapGesture.delegate = self
        mapView.addGestureRecognizer(doubleTapGesture)
    }
    
    fileprivate func showUserLocationWeatherData(for coordinate: CLLocationCoordinate2D) {
        APIManager.shared.getWeatherData(for: coordinate) { (weatherData, error) in
            guard let weatherData = weatherData else { return }
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = weatherData.cityName
            annotation.subtitle = "\(getCelsius(valueInKelvin: weatherData.main?.tempKelvin))°C"
            
            DispatchQueue.main.async {
                self.mapView.addAnnotation(annotation)
                self.mapView.selectAnnotation(annotation, animated: true)
            }
        }
    }
    
    @objc
    func mapViewDoubleTapped(sender: UITapGestureRecognizer) {
        let point = sender.location(in: mapView)
        let coordinate = mapView.convert(point, toCoordinateFrom: mapView)
        if let weatherInformationViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "WeatherInformationViewController") as? WeatherInformationViewController {
            weatherInformationViewController.coordinate = coordinate
            present(weatherInformationViewController, animated: true)
        }
    }
}

extension UserLocationWeatherInformationViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let coordinate = locations.first?.coordinate else { return }
        locationManager.stopUpdatingLocation()
        
        showUserLocationWeatherData(for: coordinate)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
        } else if status == .authorizedWhenInUse {
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Unable to access your current location")
    }
}

extension UserLocationWeatherInformationViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is MKPointAnnotation else { return nil }

        let identifier = "Annotation"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)

        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView!.canShowCallout = true
        } else {
            annotationView!.annotation = annotation
        }

        return annotationView
    }
}

extension UserLocationWeatherInformationViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
