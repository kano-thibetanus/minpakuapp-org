//
//  MypageCollectionViewCell.swift
//  MinpakuMock
//
//  Created by hiratti on 2019/03/15.
//  Copyright © 2019 hiratti. All rights reserved.
//

import UIKit

typealias CellBtnAction = (_ any: Any?) -> Void

class MyPageCollectionViewCell: UICollectionViewCell {
    var record: Any!
    var cameraBtnAction: CellBtnAction!
    var memoBtnAction: CellBtnAction!
    
    @IBOutlet weak var cameraBtn: UIButton!
    @IBOutlet weak var memoBtn: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        // btn
        cameraBtn.addTarget(self, action: #selector(pressCameraBtn(_:)), for: .touchUpInside)
        memoBtn.addTarget(self, action: #selector(pressMemoBtn(_:)), for: .touchUpInside)
    }
    
    func fill() {
        cameraBtn.isHidden = true
        memoBtn.isHidden = true
        
        if let rec = self.record {
            if type(of: rec) == Favorite.self {
                if let favorite = rec as? Favorite {
                    imageView.image = UIImage(named: favorite.mokuroku?.mainImageName() ?? "")
                    if favorite.photo != nil {
                        cameraBtn.isHidden = false
                    }
                    
                    if favorite.note != nil {
                        memoBtn.isHidden = false
                    }
                }
            } else if type(of: rec) == Photo.self {
                if let photo = rec as? Photo {
                    if let uiImage = UIImage(data: photo.image) {
                        let orientationImage = UIImage(cgImage: uiImage.cgImage!, scale: uiImage.scale, orientation: .left)
                        imageView.image = orientationImage
                    }
                }
            } else if type(of: rec) == Note.self {
                if let note = rec as? Note {
                    imageView.image = UIImage(data: note.image)
                }
            }
        }
    }
    
    @objc func pressCameraBtn(_ sender: UIButton) {
        if let safeAction = self.cameraBtnAction {
            if let rec = self.record {
                if type(of: rec) == Favorite.self {
                    if let favorite = rec as? Favorite {
                        safeAction(favorite.photo)
                    }
                }
            }
        }
    }
    
    @objc func pressMemoBtn(_ sender: UIButton) {
        if let safeAction = self.memoBtnAction {
            if let rec = self.record {
                if type(of: rec) == Favorite.self {
                    if let favorite = rec as? Favorite {
                        safeAction(favorite.note)
                    }
                }
            }
        }
    }
}
