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
    var deleteAQIObserver: AnyObserver<AQI> { get }
}

protocol MainViewModelOutputs {
    /// Array with current AQIs
    var aqis: Observable<[AQI]> { get }
    
    /// Show or hide placeholder
    var hideNoCitiesLabel: Observable<Bool> { get }
    
    /// Remove removed AQI cell
    var didRemoveAQIatIndex: Observable<Int> { get }
}

class MainViewModel: MainViewModelType, MainViewModelInputs, MainViewModelOutputs {
    // Inputs
    var deleteAQIObserver: AnyObserver<AQI>
    
    // Outputs
    let aqis: Observable<[AQI]>
    let hideNoCitiesLabel: Observable<Bool>
    let didRemoveAQIatIndex: Observable<Int>
    
    // Subjects
    let deleteSubject: PublishSubject<AQI> = PublishSubject<AQI>()
    
    let disposeBag = DisposeBag()
    
    init() {
        // Inputs
        deleteAQIObserver = deleteSubject.asObserver()
        
        // Outputs
        aqis = Observable.collection(from: DBManager.shared.aqi).debounce(0.2, scheduler: MainScheduler.instance).map({ Array($0) }).share(replay: 1, scope: .whileConnected)
        
        hideNoCitiesLabel = aqis.map({ $0.count != 0 })
        
        didRemoveAQIatIndex = deleteSubject.withLatestFrom(aqis, resultSelector: { $1.firstIndex(of: $0) }).filterNil()
        
        // Internal bindings
        deleteSubject.subscribe(onNext: { (aqi) in
            DBManager.shared.deleteAQI(aqi)
        }).disposed(by: disposeBag)
    }
    
    var inputs: MainViewModelInputs { return self }
    var outputs: MainViewModelOutputs { return self }
}
