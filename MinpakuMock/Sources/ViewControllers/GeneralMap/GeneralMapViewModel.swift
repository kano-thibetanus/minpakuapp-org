//
//  GeneralMapViewModel.swift
//  MinpakuMock
//
//  Created by hiratti on 2019/03/24.
//  Copyright © 2019 hiratti. All rights reserved.
//

import RealmSwift
import UIKit

class GeneralMapViewModel: NSObject {
    override init() {
        super.init()
    }
    
    func nearBeacons() -> [Beacon] {
        return BeaconManager.sharedInstance.nearBeacons()
    }
    
    func allBeacons() -> [Beacon] {
        return BeaconManager.sharedInstance.allBeacons()
    }
    
    func queryString(category: Int) -> NSPredicate {
        return NSPredicate(format: "category BEGINSWITH %@", String(describing: category))
    }
}
