//
//  DBManager.swift
//  AQI macOS
//
//  Created by Fernando Mata on 4/26/19.
//  Copyright © 2019 Fernando Mata. All rights reserved.
//

import Foundation
import RealmSwift
import RxRealm

class DBManager {
    let realm: Realm
    
    let cities: Results<City>
    let aqi: Results<AQI>
    
    private var schemaVersion: Int = 1
    
    static let shared = DBManager()
    
    private init() {
        do {
            let config = Realm.Configuration(schemaVersion: UInt64(schemaVersion))
            realm = try Realm(configuration: config)
            
            cities = realm.objects(City.self)
            aqi = realm.objects(AQI.self)
        } catch let error {
            fatalError("Couldn't initialize Realm DB: \(error)")
        }
    }
    
    /// Delete given AQI and attached city
    func deleteAQI(_ aqi: AQI) {
        try? realm.write {
            if let city = aqi.city {
                realm.delete(city)
            }
            realm.delete(aqi)
        }
    }
}
