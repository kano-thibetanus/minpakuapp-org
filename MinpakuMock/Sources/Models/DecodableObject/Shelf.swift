import Foundation
import RealmSwift

@objcMembers
class Shelf: Object, Decodable {
    // 580    1093.61    0.5303535995
    // 600    1128.89    0.5314955399
    let XCoefficient: Float = 0.53
    let YCoefficient: Float = 0.531
    // realm keys
    dynamic var shelf: String = ""
    dynamic var mmX: Int = 0
    dynamic var mmY: Int = 0
    dynamic var category: String = ""
    
    enum CodingKeys: String, CodingKey {
        case shelf
        case mmX = "mm_x"
        case mmY = "mm_y"
        case category
    }
    
    public required convenience init(from decoder: Decoder) throws {
        self.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        shelf = try container.decode(String.self, forKey: .shelf)
        mmX = try container.decode(Int.self, forKey: .mmX)
        mmY = try container.decode(Int.self, forKey: .mmY)
        category = try String(describing: container.decode(Int.self, forKey: .category))
    }
    
    func x() -> Int {
        return Int(Float(mmX) * XCoefficient)
    }
    
    func y() -> Int {
        return Int(Float(mmY) * YCoefficient)
    }
    
    static func whereShelf(shelf: String) -> Shelf? {
        do {
            let realm = try Realm()
            let shelf = realm.objects(Shelf.self).filter(NSPredicate(format: "shelf == %@", shelf)).first
            return shelf
        } catch {
            print("error:\(error)")
        }
        
        return nil
    }
}
