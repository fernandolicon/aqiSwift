//
//  CitySearchDelegate.swift
//  AQI macOS
//
//  Created by Fernando Mata on 29/04/19.
//  Copyright © 2019 Fernando Mata. All rights reserved.
//

import Foundation
import Cocoa
import RxSwift

class CitySearchDelegate: NSObject, NSTableViewDelegate, NSTableViewDataSource {
    private var cities: [City] = []
    
    weak var tableView: NSTableView?
    
    //RxSwift
    fileprivate let citiesSubject: PublishSubject<[City]> = PublishSubject<[City]>()
    
    private var disposeBag: DisposeBag = DisposeBag()
    
    init(tableView: NSTableView) {
        super.init()
        
        self.tableView = tableView
        self.internalBindings()
    }
    
    func internalBindings() {
        citiesSubject.subscribe(onNext: { [weak self] (cities) in
            self?.cities = cities
            self?.tableView?.reloadData()
        }).disposed(by: disposeBag)
    }
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return cities.count
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        guard let cell = tableView.makeView(withIdentifier: .basicCell, owner: self) as? NSTableCellView else {
            return nil
        }
        
        let city = cities[row]
        cell.textField?.stringValue = city.name
        return cell
    }
}

extension Reactive where Base: CitySearchDelegate {
    var cities: AnyObserver<[City]> {
        return base.citiesSubject.asObserver()
    }
}

