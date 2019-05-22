//
//  MainViewController.swift
//  AQI macOS
//
//  Created by Fernando Mata on 4/23/19.
//  Copyright © 2019 Fernando Mata. All rights reserved.
//

import Cocoa
import RxSwift

class MainViewController: NSViewController {

    @IBOutlet weak var collectionView: NSCollectionView!
    @IBOutlet weak var noCitiesText: NSTextField!
    
    private let viewModel: MainViewModelType = MainViewModel()
    
    private var disposeBag: DisposeBag = DisposeBag()
    
    fileprivate var aqis: [AQI] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        
        initSteps()
        configureCollectionView()
    }
    
    private func initSteps() {
        createUI()
        bindStyles()
        bindViewModel()
    }
    
    private func createUI() {
        
    }
    
    private func bindStyles() {
        
    }
    
    private func bindViewModel() {
        viewModel.outputs.aqis.subscribe(onNext: { [weak self] (aqis) in
            guard let `self` = self else { return }
            
            guard self.aqis.count > 0 else {
                self.aqis = aqis
                self.collectionView.reloadData()
                return
            }
            
            let updates = Array.diffArraysOrdered(lhs: self.aqis, rhs: aqis)
            
            let removedIndexes = updates.removed.compactMap({ self.aqis.firstIndex(of: $0) }).map({ IndexPath(item: $0, section: 0) })
            let addedIndexes = updates.added.compactMap({ aqis.firstIndex(of: $0) }).map({ IndexPath(item: $0, section: 0) })
            self.aqis = aqis
            
            self.collectionView.performBatchUpdates({
                self.collectionView.animator().deleteItems(at: Set(removedIndexes))
                self.collectionView.animator().insertItems(at: Set(addedIndexes))
            }, completionHandler: nil)
        }).disposed(by: disposeBag)
        
        viewModel.outputs.hideNoCitiesLabel.bind(to: noCitiesText.rx.isHidden).disposed(by: disposeBag)
    }
    
    private func configureCollectionView() {
        let layout = NSCollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 150, height: 150)
        layout.minimumInteritemSpacing = 25
        layout.sectionInset = NSEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        collectionView.collectionViewLayout = layout
        collectionView.register(AQICell.self, forItemWithIdentifier: .aqiCell)
    }
}

extension MainViewController: NSCollectionViewDelegate, NSCollectionViewDataSource {
    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        return aqis.count
    }
    
    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        let cell = collectionView.makeItem(withIdentifier: .aqiCell, for: indexPath) as! AQICell
        cell.configureWith(aqi: aqis[indexPath.item])
        cell.rx.deleteAQI.bind(to: viewModel.inputs.deleteAQIObserver).disposed(by: cell.disposeBag)
        
        return cell
    }
}
