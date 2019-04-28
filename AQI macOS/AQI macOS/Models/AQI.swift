//
//  AQI.swift
//  AQI macOS
//
//  Created by Fernando Mata on 4/23/19.
//  Copyright © 2019 Fernando Mata. All rights reserved.
//

import Foundation
import RealmSwift

class AQI: Object {
    var city: City? = nil
    var quality: Int?
    var time: Date?
    
    var pollutionLevel: PollutionLevel {
        return PollutionLevel(value: quality ?? 0)
    }
}
