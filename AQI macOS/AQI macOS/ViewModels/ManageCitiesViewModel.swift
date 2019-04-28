//
//  ManageCitiesViewModel.swift
//  AQI macOS
//
//  Created by Fernando Mata on 4/28/19.
//  Copyright © 2019 Fernando Mata. All rights reserved.
//

import Foundation
import RxSwift

protocol ManageCitiesViewModelType {
    var inputs: ManageCitiesViewModelInputs { get }
    var outputs: ManageCitiesViewModelOutputs { get }
}

protocol ManageCitiesViewModelInputs {
    var addCity: AnyObserver<Void> { get }
    
    var removeCity: AnyObserver<Void> { get }
}

protocol ManageCitiesViewModelOutputs {
    var cities: Observable<[City]> { get }
    
    /// Returns a boolean value based on if there are available cities or not
    var isRemovedEnabled: Observable<Bool> { get }
}

class ManageCitiesViewModel: ManageCitiesViewModelType, ManageCitiesViewModelInputs, ManageCitiesViewModelOutputs {
    // Inputs
    let addCity: AnyObserver<Void>
    let removeCity: AnyObserver<Void>
    
    // Outputs
    let cities: Observable<[City]>
    let isRemovedEnabled: Observable<Bool>
    
    // Subjects
    private let addSubject: PublishSubject<Void> = PublishSubject<Void>()
    private let removeSubject: PublishSubject<Void> = PublishSubject<Void>()
    private let citiesSubject: BehaviorSubject<[City]> = BehaviorSubject<[City]>(value: Array(DBManager.shared.cities))
    init() {
        // Inputs
        addCity = addSubject.asObserver()
        
        removeCity = removeSubject.asObserver()
        
        // Outputs
        cities = citiesSubject
        
        isRemovedEnabled = citiesSubject.map({ $0.count > 0 })
    }
    
    var inputs: ManageCitiesViewModelInputs { return self }
    var outputs: ManageCitiesViewModelOutputs { return self }
}
