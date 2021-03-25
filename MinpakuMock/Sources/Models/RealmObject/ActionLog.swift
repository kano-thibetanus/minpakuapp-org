import RealmSwift

@objcMembers
class ActionLog: Object, Codable {
    enum EventName: String {
        case login
        case logout
        case search
        case detail
        case favoriteRegister = "favorite_register"
        case favoriteCancel = "favorite_cancel"
        case memoCreate = "memo_create"
        case memoEdit = "memo_edit"
        case photoCreate = "photo_create"
        case beaconDetect = "beacon_detect"
        // 20190907 yang add start
        case video
        case tag
        case zoom
        // 20190907 yang add end
    }
    
    enum CodingKeys: String, CodingKey {
        case customerID = "customer_id"
        case event
        case createdAt = "created_at"
        case imageName = "image_name"
        case itemID = "item_id"
        case predicate
        case uuid
        case major
        case minor
    }
    
    // realm keys
    dynamic var customerID: String = ""
    dynamic var event: String = ""
    dynamic var createdAt: Date = Date()
    dynamic var imageName: String?
    dynamic var itemID: String?
    dynamic var predicate: String?
    dynamic var uuid: String?
    dynamic var major: String?
    dynamic var minor: String?
}
