//
//  ManageCitiesViewController.swift
//  AQI macOS
//
//  Created by Fernando Mata on 4/28/19.
//  Copyright © 2019 Fernando Mata. All rights reserved.
//

import Cocoa
import RxSwift
import RxCocoa
import RxGesture

class ManageCitiesViewController: NSViewController {

    @IBOutlet weak var tableView: NSTableView!
    @IBOutlet weak var searchBar: NSSearchField!
    @IBOutlet weak var searchTableView: NSTableView!
    @IBOutlet weak var searchContainerView: NSScrollView!
    
    private var searchDelegate: CitySearchDelegate!
    
    private let viewModel: ManageCitiesViewModelType = ManageCitiesViewModel()
    private var disposeBag: DisposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        initSteps()
    }
    
    private func initSteps() {
        createUI()
        bindViewModel()
        bindGestures()
    }
    
    private func createUI() {
        searchContainerView.alphaValue = 0.0
        
        searchDelegate = CitySearchDelegate(tableView: searchTableView)
        searchTableView.delegate = searchDelegate
        searchTableView.dataSource = searchDelegate
    }
    
    private func bindViewModel() {
        viewModel.outputs.citiesFound.bind(to: searchDelegate.rx.cities).disposed(by: disposeBag)
    }
    
    private func bindGestures() {
        
    }
}

extension ManageCitiesViewController: NSSearchFieldDelegate {
    func searchFieldDidStartSearching(_ sender: NSSearchField) {
        searchContainerView.isHidden = false
        NSAnimationContext.runAnimationGroup { (context) in
            context.duration = 0.3
            context.allowsImplicitAnimation = true
            context.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeIn)
            self.searchContainerView.alphaValue = 1.0
        }
    }
    
    func searchFieldDidEndSearching(_ sender: NSSearchField) {
        self.searchContainerView.alphaValue = 0.0
        self.searchContainerView.isHidden = true
    }
    
    func controlTextDidChange(_ obj: Notification) {
        viewModel.inputs.searchKeyword.onNext(searchBar.stringValue)
    }
}
