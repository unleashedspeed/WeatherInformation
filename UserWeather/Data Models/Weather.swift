//
//  Weather.swift
//  UserWeather
//
//  Created by Saurabh Gupta on 16/07/20.
//  Copyright © 2020 Saurabh Gupta. All rights reserved.
//

import Foundation

struct CurrentWeatherData: Decodable {
    
    let weather: [Weather]?
    let coord: Coordinates?
    let base: String? ///Internal paramenter for station information
    let main: Main?
    let visibility: Int?
    let wind: Wind?
    let clouds: Clouds?
    let dt: Double?
    let sys: Sys?
    let cityId: Int?
    let cityName: String? ///City name
    let statusCode: Int? /// cod - Internal parameter for HTTP Response
    
    struct Weather: Decodable {
        let id: Int?
        let main: String?
        let description: String?
        let icon: String?
    }
    
    struct Coordinates: Decodable {
        let lon: Double?
        let lat: Double?
    }
    
    struct Main: Decodable {
        let tempKelvin: Double? ///Temperature. Unit Default: Kelvin, Metric: Celsius, Imperial: Fahrenheit.
        let pressure: Int?
        let humidity: Int?
        let feelsLike: Double?
        
        private enum CodingKeys: String, CodingKey {
            case tempKelvin = "temp"
            case feelsLike = "feels_like"
            case pressure
            case humidity
        }
    }
    
    struct Wind: Decodable {
        let speed: Double?
        let deg: Int?
    }
    
    struct Clouds: Decodable {
        let all: Int? /// Percentage Value
    }
    
    struct Sys: Decodable {
        let type: Int?
        let id: Int?
        let message: Double?
        let country: String?
        let sunrise: Double?
        let sunset: Double?
    }
    
    private enum CodingKeys: String, CodingKey {
        case weather
        case coord
        case base
        case main
        case visibility
        case wind
        case clouds
        case dt
        case sys
        case cityId = "id"
        case cityName = "name"
        case statusCode = "cod"
    }
    
}

func getFahrenheit(valueInKelvin: Double?) -> Double {
    if let kelvin = valueInKelvin {
        return ((kelvin - 273.15) * 1.8) + 32
    } else {
        return 0
    }
}

func getCelsius(valueInKelvin: Double?) -> Double {
    if let kelvin = valueInKelvin {
        return kelvin - 273.15
    } else {
        return 0
    }
}
