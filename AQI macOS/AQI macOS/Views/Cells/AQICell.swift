//
//  AQICell.swift
//  AQI macOS
//
//  Created by Fernando Mata on 4/23/19.
//  Copyright © 2019 Fernando Mata. All rights reserved.
//

import Cocoa
import RxSwift
import SnapKit

class AQICell: NSCollectionViewItem {
    private var qualityText: NSTextField!
    private var qualityDescriptionText: NSTextField!
    private var cityNameText: NSTextField!
    
    private let viewModel: AQICellModelType = AQICellModel()
    
    private var disposeBag: DisposeBag = DisposeBag()
    
    override func loadView() {
        initSteps()
    }
    
    private func initSteps() {
        createUI()
        bindStyles()
        bindViewModel()
    }
    
    private func createUI() {
        view = NSView()
        view.wantsLayer = true
        
        cityNameText = NSTextField()
        cityNameText.textColor = NSColor.white
        cityNameText.isBezeled = false
        cityNameText.isEditable = false
        cityNameText.backgroundColor = NSColor.clear
        cityNameText.alignment = .center
        view.addSubview(cityNameText)
        cityNameText.snp.makeConstraints { (make) in
            make.left.top.right.equalToSuperview().inset(4)
        }
        
        qualityText = NSTextField()
        qualityText.textColor = NSColor.white
        qualityText.backgroundColor = NSColor.clear
        qualityText.isBezeled = false
        qualityText.isEditable = false
        view.addSubview(qualityText)
        qualityText.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
        
        qualityDescriptionText = NSTextField()
        qualityDescriptionText.textColor = NSColor.white
        qualityDescriptionText.backgroundColor = NSColor.clear
        qualityDescriptionText.isBezeled = false
        qualityDescriptionText.isEditable = false
        qualityDescriptionText.alignment = .center
        qualityDescriptionText.maximumNumberOfLines = 0
        view.addSubview(qualityDescriptionText)
        qualityDescriptionText.snp.makeConstraints { (make) in
            make.right.bottom.left.equalToSuperview().inset(4)
        }
    }
    
    private func bindStyles() {
        cityNameText.font = NSFont.systemFont(ofSize: 9)
        qualityText.font = NSFont.systemFont(ofSize: 24)
        qualityDescriptionText.font = NSFont.systemFont(ofSize: 12)
    }
    
    private func bindViewModel() {
        viewModel.outputs.backgroundColor.subscribe(onNext: { [unowned self] (color) in
            self.view.layer?.backgroundColor = color
        }).disposed(by: disposeBag)
        
        viewModel.outputs.cityName.bind(to: cityNameText.rx.text).disposed(by: disposeBag)
        
        viewModel.outputs.qualityValue.bind(to: qualityText.rx.text).disposed(by: disposeBag)
        
        viewModel.outputs.qualityDescription.bind(to: qualityDescriptionText.rx.text).disposed(by: disposeBag)
    }
    
    func configureWith(aqi: AQI) {
        viewModel.inputs.aqiObserver.onNext(aqi)
    }
}
