//
//  City.swift
//  AQI macOS
//
//  Created by Fernando Mata on 4/23/19.
//  Copyright © 2019 Fernando Mata. All rights reserved.
//

import Foundation
import Realm
import RealmSwift
import CoreLocation
import Marshal

class City: Object, Unmarshaling {
    var name: String = ""
    var urlString: String = ""
    var lat: Double = 0.0
    var long: Double = 0.0
    var order: Int = 0
    
    var url: URL? {
        return URL(string: urlString)
    }
    
    required init(object: MarshaledObject) throws {
        super.init()
        
        name = try object.value(for: "name")
        urlString = try object.value(for: "url")
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
}

