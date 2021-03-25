//
//  SearchResultViewModel.swift
//  MinpakuMock
//
//  Created by hiratti on 2019/03/18.
//  Copyright © 2019 hiratti. All rights reserved.
//

import RealmSwift
import UIKit

class SearchResultViewModel: NSObject {
    var records: Results<Mokuroku>!
    var searchKeys: [String]!
    var searchWords: [String]!
    
    override init() {
        super.init()
    }
    
    func search(query: NSPredicate?) {
        if let safeQuery = query {
            do {
                let realm = try Realm()
                records = realm.objects(Mokuroku.self).filter(safeQuery).sorted(byKeyPath: "imageCount", ascending: false)
                print("query: \(safeQuery)")
                print("result: \(records.count)")
            } catch {
                print("error:\(error)")
            }
        }
    }
    
    func search(querys: [NSPredicate]) {
        do {
            let realm = try Realm()
            records = realm.objects(Mokuroku.self)
            for query in querys {
                records = records.filter(query)
                print("query: \(query)")
            }
            records = records.sorted(byKeyPath: "imageCount", ascending: false)
            print("result: \(records.count)")
        } catch {
            print("error:\(error)")
        }
    }
}
