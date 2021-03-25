import RealmSwift

@objcMembers
class Note: Object {
    // realm keys
    dynamic var objectID: String?
    dynamic var image: Data = Data()
    
    class func saveImage(mokuroku: Mokuroku?, uiImage: UIImage) -> Data? {
        // NoteModel
        do {
            let realm = try Realm()
            // 目録詳細から来た場合ノートが既にあるか確認
            if let safeMokuroku = mokuroku {
                if let alreadyNote = realm.objects(Note.self).filter(NSPredicate(format: "objectID == %@", safeMokuroku.objectID)).first {
                    // あった場合は更新する
                    try realm.write {
                        alreadyNote.image = uiImage.pngData() ?? Data()
                    }
                    return uiImage.pngData()
                } else {
                    // なかった場合は追加
                    let note = Note()
                    note.objectID = safeMokuroku.objectID
                    note.image = uiImage.pngData() ?? Data()
                    try realm.write {
                        realm.add(note)
                    }
                    // Favoriteへのヒモ付
                    if let safeMokuroku = mokuroku {
                        if let favorite = realm.objects(Favorite.self).filter(NSPredicate(format: "objectID == %@", safeMokuroku.objectID)).first {
                            try realm.write {
                                favorite.note = note
                            }
                        } else {
                            // お気に入り強制追加
                            let favorite = Favorite()
                            favorite.note = note
                            favorite.objectID = safeMokuroku.objectID
                            favorite.mokuroku = safeMokuroku
                            try realm.write {
                                realm.add(favorite)
                            }
                        }
                    }
                }
            } else {
                // menuから来た場合はObjectIDなしで追加
                let note = Note()
                note.objectID = nil
                note.image = uiImage.pngData() ?? Data()
                try realm.write {
                    realm.add(note)
                }
            }
        } catch {
            print("error:\(error)")
        }
        return uiImage.pngData()
    }
}
