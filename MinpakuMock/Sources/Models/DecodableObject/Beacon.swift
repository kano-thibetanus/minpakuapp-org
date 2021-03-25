import Foundation
import RealmSwift

@objcMembers
class Beacon: Object, Decodable {
    // 580    1093.61    0.5303535995
    // 600    1128.89    0.5314955399
    let XCoefficient: Float = 0.53
    let YCoefficient: Float = 0.531
    // realm keys
    var shelf = List<String>()
    dynamic var beaconID: String = ""
    dynamic var mmX: Int = 0
    dynamic var mmY: Int = 0
    dynamic var major: String = ""
    dynamic var minor: String = ""
    dynamic var uuid: String = ""
    dynamic var shelfString: String = ""
    
    enum CodingKeys: String, CodingKey {
        case beaconID = "beacon_id"
        case mmX = "x"
        case mmY = "y"
        case major
        case minor
        case uuid
        case shelf
        case shelfString = "shelf_string"
    }
    
    public required convenience init(from decoder: Decoder) throws {
        self.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        shelf = try container.decodeIfPresent([String].self, forKey: .shelf)?.reduce(List<String>()) { $0.append($1); return $0 } ?? List<String>()
        
        beaconID = try container.decode(String.self, forKey: .beaconID)
        mmX = try container.decode(Int.self, forKey: .mmX)
        mmY = try container.decode(Int.self, forKey: .mmY)
        major = String(describing: try container.decode(Int.self, forKey: .major))
        minor = String(describing: try container.decode(Int.self, forKey: .minor))
        uuid = try container.decode(String.self, forKey: .uuid)
        shelfString = try container.decode(String.self, forKey: .shelfString)
    }
    
    func x() -> Int {
        return Int(Float(mmX) * XCoefficient)
    }
    
    func y() -> Int {
        return Int(Float(mmY) * YCoefficient)
    }
}
