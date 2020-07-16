//
//  APIManager.swift
//  UserWeather
//
//  Created by Saurabh Gupta on 16/07/20.
//  Copyright © 2020 Saurabh Gupta. All rights reserved.
//

import Foundation
import CoreLocation

class APIManager {
    
    static let shared = APIManager()
    
    let apiKey = "27e6b78a797d1d40d3076fc32dbbdcca"
    let baseUrl = "https://api.openweathermap.org/data/2.5/weather?"
    let iconURL = "https://openweathermap.org/img/wn/"
    
    //MARK: Fetches the weather data from OpenWeatherAPI
    func getWeatherData(for coordinate: CLLocationCoordinate2D, completion: @escaping ((CurrentWeatherData?, Error?) -> Void)) {
        let weatherURL = "\(baseUrl)lat=\(coordinate.latitude)&lon=\(coordinate.longitude)&appid=\(apiKey)"
        guard let url = URL(string: weatherURL) else {
            completion(nil, NSError(domain: "Error", code: 101, userInfo: [NSLocalizedDescriptionKey: "URL formation failed."]))
            
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let responseData = data else {
                completion(nil, error)
                
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let weatherData = try decoder.decode(CurrentWeatherData.self, from: responseData)
                completion(weatherData, nil)
            } catch let error {
                completion(nil, error)
            }

        }

        task.resume()
    }

}
