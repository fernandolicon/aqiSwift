//
//  CitiesListDelegate.swift
//  AQI macOS
//
//  Created by Fernando Mata on 30/04/19.
//  Copyright © 2019 Fernando Mata. All rights reserved.
//

import Foundation
import Cocoa
import RxSwift

class CitiesListDelegate: NSObject, NSTableViewDelegate, NSTableViewDataSource {
    private var cities: [City] = []
    
    weak var tableView: NSTableView?
    
    //RxSwift
    fileprivate let citiesSubject: PublishSubject<[City]> = PublishSubject<[City]>()
    fileprivate let selectedCity: PublishSubject<City> = PublishSubject<City>()
    
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
        guard let cell = tableView.makeView(withIdentifier: .cityCell, owner: self) as? NSTableCellView else {
            return nil
        }
        
        let city = cities[row]
        cell.textField?.stringValue = city.name
        return cell
    }
    
    func tableViewSelectionDidChange(_ notification: Notification) {
        guard let selectedRow = tableView?.selectedRow,
        selectedRow > 0,
        selectedRow < cities.count else { return }
        
        selectedCity.onNext(cities[selectedRow])
    }
}

extension Reactive where Base: CitiesListDelegate {
    var cities: AnyObserver<[City]> {
        return base.citiesSubject.asObserver()
    }
    
    var selectedCity: Observable<City> {
        return base.selectedCity
    }
}

