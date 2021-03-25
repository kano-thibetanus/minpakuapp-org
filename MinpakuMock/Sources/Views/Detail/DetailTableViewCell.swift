//
//  DetailTableViewCell.swift
//  MinpakuMock
//
//  Created by hiratti on 2019/03/06.
//  Copyright © 2019 hiratti. All rights reserved.
//

import UIKit

class DetailTableViewCell: UITableViewCell {
    var detail: DisplayDetail!
    var viewController: DisplayDetailViewController!
    
    @IBOutlet weak var keyLbl: UILabel!
    @IBOutlet weak var valueLbl: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionViewHeightConstraint: NSLayoutConstraint!
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(false, animated: false)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // hashTagCollectionView
        collectionView.delegate = self
        collectionView.dataSource = self
        let itemName = String(describing: DetailTableViewInCollectionViewCell.self)
        collectionView.register(UINib(nibName: itemName, bundle: nil), forCellWithReuseIdentifier: itemName)
    }
    
    func refresh() {
        collectionView.reloadData()
        keyLbl.text = detail.key
        if let safeTexts = detail.text {
            if detail.predicate == nil {
                valueLbl.text = safeTexts[0]
            } else {
                valueLbl.text = ""
            }
        } else {
            valueLbl.text = ""
        }
        
        if detail.predicate != nil {
            // 高さ調節
            collectionViewHeightConstraint.constant = collectionView.collectionViewLayout.collectionViewContentSize.height
            
        } else {
            // テキストカラー
            valueLbl.textColor = UIColor.white
            
            // 高さ調節
            collectionViewHeightConstraint.constant = 0
        }
    }
}

extension DetailTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if detail.predicate != nil {
            if let safeTexts = detail.text {
                return safeTexts.count
            }
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: DetailTableViewInCollectionViewCell.self),
                                                         for: indexPath) as? DetailTableViewInCollectionViewCell {
            if let safeTexts = detail.text {
                cell.linkLbl.text = safeTexts[indexPath.item]
            }
            
            return cell
        }
        return DetailTableViewInCollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let safePredicates = detail.predicate, let safeTexts = detail.text {
            if let srViewController: SearchResultViewController = SearchResultViewController.viewControllerFromStoryboard() {
                srViewController.viewModel.search(query: safePredicates[indexPath.item])
                srViewController.viewModel.searchKeys = [detail.key]
                srViewController.viewModel.searchWords = [safeTexts[indexPath.item]]
                
                viewController.navigationController?.pushViewController(srViewController, animated: true)
                
                // ページ送りをリセット
                viewController.viewModel.mokuroku = viewController.viewModel.mokurokus[viewController.viewModel.currentMokurokuIndex]
                viewController.reloadView()
            }
        }
    }
}

extension DetailTableViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        var width = CGFloat(0)
        if let safeTexts = detail.text {
            width = UILabel.textWidth(font: UIFont.boldSystemFont(ofSize: 22), text: safeTexts[indexPath.item])
        }
        
        return CGSize(width: width + 8, height: 32)
    }
}
