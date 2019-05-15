//
//  AQICellModel.swift
//  AQI macOS
//
//  Created by Fernando Mata on 4/25/19.
//  Copyright © 2019 Fernando Mata. All rights reserved.
//

import Foundation
import RxSwift
import RxOptional

protocol AQICellModelType {
    var inputs: AQICellModelInputs { get }
    var outputs: AQICellModelOutputs { get }
}

protocol AQICellModelInputs {
    var aqiObserver: AnyObserver<AQI> { get }
    
    var deleteObserver: AnyObserver<Void> { get }
}

protocol AQICellModelOutputs {
    var backgroundColor: Observable<CGColor> { get }
    
    /// AQI City name
    var cityName: Observable<String?> { get }
    
    /// Formatted AQI value
    var qualityValue: Observable<String> { get }
    
    // AQI level text description
    var qualityDescription: Observable<String?> { get }
    
    var deleteAQI: Observable<AQI> { get }
}

class AQICellModel: AQICellModelType, AQICellModelInputs, AQICellModelOutputs {
    // Inputs
    let aqiObserver: AnyObserver<AQI>
    let deleteObserver: AnyObserver<Void>
    
    // Outputs
    let backgroundColor: Observable<CGColor>
    let cityName: Observable<String?>
    let qualityValue: Observable<String>
    let qualityDescription: Observable<String?>
    let deleteAQI: Observable<AQI>
    
    // Subjects
    let aqiSubject: ReplaySubject<AQI> = ReplaySubject<AQI>.create(bufferSize: 1)
    let deleteSubject: PublishSubject<Void> = PublishSubject<Void>()
    
    init() {
        // Inputs
        aqiObserver = aqiSubject.asObserver()
        
        deleteObserver = deleteSubject.asObserver()
        
        // Outputs
        backgroundColor = aqiSubject.map({ $0.pollutionLevel.color.cgColor })
        
        cityName = aqiSubject.map({ $0.city?.name })
        
        qualityValue = aqiSubject.map({ "\($0.quality)" })
        
        qualityDescription = aqiSubject.map({ $0.pollutionLevel.localizedName })
        
        deleteAQI = deleteSubject.withLatestFrom(aqiSubject)
    }
    
    var inputs: AQICellModelInputs { return self }
    var outputs: AQICellModelOutputs { return self }
}
