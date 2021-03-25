//
//  DisplayDetailViewModel.swift
//  MinpakuMock
//
//  Created by hiratti on 2019/03/12.
//  Copyright © 2019 hiratti. All rights reserved.
//

import RealmSwift
import UIKit

class DisplayDetailViewModel: NSObject {
    var mokurokus: [Mokuroku]!
    var currentMokurokuIndex: Int!
    var mokurokuIndex: Int!
    var mokuroku: Mokuroku!
    var thumbImageArray: [String]!
    var detailArray: [DisplayDetail]!
    
    override init() {
        super.init()
    }
    
    func details() -> [DisplayDetail] {
        if detailArray != nil {
            return detailArray
        }
        
        detailArray = DisplayDetail.details(mokuroku: mokuroku)
        return detailArray
    }
    
    func thumbImages() -> [String] {
        if thumbImageArray != nil {
            return thumbImageArray
        }
        thumbImageArray = []
        // shelfでvideoを取り出す
        do {
            let realm = try Realm()
            let predicate = NSPredicate(format: "shelf == %@ OR shelf == %@", mokuroku.imfShelf ?? "", mokuroku.shelf)
            let records = realm.objects(Video.self).filter(predicate)
            
            for record in records {
                thumbImageArray.append(String(format: "J_%03d.mp4", Int(record.videoID) ?? 0))
            }
            
        } catch {
            print("error:\(error)")
        }
        thumbImageArray.append(contentsOf: mokuroku.images())
        
        return thumbImageArray
    }
    
    func isFavorite() -> Bool {
        do {
            let realm = try Realm()
            let predicate = NSPredicate(format: "objectID == %@", mokuroku.objectID)
            let records = realm.objects(Favorite.self).filter(predicate)
            
            return !records.isEmpty
        } catch {
            print("error:\(error)")
        }
        return false
    }
    
    func changeFavorite() {
        Favorite.changeFavorite(moku: mokuroku)
    }
    
    func changeMokuroku(cnt: Int) -> Int {
        let mokurokuCnt = mokurokus.count
        mokurokuIndex += cnt
        
        if mokurokuIndex < 0 {
            mokurokuIndex = mokurokuCnt - 1
        } else if mokurokuCnt - 1 < mokurokuIndex {
            mokurokuIndex = 0
        }
        
        return mokurokuIndex
    }
}
