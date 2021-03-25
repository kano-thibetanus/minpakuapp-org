import RealmSwift

@objcMembers
class Photo: Object {
    // realm keys
    dynamic var objectID: String?
    dynamic var image: Data = Data()
    
    class func saveImage(mokuroku: Mokuroku?, uiImage: UIImage) -> Data? {
        // PhotoModel
        do {
            let realm = try Realm()
            let photo = Photo()
            if let safeMokuroku = mokuroku {
                photo.objectID = safeMokuroku.objectID
            }
            
            // 画像圧縮
            var percentage = CGFloat(0.5)
            var resizedImage: UIImage?
            repeat {
                resizedImage = uiImage.resized(withPercentage: percentage)
                percentage -= 0.1
                
            } while resizedImage?.pngData()?.count ?? 0 > 16_000_000
            
            if let safeImage = resizedImage {
                photo.image = safeImage.pngData() ?? Data()
            }
            
            try realm.write {
                realm.add(photo)
            }
            
            // Favoriteへのヒモ付
            if let safeMokuroku = mokuroku {
                if let favorite = realm.objects(Favorite.self).filter(NSPredicate(format: "objectID == %@", safeMokuroku.objectID)).first {
                    try realm.write {
                        favorite.photo = photo
                    }
                } else {
                    // お気に入り強制追加
                    let favorite = Favorite()
                    favorite.photo = photo
                    favorite.objectID = safeMokuroku.objectID
                    favorite.mokuroku = safeMokuroku
                    try realm.write {
                        realm.add(favorite)
                    }
                }
            }
            
            if let safeImage = resizedImage {
                return safeImage.pngData()
            }
        } catch {
            print("error:\(error)")
        }
        
        return uiImage.pngData()
    }
}
