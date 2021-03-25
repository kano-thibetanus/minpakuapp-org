import Foundation
import RealmSwift

@objcMembers
class Mokuroku: Object, Decodable {
    // realm keys
    var catImages = List<StrObj>()
    dynamic var imageCount: Int = 0
    var hashTags = List<StrObj>()
    dynamic var hashTagsCount: Int = 0
    var ocm = List<StrObj>()
    dynamic var ocmCount: Int = 0
    var owc = List<StrObj>()
    dynamic var owcCount: Int = 0
    
    dynamic var catTitle: String = ""
    dynamic var category: String = ""
    dynamic var categoryMiddle: String = ""
    dynamic var categoryBig: String = ""
    dynamic var categoryBigName: String = ""
    dynamic var fulMiscelDescription: String?
    dynamic var fulProductDescription: String?
    dynamic var fulTitle: String?
    dynamic var fulUseDescription: String?
    dynamic var hashTagString: String = ""
    dynamic var objectID: String = ""
    dynamic var ocmString: String = ""
    dynamic var owcString: String = ""
    dynamic var place: String = ""
    dynamic var shelf: String = ""
    dynamic var socialGroup: String = ""
    dynamic var imfTitle: String?
    dynamic var nation: String?
    dynamic var section: String?
    dynamic var imfDescription: String?
    dynamic var imfImage: String?
    dynamic var imfShelf: String?
    
    enum SearchKey: String {
        case hashTag = "ハッシュタグ"
        case nation = "地域"
        case people = "民族"
        case owc = "OWC"
        case ocm = "OCM"
        case place = "展示場所"
        case keyWord = "キーワード"
        case title = "タイトル"
        case category = "カテゴリ"
    }
    
    enum CodingKeys: String, CodingKey {
        case catImages = "cat_images"
        case imageCount
        case hashTags = "hash_tags"
        case hashTagsCount
        case ocm
        case ocmCount
        case owc
        case owcCount
        case catTitle = "cat_title"
        case category
        case categoryMiddle = "category_middle"
        case categoryBig = "category_big"
        case categoryBigName = "category_big_name"
        case fulMiscelDescription = "ful_miscel_description"
        case fulProductDescription = "ful_product_description"
        case fulTitle = "ful_title"
        case fulUseDescription = "ful_use_description"
        case hashTagString = "hash_tag_string"
        case objectID = "object_id"
        case ocmString = "ocm_string"
        case owcString = "owc_string"
        case place
        case shelf
        case socialGroup = "social_group"
        case imfTitle = "imf_title"
        case nation
        case section
        case imfDescription = "imf_description"
        case imfImage = "imf_image"
        case imfShelf = "imf_shelf"
    }
    
    public required convenience init(from decoder: Decoder) throws {
        self.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let catImagesArray = try container.decodeIfPresent([String].self, forKey: .catImages)
        catImages = catImagesArray?.reduce(List<StrObj>()) { let obj = StrObj(); obj.str = $1; $0.append(obj); return $0 } ?? List<StrObj>()
        
        imageCount = catImages.count
        
        let hashTagsArray = try container.decodeIfPresent([String].self, forKey: .hashTags)
        hashTags = hashTagsArray?.reduce(List<StrObj>()) { let obj = StrObj(); obj.str = $1; $0.append(obj); return $0 } ?? List<StrObj>()
        
        hashTagsCount = hashTags.count
        
        let ocmArray = try container.decodeIfPresent([String].self, forKey: .ocm)
        ocm = ocmArray?.reduce(List<StrObj>()) { let obj = StrObj(); obj.str = $1; $0.append(obj); return $0 } ?? List<StrObj>()
        
        ocmCount = ocm.count
        
        let owcArray = try container.decodeIfPresent([String].self, forKey: .owc)
        owc = owcArray?.reduce(List<StrObj>()) { let obj = StrObj(); obj.str = $1; $0.append(obj); return $0 } ?? List<StrObj>()
        
        owcCount = owc.count
        
        catTitle = try container.decode(String.self, forKey: .catTitle)
        category = String(describing: try container.decode(Int.self, forKey: .category))
        categoryMiddle = String(describing: try container.decode(Int.self, forKey: .categoryMiddle))
        categoryBig = String(describing: try container.decode(Int.self, forKey: .categoryBig))
        categoryBigName = try container.decode(String.self, forKey: .categoryBigName)
        fulMiscelDescription = try container.decodeIfPresent(String.self, forKey: .fulMiscelDescription)
        fulProductDescription = try container.decodeIfPresent(String.self, forKey: .fulProductDescription)
        fulTitle = try container.decodeIfPresent(String.self, forKey: .fulTitle)
        fulUseDescription = try container.decodeIfPresent(String.self, forKey: .fulUseDescription)
        objectID = try container.decode(String.self, forKey: .objectID)
        hashTagString = try container.decode(String.self, forKey: .hashTagString)
        ocmString = try container.decode(String.self, forKey: .ocmString)
        owcString = try container.decode(String.self, forKey: .owcString)
        place = try container.decode(String.self, forKey: .place)
        shelf = try container.decode(String.self, forKey: .shelf)
        socialGroup = try container.decode(String.self, forKey: .socialGroup)
        imfTitle = try container.decodeIfPresent(String.self, forKey: .imfTitle)
        nation = try container.decodeIfPresent(String.self, forKey: .nation)
        section = try container.decodeIfPresent(String.self, forKey: .section)
        imfDescription = try container.decodeIfPresent(String.self, forKey: .imfDescription)
        imfImage = try container.decodeIfPresent(String.self, forKey: .imfImage)
        imfShelf = try container.decodeIfPresent(String.self, forKey: .imfShelf)
        
        if imfImage != nil {
            imageCount += 1
        }
    }
    
    func mainImageName() -> String? {
        // 画像名だけ取り出す
        // imfImage優先
        if let imageName = NSURL(string: self.images().first ?? "")?.lastPathComponent {
            return imageName
        }
        return nil
    }
    
    func images() -> [String] {
        // 画像名だけ取り出す
        var images = [String]()
        if let imfImage = self.imfImage {
            images.append(imfImage)
        }
        
        for imageURL in orderCatImages() {
            if let imageName = NSURL(string: imageURL)?.lastPathComponent {
                images.append(imageName)
            }
        }
        
        return images
    }
    
    func orderCatImages() -> [String] {
        // 画像名にPCDが含まれるのものの優先順位を変更する
        var images = [String]()
        var pcdImages = [String]()
        for image in catImages {
            if image.str.contains("PCD") {
                pcdImages.append(image.str)
            } else {
                images.append(image.str)
            }
        }
        
        images.append(contentsOf: pcdImages)
        return images
    }
    
    func hashTagQueryString(index: Int) -> NSPredicate {
        let hashTag = hashTags[index]
        return NSPredicate(format: "hashTagString CONTAINS %@", hashTag.str)
    }
}

@objcMembers
class StrObj: Object {
    dynamic var str: String = ""
}
