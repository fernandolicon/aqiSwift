//
//  AQI.swift
//  AQI macOS
//
//  Created by Fernando Mata on 4/23/19.
//  Copyright © 2019 Fernando Mata. All rights reserved.
//

import Foundation
import Realm

class AQI: RLMObject {
    var city: City? = nil
    var quality: Int?
    var time: NSDate?
    
    var pollutionLevel: PollutionLevel {
        return PollutionLevel(value: quality ?? 0)
    }
}
