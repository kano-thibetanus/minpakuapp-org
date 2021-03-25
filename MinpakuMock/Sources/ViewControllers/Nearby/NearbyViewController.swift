//
//  NearbyViewController.swift
//  MinpakuMock
//
//  Created by hiratti on 2019/02/27.
//  Copyright © 2019 hiratti. All rights reserved.
//

import UIKit

class NearbyViewController: UIViewController {
    var viewModel: NearbyViewModel!
    @IBOutlet weak var header: GeneralHeader!
    @IBOutlet weak var collectionView: UICollectionView!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        // viewModel
        viewModel = NearbyViewModel()
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
        header.backBtn.addTarget(self, action: #selector(pressBackBtn(_:)), for: .touchUpInside)
        
        // title
        header.titleLbl.text = "近くの展示"
    }
    
    @objc func pressMenuBtn(_ sender: UIButton) {
        if let viewController: MenuNavigationController = MenuNavigationController.viewControllerFromStoryboard() {
            present(viewController, animated: true, completion: nil)
        }
    }
    
    @objc func pressBackBtn(_ sender: UIButton) {
        dismiss(animated: true)
    }
}

extension NearbyViewController: UICollectionViewDelegate, UICollectionViewDataSource {
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

extension NearbyViewController: UICollectionViewDelegateFlowLayout {
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
