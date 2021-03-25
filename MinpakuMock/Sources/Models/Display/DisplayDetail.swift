//
//  DisplayDetail.swift
//  MinpakuMock
//
//  Created by hiratti on 2019/03/29.
//  Copyright © 2019 hiratti. All rights reserved.
//

import Foundation
import RealmSwift

class DisplayDetail: NSObject {
    var key: String = ""
    var text: [String]?
    var predicate: [NSPredicate]?
    
    init(key: String, text: [String]?, predicate: [NSPredicate]?) {
        self.key = key
        self.text = text
        self.predicate = predicate
    }
    
    static func details(mokuroku: Mokuroku) -> [DisplayDetail] {
        var detailArray = [DisplayDetail]()
        
        detailArray.append(DisplayDetail(key: "標本ID：",
                                         text: [mokuroku.objectID],
                                         predicate: nil))
        detailArray.append(DisplayDetail(key: "地域：",
                                         text: DisplayDetail.regionStrings(mokuroku: mokuroku),
                                         predicate: DisplayDetail.queryStrings(keys: ["place", "nation"],
                                                                               values: [mokuroku.place, mokuroku.nation])))
        detailArray.append(DisplayDetail(key: "民族：",
                                         text: [mokuroku.socialGroup],
                                         predicate: [DisplayDetail.queryString(key: "socialGroup",
                                                                               value: mokuroku.socialGroup)]))
        detailArray.append(DisplayDetail(key: "OWC：",
                                         text: DisplayDetail.owcDetailStrings(mokuroku: mokuroku),
                                         predicate: DisplayDetail.anyQueryStrings(key: "owc",
                                                                                  values: mokuroku.owc)))
        detailArray.append(DisplayDetail(key: "OCM：",
                                         text: DisplayDetail.ocmDetailStrings(mokuroku: mokuroku),
                                         predicate: DisplayDetail.anyQueryStrings(key: "ocm",
                                                                                  values: mokuroku.ocm)))
        detailArray.append(DisplayDetail(key: "説明：",
                                         text: DisplayDetail.descriptionStrings(mokuroku: mokuroku),
                                         predicate: nil))
        detailArray.append(DisplayDetail(key: "展示場所：",
                                         text: DisplayDetail.exhibitionPlaceStrings(mokuroku: mokuroku),
                                         predicate: DisplayDetail.queryStrings(keys: ["category", "section", "shelf"],
                                                                               values: [mokuroku.category, mokuroku.section, mokuroku.shelf])))
        // ないものを削除
        detailArray = detailArray.filter { $0.text != nil && !$0.text!.isEmpty }
        
        return detailArray
    }
    
    static func owcDetailStrings(mokuroku: Mokuroku) -> [String] {
        var strings = [String]()
        
        for owcCode in mokuroku.owc {
            if let owcStr = OWC.owcString(owcCode: owcCode.str) {
                if !owcStr.isEmpty {
                    strings.append(owcCode.str + "(" + owcStr + ")")
                }
            }
        }
        
        return strings
    }
    
    static func ocmDetailStrings(mokuroku: Mokuroku) -> [String] {
        var strings = [String]()
        
        for ocmCode in mokuroku.ocm {
            if let ocmStr = OCM.ocmString(ocmCode: ocmCode.str) {
                if !ocmStr.isEmpty {
                    strings.append(ocmCode.str + "(" + ocmStr + ")")
                }
            }
        }
        
        return strings
    }
    
    static func regionStrings(mokuroku: Mokuroku) -> [String] {
        var strings = [String]()
        
        if !mokuroku.place.isEmpty {
            strings.append(mokuroku.place)
        }
        
        if let safe = mokuroku.nation {
            if !safe.isEmpty {
                strings.append(safe)
            }
        }
        
        return strings
    }
    
    static func exhibitionPlaceStrings(mokuroku: Mokuroku) -> [String] {
        var strings = [String]()
        
        strings.append(mokuroku.categoryBigName)
        
        if let safe = mokuroku.section {
            strings.append(safe)
        }
        
        strings.append(mokuroku.shelf)
        
        return strings
    }
    
    static func descriptionStrings(mokuroku: Mokuroku) -> [String] {
        let sep = ""
        var str = ""
        if let safe = mokuroku.imfDescription {
            str.append(sep + safe)
        }
        
        // 完全一致、もしくは包含関係にあった場合fulUseDescriptionのみ表示
        if mokuroku.fulUseDescription == mokuroku.fulProductDescription {
            if let safe = mokuroku.fulUseDescription {
                str.append(sep + safe)
            }
        } else {
            if mokuroku.fulUseDescription?.lowercased().contains(mokuroku.fulProductDescription ?? "") ?? false ||
                mokuroku.fulProductDescription?.lowercased().contains(mokuroku.fulUseDescription ?? "") ?? false {
                if let safe = mokuroku.fulUseDescription {
                    str.append(sep + safe)
                }
            } else {
                if let safe = mokuroku.fulUseDescription {
                    str.append(sep + safe)
                }
                
                if let safe = mokuroku.fulProductDescription {
                    str.append(sep + safe)
                }
            }
        }
        
        if let safe = mokuroku.fulMiscelDescription {
            str.append(sep + safe)
        }
        
        if let safe = mokuroku.imfTitle {
            str.append(sep + safe)
        }
        
        if str.isEmpty {
            return []
        }
        
        return [str]
    }
    
    static func queryString(key: String, value: String?) -> NSPredicate {
        if let safeValue = value {
            return NSPredicate(format: "%K CONTAINS %@", key, safeValue)
        }
        
        return NSPredicate(format: "FALSEPREDICATE")
    }
    
    static func queryStrings(keys: [String], values: [String?]) -> [NSPredicate] {
        var predicates = [NSPredicate]()
        for (index, value) in values.enumerated() {
            if let safeValue = value {
                if !safeValue.isEmpty {
                    predicates.append(NSPredicate(format: "%K CONTAINS %@", keys[index], safeValue))
                }
            }
        }
        
        return predicates
    }
    
    static func queryStrings(keys: [String], values: List<String>) -> [NSPredicate] {
        var predicates = [NSPredicate]()
        for (index, value) in values.enumerated() where !value.isEmpty {
            predicates.append(NSPredicate(format: "%K CONTAINS %@", keys[index], value))
        }
        
        return predicates
    }
    
    static func anyQueryStrings(key: String, values: List<StrObj>) -> [NSPredicate] {
        var predicates = [NSPredicate]()
        for value in values where !value.str.isEmpty {
            predicates.append(NSPredicate(format: "SUBQUERY(%K, $s, $s.str BEGINSWITH %@).@count > 0", key, value.str))
        }
        
        return predicates
    }
}
