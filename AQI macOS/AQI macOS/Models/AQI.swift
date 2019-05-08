//
//  AQI.swift
//  AQI macOS
//
//  Created by Fernando Mata on 4/23/19.
//  Copyright © 2019 Fernando Mata. All rights reserved.
//

import Foundation
import Realm
import RealmSwift
import Marshal

class AQI: Object {
    @objc dynamic var city: City? = nil
    @objc dynamic var quality: Int = 0
    @objc dynamic var time: Date? = nil
    
    var pollutionLevel: PollutionLevel {
        return PollutionLevel(value: quality)
    }
    
    init(withCity city: City) {
        super.init()
        
        self.quality = 0
        self.time = Date()
        self.city = city
    }
    
    required init() {
        super.init()
    }
    
    required init(realm: RLMRealm, schema: RLMObjectSchema) {
        super.init(realm: realm, schema: schema)
    }
    
    required init(value: Any, schema: RLMSchema) {
        super.init(value: value, schema: schema)
    }
    
    func updateAQI(object: MarshaledObject) throws {
        quality = try object.value(for: "aqi")
        if let timeObject = (try? object.any(for: "time")) as? [String : Any],
            let timeString = timeObject["s"] as? String,
            let timeZone = timeObject["tz"] as? String {
            self.time = DateFormatter.apiDateFor(time: timeString, timeZone: timeZone)
        }
    }
}
