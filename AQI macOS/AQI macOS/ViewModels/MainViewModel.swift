//
//  MainViewModel.swift
//  AQI macOS
//
//  Created by Fernando Mata on 4/26/19.
//  Copyright © 2019 Fernando Mata. All rights reserved.
//

import Foundation
import RxSwift
import RxRealm

protocol MainViewModelType {
    var inputs: MainViewModelInputs { get }
    var outputs: MainViewModelOutputs { get }
}

protocol MainViewModelInputs {
    
}

protocol MainViewModelOutputs {
    /// Array with current AQIs
    var aqis: Observable<[AQI]> { get }
    
    /// Show or hide placeholder
    var hideNoCitiesLabel: Observable<Bool> { get }
}

class MainViewModel: MainViewModelType, MainViewModelInputs, MainViewModelOutputs {
    let aqis: Observable<[AQI]>
    let hideNoCitiesLabel: Observable<Bool>
    
    init() {
        aqis = aqisSubject
        aqis = Observable.collection(from: DBManager.shared.aqi).map({ Array($0) }).share(replay: 1, scope: .whileConnected)
        
        hideNoCitiesLabel = aqis.map({ $0.count != 0 })
        
        
    }
    
    var inputs: MainViewModelInputs { return self }
    var outputs: MainViewModelOutputs { return self }
}
