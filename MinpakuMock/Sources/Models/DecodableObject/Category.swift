import Foundation
import RealmSwift

@objcMembers
class CategoryBig: Object, Decodable {
    // realm keys
    dynamic var categoryBigID: String = ""
    dynamic var name: String = ""
    
    enum CodingKeys: String, CodingKey {
        case categoryBigID = "category_big_id"
        case name = "category_big_name"
    }
    
    public required convenience init(from decoder: Decoder) throws {
        self.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        categoryBigID = try String(describing: container.decode(Int.self, forKey: .categoryBigID))
        name = try container.decode(String.self, forKey: .name)
    }
}

@objcMembers
class CategoryMiddle: Object, Decodable {
    // realm keys
    dynamic var categoryMiddleID: String = ""
    dynamic var name: String = ""
    dynamic var categoryBigID: String = ""
    
    enum CodingKeys: String, CodingKey {
        case categoryMiddleID = "category_middle_id"
        case name = "category_middle_name"
        case categoryBigID = "category_big_id"
    }
    
    public required convenience init(from decoder: Decoder) throws {
        self.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        categoryMiddleID = try String(describing: container.decode(Int.self, forKey: .categoryMiddleID))
        name = try container.decode(String.self, forKey: .name)
        categoryBigID = try String(describing: container.decode(Int.self, forKey: .categoryBigID))
    }
}

@objcMembers
class CategorySmall: Object, Decodable {
    // realm keys
    dynamic var categorySmallID: String = ""
    dynamic var name: String = ""
    dynamic var categoryMiddleID: String = ""
    
    enum CodingKeys: String, CodingKey {
        case categorySmallID = "category_small_id"
        case name = "category_small_name"
        case categoryMiddleID = "category_middle_id"
    }
    
    public required convenience init(from decoder: Decoder) throws {
        self.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        categorySmallID = try String(describing: container.decode(Int.self, forKey: .categorySmallID))
        name = try container.decode(String.self, forKey: .name)
        categoryMiddleID = try String(describing: container.decode(Int.self, forKey: .categoryMiddleID))
    }
}
