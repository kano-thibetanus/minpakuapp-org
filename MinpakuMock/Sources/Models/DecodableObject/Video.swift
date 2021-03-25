import RealmSwift

@objcMembers
class Video: Object, Decodable {
    // realm keys
    dynamic var videoID: String = ""
    dynamic var shelf: String?
    dynamic var title: String?
    dynamic var time: String?
    dynamic var category: String = ""
    
    enum CodingKeys: String, CodingKey {
        case videoID = "video_id"
        case shelf
        case title
        case time
        case category
    }
    
    public required convenience init(from decoder: Decoder) throws {
        self.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        videoID = try String(describing: container.decode(Int.self, forKey: .videoID))
        shelf = try container.decodeIfPresent(String.self, forKey: .shelf)
        title = try container.decodeIfPresent(String.self, forKey: .title)
        time = try container.decodeIfPresent(String.self, forKey: .time)
        category = String(describing: try container.decode(Int.self, forKey: .category))
    }
}
