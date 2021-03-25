import Foundation
import RealmSwift

@objcMembers
class OCM: Object, Decodable {
    // realm keys
    dynamic var code: String = ""
    dynamic var enName: String = ""
    dynamic var jaName: String?
    
    enum CodingKeys: String, CodingKey {
        case code
        case enName = "en_name"
        case jaName = "ja_name"
    }
    
    public required convenience init(from decoder: Decoder) throws {
        self.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        code = try String(describing: container.decode(Int.self, forKey: .code))
        enName = try container.decode(String.self, forKey: .enName)
        jaName = try container.decodeIfPresent(String.self, forKey: .jaName)
    }
    
    static func ocmString(ocmCode: String) -> String? {
        do {
            let realm = try Realm()
            if let ocmObj = realm.objects(OCM.self).filter(NSPredicate(format: "code == %@", ocmCode)).first {
                if let jaName = ocmObj.jaName {
                    return jaName
                } else {
                    return ocmObj.enName
                }
            }
        } catch {
            print("error:\(error)")
        }
        
        return nil
    }
    
    static func ocmCode(ocmString: String) -> String? {
        do {
            let realm = try Realm()
            if let ocmObj = realm.objects(OCM.self).filter(NSPredicate(format: "jaName == %@", ocmString)).first {
                return ocmObj.code
            }
        } catch {
            print("error:\(error)")
        }
        
        return nil
    }
}
