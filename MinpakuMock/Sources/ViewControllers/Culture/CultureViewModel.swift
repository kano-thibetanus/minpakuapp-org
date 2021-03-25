//
//  CultureViewModel.swift
//  MinpakuMock
//
//  Created by hiratti on 2019/03/18.
//  Copyright © 2019 hiratti. All rights reserved.
//

import RealmSwift
import UIKit

class CultureViewModel: NSObject {
    var records: Results<Mokuroku>!
    var cultureString: String!
    
    override init() {
        super.init()
    }
    
    func search(query: NSPredicate?) {
        if let safeQuery = query {
            do {
                let realm = try Realm()
                records = realm.objects(Mokuroku.self).filter(safeQuery).sorted(byKeyPath: "imageCount", ascending: false)
                print("result: \(records.count)")
            } catch {
                print("error:\(error)")
            }
        }
    }
    
    func setTag(tag: Int) {
        do {
            let realm = try Realm()
            let category = realm.objects(CategoryBig.self).filter(NSPredicate(format: "categoryBigID BEGINSWITH %@", String(describing: tag))).first
            cultureString = category?.name
        } catch {
            print("error:\(error)")
        }
    }
}
