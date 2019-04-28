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

    @IBOutlet weak var tableView: NSScrollView!
    @IBOutlet weak var addButton: NSButton!
    @IBOutlet weak var removeButton: NSButton!
    
    private let viewModel: ManageCitiesViewModelType = ManageCitiesViewModel()
    private var disposeBag: DisposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        initSteps()
    }
    
    private func initSteps() {
        bindViewModel()
        bindGestures()
    }
    
    private func bindViewModel() {
        viewModel.outputs.isRemovedEnabled.bind(to: removeButton.rx.isEnabled).disposed(by: disposeBag)
    }
    
    private func bindGestures() {
        addButton.rx.leftClickGesture().when(.recognized).map({_ in}).bind(to: viewModel.inputs.addCity).disposed(by: disposeBag)
        
        removeButton.rx.leftClickGesture().when(.recognized).map({_ in}).bind(to: viewModel.inputs.removeCity).disposed(by: disposeBag)
    }
}
