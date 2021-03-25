import Foundation
import RealmSwift

@objcMembers
class OWC: Object, Decodable {
    // realm keys
    dynamic var code: String = ""
    dynamic var enName: String = ""
    dynamic var jaName: String?
    
    enum CodingKeys: String, CodingKey {
        case code
        case enName = "en_name"
        case jaName = "ja_name"
    }
    
    static func owcString(owcCode: String) -> String? {
        do {
            let realm = try Realm()
            if let owcObj = realm.objects(OWC.self).filter(NSPredicate(format: "code == %@", owcCode)).first {
                if let jaName = owcObj.jaName {
                    return jaName
                } else {
                    return owcObj.enName
                }
            }
        } catch {
            print("error:\(error)")
        }
        
        return nil
    }
    
    static func owcCode(owcString: String) -> String? {
        do {
            let realm = try Realm()
            if let owcObj = realm.objects(OWC.self).filter(NSPredicate(format: "jaName == %@", owcString)).first {
                return owcObj.code
            }
        } catch {
            print("error:\(error)")
        }
        
        return nil
    }
}
