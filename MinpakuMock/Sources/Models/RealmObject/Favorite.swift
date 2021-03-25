import RealmSwift

@objcMembers
class Favorite: Object {
    // realm keys
    dynamic var objectID: String = ""
    dynamic var mokuroku: Mokuroku?
    dynamic var photo: Photo?
    dynamic var note: Note?
    
    class func changeFavorite(moku: Mokuroku) {
        do {
            let realm = try Realm()
            let predicate = NSPredicate(format: "objectID == %@", moku.objectID)
            let records = realm.objects(Favorite.self).filter(predicate)
            
            if !records.isEmpty {
                // NoteかPhotoが紐付いている場合解除不可
                if let record = records.first, record.photo == nil, record.note == nil {
                    // delete
                    try realm.write {
                        realm.delete(records)
                    }
                    
                    // MARK: Log
                    
                    ActivityLogManager.registerActiveLog(event: .favoriteCancel, itemID: moku.objectID, predicate: nil, image: nil)
                }
            } else {
                // add
                let favorite = Favorite()
                favorite.objectID = moku.objectID
                favorite.mokuroku = moku
                
                // FavoriteにPhotoを紐付ける
                if let photo = realm.objects(Photo.self).filter(NSPredicate(format: "objectID == %@", moku.objectID)).first {
                    favorite.photo = photo
                }
                
                // FavoriteにNoteを紐付ける
                if let note = realm.objects(Note.self).filter(NSPredicate(format: "objectID == %@", moku.objectID)).first {
                    favorite.note = note
                }
                
                try realm.write {
                    realm.add(favorite)
                }
                
                // MARK: Log
                
                ActivityLogManager.registerActiveLog(event: .favoriteRegister, itemID: moku.objectID, predicate: nil, image: nil)
            }
        } catch {
            print("error:\(error)")
        }
    }
}
