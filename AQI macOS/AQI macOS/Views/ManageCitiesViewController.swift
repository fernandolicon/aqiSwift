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
        
        viewModel.outputs.resetSearch
            .delay(0.4, scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] (_) in
                self?.searchBar.window?.makeFirstResponder(nil)
                let finishBlock = { [weak self] in
                    self?.searchBar.stringValue = ""
                    self?.searchBar.cell?.accessibilityPerformCancel()
                }
                self?.hideSearchTableView(animated: true, finishBlock: finishBlock)
                
        }).disposed(by: disposeBag)
    }
    
    private func bindGestures() {
        searchDelegate.rx.selectedCity.bind(to: viewModel.inputs.didSelectCity).disposed(by: disposeBag)
    }
    
    fileprivate func hideSearchTableView(animated: Bool = false, finishBlock: (()->())? = nil) {
        guard animated else {
            searchContainerView.alphaValue = 0.0
            searchContainerView.isHidden = true
            return
        }
        
        NSAnimationContext.runAnimationGroup({ (context) in
            context.duration = 0.3
            context.allowsImplicitAnimation = true
            context.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeIn)
            self.searchContainerView.alphaValue = 0.0
        }) {
            self.searchContainerView.isHidden = true
            finishBlock?()
        }
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
        hideSearchTableView()
    }
    
    func controlTextDidChange(_ obj: Notification) {
        guard searchBar.stringValue != "" else { return }
        
        viewModel.inputs.searchKeyword.onNext(searchBar.stringValue)
    }
}
