//
//  Double+Extension.swift
//  UserWeather
//
//  Created by Saurabh Gupta on 16/07/20.
//  Copyright © 2020 Saurabh Gupta. All rights reserved.
//

import Foundation

extension Double {
    
    func roundToDecimal(_ fractionDigits: Int) -> Double {
        let multiplier = pow(10, Double(fractionDigits))
        
        return Darwin.round(self * multiplier) / multiplier
    }
}
