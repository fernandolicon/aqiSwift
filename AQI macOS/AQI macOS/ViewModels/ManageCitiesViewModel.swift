//
//  ManageCitiesViewModel.swift
//  AQI macOS
//
//  Created by Fernando Mata on 4/28/19.
//  Copyright © 2019 Fernando Mata. All rights reserved.
//

import Foundation
import RxSwift
import Moya

protocol ManageCitiesViewModelType {
    var inputs: ManageCitiesViewModelInputs { get }
    var outputs: ManageCitiesViewModelOutputs { get }
}

protocol ManageCitiesViewModelInputs {
    var removeCity: AnyObserver<Void> { get }
    
    var searchKeyword: AnyObserver<String> { get }
    
    var didSelectCity: AnyObserver<City> { get }
}

protocol ManageCitiesViewModelOutputs {
    var cities: Observable<[City]> { get }
    
    /// Returns a boolean value based on if there are available cities or not
    var isRemovedEnabled: Observable<Bool> { get }
    
    /// Get cities found by search string
    var citiesFound: Observable<[City]> { get }
    
    /// Rest search when user selected city
    var resetSearch: Observable<Void> { get }
}

class ManageCitiesViewModel: ManageCitiesViewModelType, ManageCitiesViewModelInputs, ManageCitiesViewModelOutputs {
    // Inputs
    let removeCity: AnyObserver<Void>
    let searchKeyword: AnyObserver<String>
    let didSelectCity: AnyObserver<City>
    
    // Outputs
    let cities: Observable<[City]>
    let isRemovedEnabled: Observable<Bool>
    let citiesFound: Observable<[City]>
    let resetSearch: Observable<Void>
    
    // Subjects
    private let removeSubject: PublishSubject<Void> = PublishSubject<Void>()
    private let citiesSubject: BehaviorSubject<[City]> = BehaviorSubject<[City]>(value: Array(DBManager.shared.cities))
    private let keywordSubject: PublishSubject<String> = PublishSubject<String>()
    private let selectedCity: PublishSubject<City> = PublishSubject<City>()
    
    private var disposeBag = DisposeBag()
    init() {
        // Inputs
        removeCity = removeSubject.asObserver()
        
        searchKeyword = keywordSubject.asObserver()
        
        didSelectCity = selectedCity.asObserver()
        
        // Outputs
        cities = citiesSubject
        
        isRemovedEnabled = citiesSubject.map({ $0.count > 0 })

        citiesFound = keywordSubject.debounce(0.5, scheduler: MainScheduler.instance)
            .flatMap( { AQIProvider.shared.rx.request(AQIService.search($0)) } )
            .map({ (response) -> [City] in
                guard let responseDict = try? response.mapJSON() as? [String : Any],
                let aqisDict = responseDict?["data"] as? [[String : Any]] else {
                    return []
                }
                
                let cities = aqisDict.compactMap({ $0["station"] as? [String : Any] }).compactMap({ try? City(object: $0) })
                
                return cities
            })
        
        resetSearch = selectedCity.map({_ in})
        
        // Internal bindings
        selectedCity.subscribe(onNext: { (city) in
            try? DBManager.shared.realm.write {
                DBManager.shared.realm.add(city)
            }
        }).disposed(by: disposeBag)
    }
    
    var inputs: ManageCitiesViewModelInputs { return self }
    var outputs: ManageCitiesViewModelOutputs { return self }
}
