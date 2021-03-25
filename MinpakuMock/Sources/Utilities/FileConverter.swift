//
//  FileConverter.swift
//  QueryTest
//
//  Created by Hiratti on 2019/02/13.
//  Copyright © 2019年 hiratti41. All rights reserved.
//

import Foundation
import RealmSwift

class FileConverter {
    class func registerFiles() {
        print("\(Realm.Configuration.defaultConfiguration.fileURL!)")
        
        FileConverter.register(Mokuroku.self)
        FileConverter.register(Video.self)
        FileConverter.register(OCM.self)
        FileConverter.register(OWC.self)
        FileConverter.register(Shelf.self)
        FileConverter.register(CategoryBig.self)
        FileConverter.register(CategoryMiddle.self)
        FileConverter.register(CategorySmall.self)
        FileConverter.register(Beacon.self)
    }
    
    static func register<T>(_: T.Type) where T: Object, T: Decodable {
        do {
            // check alrready
            let realm = try Realm()
            let alreadyObjects = realm.objects(T.self)
            let jsonData = try getJsonData(fileName: String(describing: T.self))
            let objects = try JSONDecoder().decode([T].self, from: jsonData!)
            if objects.count <= alreadyObjects.count {
                return
            }
            
            // insert
            for obj in objects {
                try realm.write {
                    realm.add(obj)
                }
            }
        } catch {
            print("error:\(error)")
        }
    }
    
    static func getJsonData(fileName: String) throws -> Data? {
        guard let path = Bundle.main.path(forResource: fileName, ofType: "json") else { return nil }
        let url = URL(fileURLWithPath: path)
        
        return try Data(contentsOf: url)
    }
    
    static func encodeRealmList<T>(_: T.Type) -> String where T: Object, T: Codable {
        let delimiter = ", "
        var string = "["
        
        do {
            let realm = try Realm()
            let objects = realm.objects(T.self)
            let encoder = JSONEncoder()
            
            for (index, object) in objects.enumerated() {
                let data = try encoder.encode(object)
                
                if let jsonString = String(data: data, encoding: String.Encoding.utf8) {
                    string += jsonString
                    if index < objects.count - 1 {
                        string += delimiter
                    }
                }
            }
        } catch {
            print("error:\(error)")
        }
        string += "]"
        return string
    }
}
