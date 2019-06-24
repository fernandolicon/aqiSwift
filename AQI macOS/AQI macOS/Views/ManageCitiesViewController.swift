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
    @IBOutlet weak var networkIndicator: NSProgressIndicator!
    
    private var citiesDelegate: CitiesListDelegate!
    private var searchDelegate: CitySearchDelegate!
    
    private let viewModel: ManageCitiesViewModelType = ManageCitiesViewModel()
    private var disposeBag: DisposeBag = DisposeBag()
    
    private var hasShownTable = false
    
    var shouldEnableDelete: Bool {
        return tableView.selectedRow >= 0
    }
    
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
        
        citiesDelegate = CitiesListDelegate(tableView: tableView)
        tableView.delegate = citiesDelegate
        tableView.dataSource = citiesDelegate
        
        searchDelegate = CitySearchDelegate(tableView: searchTableView)
        searchTableView.delegate = searchDelegate
        searchTableView.dataSource = searchDelegate
    }
    
    private func bindViewModel() {
        viewModel.outputs.cities.bind(to: citiesDelegate.rx.cities).disposed(by: disposeBag)
        
        viewModel.outputs.citiesFound.bind(to: searchDelegate.rx.cities).disposed(by: disposeBag)
        
        viewModel.outputs.resetSearch
            .delay(0.4, scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] (_) in
                self?.searchBar.window?.makeFirstResponder(nil)
                let finishBlock = { [weak self] in
                    self?.searchBar.stringValue = ""
                    if let cancelCell = self?.searchBar.cell as? NSSearchFieldCell,
                        let cancelButton = cancelCell.cancelButtonCell {
                        cancelButton.performClick(self)
                    }
                }
                self?.hideSearchTableView(animated: true, finishBlock: finishBlock)
        }).disposed(by: disposeBag)
        
        viewModel.outputs.hideIndicator.subscribe(onNext: { [weak self] (shouldHide) in
            guard let `self` = self else { return }
            if shouldHide {
                self.networkIndicator.isHidden = true
                self.networkIndicator.stopAnimation(self)
            } else {
                if self.hasShownTable {
                    self.networkIndicator.startAnimation(self)
                    self.networkIndicator.isHidden = false
                }
            }
        }).disposed(by: disposeBag)
    }
    
    private func bindGestures() {
        searchDelegate.rx.selectedCity.bind(to: viewModel.inputs.didSelectCity).disposed(by: disposeBag)
        
        citiesDelegate.rx.didReorderCity.bind(to: viewModel.inputs.didReorderCity).disposed(by: disposeBag)
    }
    
    fileprivate func hideSearchTableView(animated: Bool = false, finishBlock: (()->())? = nil) {
        guard animated else {
            searchContainerView.alphaValue = 0.0
            searchContainerView.isHidden = true
            networkIndicator.isHidden = true
            hasShownTable = false
            return
        }
        
        NSAnimationContext.runAnimationGroup({ (context) in
            context.duration = 0.3
            context.allowsImplicitAnimation = true
            context.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeIn)
            self.searchContainerView.alphaValue = 0.0
            self.networkIndicator.isHidden = true
        }) {
            self.searchContainerView.isHidden = true
            self.networkIndicator.stopAnimation(self)
            self.hasShownTable = false
            finishBlock?()
        }
    }
    
    func didDeleteSelected() {
        viewModel.inputs.deleteCityIndex.onNext(tableView.selectedRow)
    }
    
    @objc fileprivate func didDeleteClicked() {
        viewModel.inputs.deleteCityIndex.onNext(tableView.clickedRow)
    }
}

extension ManageCitiesViewController: NSSearchFieldDelegate {
    func searchFieldDidStartSearching(_ sender: NSSearchField) {
        searchContainerView.isHidden = false
        networkIndicator.startAnimation(self)
        NSAnimationContext.runAnimationGroup({ (context) in
            context.duration = 0.3
            context.allowsImplicitAnimation = true
            context.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeIn)
            self.searchContainerView.alphaValue = 1.0
            self.networkIndicator.isHidden = false
        }) {
            self.hasShownTable = true
        }
    }
    
    func searchFieldDidEndSearching(_ sender: NSSearchField) {
        hideSearchTableView()
    }
    
    func controlTextDidChange(_ obj: Notification) {
        guard searchBar.stringValue != "" else { return }
        
        viewModel.inputs.searchKeyword.onNext(searchBar.stringValue)
    }
}

extension ManageCitiesViewController: NSMenuDelegate {
    func menuNeedsUpdate(_ menu: NSMenu) {
        menu.removeAllItems()
        guard tableView.clickedRow >= 0 else {
            return
        }
        
        let deleteItem = NSMenuItem(title: NSLocalizedString("Delete", comment: ""), action: #selector(didDeleteClicked), keyEquivalent: "")
        menu.insertItem(deleteItem, at: 0)
    }
}
