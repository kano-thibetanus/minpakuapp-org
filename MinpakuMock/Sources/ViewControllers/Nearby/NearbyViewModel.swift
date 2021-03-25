//
//  NearbyViewModel.swift
//  MinpakuMock
//
//  Created by hiratti on 2019/03/18.
//  Copyright © 2019 hiratti. All rights reserved.
//

import RealmSwift
import UIKit

class NearbyViewModel: NSObject {
    var records: Results<Mokuroku>!
    override init() {
        super.init()
        
        do {
            let realm = try Realm()
            let predicate = queryString()
            records = realm.objects(Mokuroku.self).filter(predicate).sorted(byKeyPath: "imageCount", ascending: false)
            print("result: \(records.count)")
        } catch {
            print("error:\(error)")
        }
    }
    
    func queryString() -> NSPredicate {
        var queryString = ""
        let beacons = BeaconManager.sharedInstance.nearBeacons()
        let sep = " OR "
        
        for beacon in beacons {
            for shelf in beacon.shelf {
                queryString += String(format: "shelf CONTAINS \"%@\"", shelf) + sep
            }
        }
        
        if queryString.count > sep.count {
            // 末尾を削除
            queryString = String(queryString.prefix(queryString.count - sep.count))
        }
        
        if queryString == "" {
            queryString = "FALSEPREDICATE"
        }
        
        print(queryString)
        
        return NSPredicate(format: queryString)
    }
}
