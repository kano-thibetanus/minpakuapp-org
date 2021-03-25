//
//  ItemCollectionViewCell.swift
//  minpaku
//
//  Created by Cuong Tran on 2019/02/04.
//  Copyright © 2019 Paxcreation. All rights reserved.
//

import UIKit

class ItemCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var fullImageView: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    var mokuroku: Mokuroku?
    
    public func fill() {
        if let imageName = self.mokuroku?.mainImageName() {
            fullImageView.image = UIImage(named: imageName)
            fullImageView.isHidden = false
            titleLbl.text = ""
            
        } else {
            fullImageView.isHidden = true
            titleLbl.text = mokuroku?.catTitle
        }
    }
}
