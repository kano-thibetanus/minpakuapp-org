//
//  NoteViewModel.swift
//  MinpakuMock
//
//  Created by hiratti on 2019/03/18.
//  Copyright © 2019 hiratti. All rights reserved.
//

import RealmSwift
import UIKit

class NoteViewModel: NSObject {
    var mokuroku: Mokuroku!
    var isCreate = true
    
    override init() {
        super.init()
    }
    
    func getImage() -> UIImage? {
        // 目録詳細から来た場合ノートが既にあるか確認
        if let safeMokuroku = self.mokuroku {
            // NoteModel
            do {
                let realm = try Realm()
                if let alreadyNoteImage = realm.objects(Note.self).filter(NSPredicate(format: "objectID == %@", safeMokuroku.objectID)).first?.image {
                    return UIImage(data: alreadyNoteImage)
                }
            } catch {
                print("error:\(error)")
            }
        }
        
        return nil
    }
    
    func saveImage(image: UIImage, isCreate: Bool) {
        let imageData = Note.saveImage(mokuroku: mokuroku, uiImage: image)
        
        // MARK: Log
        
        if isCreate {
            ActivityLogManager.registerActiveLog(event: .memoCreate, itemID: nil, predicate: nil, image: imageData)
        } else {
            ActivityLogManager.registerActiveLog(event: .memoEdit, itemID: nil, predicate: nil, image: imageData)
        }
    }
}
