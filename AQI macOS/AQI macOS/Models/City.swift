//
//  City.swift
//  AQI macOS
//
//  Created by Fernando Mata on 4/23/19.
//  Copyright © 2019 Fernando Mata. All rights reserved.
//

import Foundation
import RealmSwift
import CoreLocation

class City: Object {
    var name: String = ""
    var urlString: String?
    var lat: CLLocationDegrees?
    var long: CLLocationDegrees?
    var order: Int = 0
    
    var url: URL? {
        return URL(string: urlString ?? "")
    }
}


