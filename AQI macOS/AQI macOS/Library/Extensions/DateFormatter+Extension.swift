//
//  DateFormatter.swift
//  AQI macOS
//
//  Created by Fernando Mata on 5/6/19.
//  Copyright © 2019 Fernando Mata. All rights reserved.
//

import Foundation

extension DateFormatter {
    static func apiDateFor(time: String, timeZone: String) -> Date? {
        // This format comes from AQI API documentation http://aqicn.org/json-api/doc/
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ssZZZZZ"
        return dateFormatter.date(from: time + timeZone)
    }
}
