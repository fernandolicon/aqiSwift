//
//  AQIUpdateManager.swift
//  AQI macOS
//
//  Created by Fernando Mata on 5/8/19.
//  Copyright © 2019 Fernando Mata. All rights reserved.
//

import Foundation
import Moya
import RxSwift

class AQIUpdateManager {
    static let shared = AQIUpdateManager()
    
    // Default is 10 min, this would be a config value in the future
    private let frequency: Double = 600

    private var activeCities: [City] = []
    private var activeRequests: [City: Cancellable] = [:]
    
    private var timer: Timer?
    
    private var disposeBag: DisposeBag = DisposeBag()
    
    func start() {}
    
    private init() {
        bindModel()
        timer = frequencyTimer()
    }
    
    private func frequencyTimer() -> Timer {
        return Timer.scheduledTimer(timeInterval: frequency, target: self, selector: #selector(updateCities), userInfo: nil, repeats: true)
    }
    
    private func bindModel() {
        let cities = Observable.collection(from: DBManager.shared.cities).map({ Array($0) }).share(replay: 1, scope: .whileConnected)

        cities.subscribe(onNext: { [unowned self] (cities) in
            let updates = Array.diffArrays(lhs: self.activeCities, rhs: cities)
            let newCities = updates.added
            let removedCities = updates.removed
            removedCities.forEach({ city in
                self.activeRequests[city]?.cancel()
            })

            newCities.forEach({ (city) in
                // Perform first data request
                AQIProvider.shared.request(AQIService.getAQI(city: city.urlString), completion: { [weak self] (result) in
                    switch result {
                    case let .success(response):
                        self?.didReceiveCity(response, city: city)
                    case .failure:
                        return
                    }
                })
            })
            
            self.activeCities = cities
        }).disposed(by: disposeBag)
    }
    
    @objc private func updateCities() {
        self.activeCities.forEach({ (city) in
            self.activeRequests[city] = AQIProvider.shared.request(AQIService.getAQI(city: city.urlString), completion: { [weak self] (result) in
                self?.activeRequests.removeValue(forKey: city)
                switch result {
                case let .success(response):
                    self?.didReceiveCity(response, city: city)
                case .failure:
                    return
                }
            })
        })
    }
    
    private func didReceiveCity(_ response: Response, city: City) {
        guard let responseDict = try? response.mapJSON() as? [String : Any],
            let aqisDict = responseDict?["data"] as? [String : Any] else {
                return
        }
        
        var aqi: AQI! = DBManager.shared.aqi.filter({ $0.city == city }).first
        if aqi == nil {
            aqi = AQI(withCity: city)
            try? DBManager.shared.realm.write {
                DBManager.shared.realm.add(aqi)
            }
        }
        
        try? DBManager.shared.realm.write {
            try? aqi.updateAQI(object: aqisDict)
        }
    }
    
    func reloadData() {
        timer?.invalidate()
        activeRequests.forEach({ $0.value.cancel() })
        activeRequests.removeAll()
        updateCities()
        timer = frequencyTimer()
    }
}
