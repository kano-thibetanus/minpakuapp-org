//
//  SearchHeader.swift
//  MinpakuMock
//
//  Created by hiratti on 2019/04/24.
//  Copyright © 2019 hiratti. All rights reserved.
//

import UIKit

class SearchHeader: UIView {
    var viewModel: SearchResultViewModel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    // from code
    override init(frame: CGRect) {
        super.init(frame: frame)
        nibInit()
    }
    
    // srom Storyboard
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        nibInit()
    }
    
    fileprivate func nibInit() {
        guard let view = UINib(nibName: "SearchHeader", bundle: nil).instantiate(withOwner: self, options: nil).first as? UIView else {
            return
        }
        
        view.frame = bounds
        
        view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
        addSubview(view)
        
        // collectionView
        collectionView.delegate = self
        collectionView.dataSource = self
        let itemName = String(describing: SearchHeaderCollectionViewCell.self)
        collectionView.register(UINib(nibName: itemName, bundle: nil), forCellWithReuseIdentifier: itemName)
    }
    
    func coronRemovalString(str: String) -> String {
        var ret = str
        if let range = ret.range(of: "：") {
            ret.replaceSubrange(range, with: "")
        }
        
        return ret
    }
}

extension SearchHeader: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.searchWords.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: SearchHeaderCollectionViewCell.self),
                                                         for: indexPath) as? SearchHeaderCollectionViewCell {
            if viewModel.searchKeys != nil, viewModel.searchWords != nil {
                cell.searchKeyLbl.text = coronRemovalString(str: viewModel.searchKeys[indexPath.item])
                cell.searchWordLbl.text = viewModel.searchWords[indexPath.item]
            }
            
            return cell
        }
        return SearchHeaderCollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {}
}

extension SearchHeader: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let bounds = self.collectionView.bounds
        let width = (bounds.width / 2) - 10
        let height = bounds.height - 5
        return CGSize(width: width, height: height)
    }
}
