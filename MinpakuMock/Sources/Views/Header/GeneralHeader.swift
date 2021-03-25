//
//  GeneralHeader.swift
//  MinpakuMock
//
//  Created by hiratti on 2019/03/18.
//  Copyright © 2019 hiratti. All rights reserved.
//

import UIKit

class GeneralHeader: UIView {
    @IBOutlet weak var backBtnWidth: NSLayoutConstraint!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var menuBtn: UIButton!
    @IBOutlet weak var titleLbl: UILabel!
    
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
        guard let view = UINib(nibName: "GeneralHeader", bundle: nil).instantiate(withOwner: self, options: nil).first as? UIView else {
            return
        }
        
        view.frame = bounds
        
        view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
        addSubview(view)
    }
    
    func backBtnHidden() {
        backBtn.isHidden = true
        backBtnWidth.constant = 0
    }
}
