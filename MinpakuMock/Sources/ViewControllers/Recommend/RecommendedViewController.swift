//
//  RecommendedViewController.swift
//  MinpakuMock
//
//  Created by 平林陽一 on 2019/02/19.
//  Copyright © 2019 hiratti. All rights reserved.
//

import UIKit

class RecommendedViewController: UIViewController {
    var viewModel: RecommendedViewModel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var header: GeneralHeader!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        // viewModel
        viewModel = RecommendedViewModel()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // collectionView
        collectionView.delegate = self
        collectionView.dataSource = self
        let itemName = String(describing: ItemCollectionViewCell.self)
        collectionView.register(UINib(nibName: itemName, bundle: nil), forCellWithReuseIdentifier: itemName)
        
        // btn
        header.menuBtn.addTarget(self, action: #selector(pressMenuBtn(_:)), for: .touchUpInside)
        header.backBtnHidden()
        
        // title
        header.titleLbl.text = "おすすめの展示物"
    }
    
    @objc func pressMenuBtn(_ sender: UIButton) {
        if let viewController: MenuNavigationController = MenuNavigationController.viewControllerFromStoryboard() {
            present(viewController, animated: true, completion: nil)
        }
    }
}

extension RecommendedViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.records.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: ItemCollectionViewCell.self),
                                                         for: indexPath) as? ItemCollectionViewCell {
            cell.mokuroku = viewModel.records[indexPath.item]
            cell.fill()
            
            return cell
        }
        return ItemCollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // tap action
        if let viewController: DisplayDetailViewController = DisplayDetailViewController.viewControllerFromStoryboard() {
            viewController.viewModel.mokuroku = viewModel.records[indexPath.item]
            viewController.viewModel.mokurokus = viewModel.records.map { $0 }
            viewController.viewModel.mokurokuIndex = indexPath.row
            viewController.viewModel.currentMokurokuIndex = indexPath.row
            
            navigationController?.pushViewController(viewController, animated: true)
        }
    }
}

extension RecommendedViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let bounds = self.collectionView.bounds
        let width = (bounds.width / 5) - 10
        return CGSize(width: width, height: width)
    }
}
