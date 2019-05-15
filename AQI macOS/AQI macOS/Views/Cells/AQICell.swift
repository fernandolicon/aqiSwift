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
    
    fileprivate let viewModel: AQICellModelType = AQICellModel()
    
    private var internalDisposeBag: DisposeBag = DisposeBag()
    private var reusableDisposeBag: DisposeBag = DisposeBag()
    var disposeBag: DisposeBag {
        return reusableDisposeBag
    }
    
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
        
        let newMenu = NSMenu()
        newMenu.insertItem(NSMenuItem(title: NSLocalizedString("Delete", comment: ""), action: #selector(didSelectDelete), keyEquivalent: ""), at: 0)
        self.view.menu = newMenu
    }
    
    private func bindStyles() {
        cityNameText.font = NSFont.systemFont(ofSize: 9)
        qualityText.font = NSFont.systemFont(ofSize: 24)
        qualityDescriptionText.font = NSFont.systemFont(ofSize: 12)
    }
    
    private func bindViewModel() {
        viewModel.outputs.backgroundColor.subscribe(onNext: { [unowned self] (color) in
            self.view.layer?.backgroundColor = color
        }).disposed(by: internalDisposeBag)
        
        viewModel.outputs.cityName.bind(to: cityNameText.rx.text).disposed(by: internalDisposeBag)
        
        viewModel.outputs.qualityValue.bind(to: qualityText.rx.text).disposed(by: internalDisposeBag)
        
        viewModel.outputs.qualityDescription.bind(to: qualityDescriptionText.rx.text).disposed(by: internalDisposeBag)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        reusableDisposeBag = DisposeBag()
    }
    
    func configureWith(aqi: AQI) {
        viewModel.inputs.aqiObserver.onNext(aqi)
    }
    
    @objc func didSelectDelete() {
        viewModel.inputs.deleteObserver.onNext(())
    }
}

extension Reactive where Base: AQICell {
    var deleteAQI: Observable<AQI> {
        return base.viewModel.outputs.deleteAQI
    }
}
