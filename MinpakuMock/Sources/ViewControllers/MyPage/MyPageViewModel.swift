//
//  MyPageViewModel.swift
//  MinpakuMock
//
//  Created by hiratti on 2019/03/15.
//  Copyright © 2019 hiratti. All rights reserved.
//

import RealmSwift
import UIKit

class MyPageViewModel: NSObject {
    var favorites: Results<Favorite>!
    var photos: Results<Photo>!
    var notes: Results<Note>!
    
    override init() {
        super.init()
        
        fetch()
    }
    
    func fetch() {
        do {
            let realm = try Realm()
            favorites = realm.objects(Favorite.self)
            photos = realm.objects(Photo.self).filter(NSPredicate(format: "objectID == nil"))
            notes = realm.objects(Note.self).filter(NSPredicate(format: "objectID == nil"))
            
        } catch {
            print("error:\(error)")
        }
    }
    
    func sectionName(section: Int) -> String {
        switch section {
        case 0:
            return "お気に入りの展示"
        case 1:
            return "写真"
        case 2:
            return "メモ"
        default:
            return ""
        }
    }
    
    func numberOfItemsInSection(section: Int) -> Int {
        switch section {
        case 0:
            return favorites.count
        case 1:
            return photos.count
        case 2:
            return notes.count
        default:
            return 0
        }
    }
    
    func recordForIndexPath(indexPath: IndexPath) -> Any {
        switch indexPath.section {
        case 0:
            return favorites[indexPath.item]
        case 1:
            return photos[indexPath.item]
        case 2:
            return notes[indexPath.item]
        default:
            return 0
        }
    }
    
    func sectionBoundsHeight(section: Int) -> CGFloat {
        if numberOfItemsInSection(section: section) == 0 {
            return 0
        }
        
        return 44.0
    }
    
    func sectionNumber() -> Int {
        return 3
    }
}
