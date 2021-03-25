//
//  ActivityLogManager.swift
//  MinpakuMock
//
//  Created by hiratti on 2019/03/27.
//  Copyright © 2019 hiratti. All rights reserved.
//

import RealmSwift
import UIKit

class ActivityLogManager {
    // ActiveLog追加
    static func registerActiveLog(event: ActionLog.EventName,
                                  itemID: String?,
                                  predicate: String?,
                                  image: Data?) {
        do {
            let realm = try Realm()
            let activeLog = ActionLog()
            // customerID
            if let customerID = RealmKit.getUser()?.customerID {
                activeLog.customerID = customerID
            }
            
            // event
            activeLog.event = event.rawValue
            
            // createdAt
            let now = Date()
            activeLog.createdAt = now
            
            // imageName
            let unixTime = Int64(now.timeIntervalSince1970)
            if let safeimage = image, let customerID = RealmKit.getUser()?.customerID {
                let imageName = String(format: "%@_%d_%@.png", customerID, unixTime, event.rawValue)
                activeLog.imageName = imageName
                
                // Documentsに画像保存
                ActivityLogManager.saveData(data: safeimage, path: ActivityLogManager.fileInDocumentsDirectory(fileName: imageName))
            }
            
            // itemID
            if let safeItemID = itemID {
                activeLog.itemID = safeItemID
            }
            
            // predicate
            if let safePredicate = predicate {
                activeLog.predicate = safePredicate
            }
            
            try realm.write {
                realm.add(activeLog)
            }
        } catch {
            print("error:\(error)")
        }
    }
    
    // BeaconLog追加
    static func registerBeaconLog(event: ActionLog.EventName,
                                  uuid: String,
                                  major: String,
                                  minor: String) {
        do {
            let realm = try Realm()
            let beaconLog = ActionLog()
            // customerID
            if let customerID = RealmKit.getUser()?.customerID {
                beaconLog.customerID = customerID
            }
            
            // event
            beaconLog.event = event.rawValue
            
            // createdAt
            let now = Date()
            beaconLog.createdAt = now
            
            // beacon識別情報
            beaconLog.uuid = uuid
            beaconLog.major = major
            beaconLog.minor = minor
            
            try realm.write {
                realm.add(beaconLog)
            }
            
        } catch {
            print("error:\(error)")
        }
    }
    
    // DocumentディレクトリのfileURLを取得
    static func getDocumentsURL() -> NSURL {
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0] as NSURL
        return documentsURL
    }
    
    // ディレクトリのパスにファイル名をつなげてファイルのフルパスを作る
    static func fileInDocumentsDirectory(fileName: String) -> String {
        let fileURL = ActivityLogManager.getDocumentsURL().appendingPathComponent(fileName)
        return fileURL!.path
    }
    
    // Data保存
    static func saveData(data: Data, path: String) {
        do {
            try data.write(to: URL(fileURLWithPath: path), options: .atomic)
        } catch {
            print(error)
        }
    }
    
    static func saveString(strData: String, path: String) {
        do {
            try strData.write(toFile: path, atomically: true, encoding: String.Encoding.utf8)
        } catch {
            print(error)
        }
    }
    
    // ActiveLog書き出し
    static func exportLogs() {
        let now = Date()
        let unixTime = Int64(now.timeIntervalSince1970)
        let fileName = String(format: "ActiveLog_%d.json", unixTime)
        let filePath = ActivityLogManager.fileInDocumentsDirectory(fileName: fileName)
        let logJsonStr = FileConverter.encodeRealmList(ActionLog.self)
        
        ActivityLogManager.saveString(strData: logJsonStr, path: filePath)
    }
}
