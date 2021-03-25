//
//  CultureMapViewModel.swift
//  MinpakuMock
//
//  Created by hiratti on 2019/03/23.
//  Copyright © 2019 hiratti. All rights reserved.
//

import UIKit

class CultureMapViewModel: NSObject {
    override init() {
        super.init()
    }
    
    func queryString(category: Int) -> NSPredicate {
        return NSPredicate(format: "category BEGINSWITH %@", String(describing: category))
    }
}
