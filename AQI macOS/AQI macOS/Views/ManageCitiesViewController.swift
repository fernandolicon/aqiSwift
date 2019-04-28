//
//  ManageCitiesViewController.swift
//  AQI macOS
//
//  Created by Fernando Mata on 4/28/19.
//  Copyright © 2019 Fernando Mata. All rights reserved.
//

import Cocoa
import RxSwift
import RxGesture

class ManageCitiesViewController: NSViewController {

    @IBOutlet weak var tableView: NSTableView!
    @IBOutlet weak var searchBar: NSSearchField!
    @IBOutlet weak var searchTableView: NSTableView!
    @IBOutlet weak var searchContainerView: NSScrollView!
    
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
        searchTableView.layer?.borderColor = NSColor.lightGray.cgColor
        searchTableView.layer?.borderWidth = 1
        searchContainerView.isHidden = true
    }
    
    private func bindViewModel() {
        
    }
    
    private func bindGestures() {
        
    }
}

extension ManageCitiesViewController: NSSearchFieldDelegate {
    func searchFieldDidStartSearching(_ sender: NSSearchField) {
        searchContainerView.alphaValue = 0.0
        searchContainerView.isHidden = false
        NSAnimationContext.runAnimationGroup { (context) in
            context.duration = 0.3
            context.allowsImplicitAnimation = true
            context.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeIn)
            self.searchContainerView.animator().alphaValue = 1.0
        }
    }
    
    func searchFieldDidEndSearching(_ sender: NSSearchField) {
        NSAnimationContext.runAnimationGroup({ (context) in
            context.duration = 0.3
            context.allowsImplicitAnimation = true
            context.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeIn)
            self.searchContainerView.animator().alphaValue = 0.0
        }) {
            self.searchContainerView.isHidden = true
        }
    }
}
