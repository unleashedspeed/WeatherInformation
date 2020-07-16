//
//  Date+Extension.swift
//  UserWeather
//
//  Created by Saurabh Gupta on 16/07/20.
//  Copyright © 2020 Saurabh Gupta. All rights reserved.
//

import Foundation

extension Date {

    //MARK: Converts a given string date to Date object.
    static func getDate(from string: String,
                        timeZone: TimeZone?,
                        dateFormat: DateFormat = .dateFormatFromAPI) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat.rawValue
        dateFormatter.timeZone = timeZone
        
        return dateFormatter.date(from: string)
    }

    //MARK: Converts a given date to String object.
    static func getString(fromDate date: Date,
                          timeZone: TimeZone?,
                          dateFormat: DateFormat = .dateFormatFromAPI) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat.rawValue
        dateFormatter.timeZone = timeZone
        
        return dateFormatter.string(from: date)
    }
    
    // Enums specific to Date Class.
    enum DateFormat: String {
        case dateFormatFromAPI = "yyyy-MM-dd'T'HH:mm:ss"
        case hourAndMinutes = "hh:mm a"
    }
}
