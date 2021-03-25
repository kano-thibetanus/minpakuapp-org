//
//  RecommendedViewModel.swift
//  MinpakuMock
//
//  Created by hiratti on 2019/03/11.
//  Copyright © 2019 hiratti. All rights reserved.
//

import RealmSwift
import UIKit

class RecommendedViewModel: NSObject {
    var records: [Mokuroku]!
    override init() {
        super.init()
        
        do {
            let realm = try Realm()
            // イメージファインダーの画像があるものに絞る
            let predicate = NSPredicate(format: "imfImage != nil")
            
            records = realm.objects(Mokuroku.self).filter(predicate).shuffled()
            print("result: \(records.count)")
        } catch {
            print("error:\(error)")
        }
    }
}
