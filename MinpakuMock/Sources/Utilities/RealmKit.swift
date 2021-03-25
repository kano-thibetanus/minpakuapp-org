//
//  RealmKit.swift
//  QueryTest
//
//  Created by Hiratti on 2019/02/14.
//  Copyright © 2019年 hiratti41. All rights reserved.
//

import Foundation

import RealmSwift

class RealmKit {
    static func congiureRealm() {
        // config Realm file path
        let config = Realm.Configuration(
            fileURL: Bundle.main.url(forResource: "default", withExtension: "realm"),
            readOnly: true
        )
        Realm.Configuration.defaultConfiguration = config
    }
    
    static func copyRealm() {
        let defaultRealmPath = Realm.Configuration.defaultConfiguration.fileURL!
        if FileManager.default.fileExists(atPath: defaultRealmPath.path) {
            return
        }
        
        let bundleRealmPath = Bundle.main.url(forResource: "default", withExtension: "realm")
        do {
            try FileManager.default.copyItem(at: bundleRealmPath!, to: defaultRealmPath)
        } catch {
            print("error copying realm file: \(error)")
        }
    }
    
    static func migrationRealm() {
        let config = Realm.Configuration(
            // 新しいスキーマバージョンを設定します。以前のバージョンより大きくなければなりません。
            // （スキーマバージョンを設定したことがなければ、最初は0が設定されています）
            schemaVersion: 1,
            
            // マイグレーション処理を記述します。古いスキーマバージョンのRealmを開こうとすると
            // 自動的にマイグレーションが実行されます。
            migrationBlock: { _, oldSchemaVersion in
                // 最初のマイグレーションの場合、`oldSchemaVersion`は0です
                if oldSchemaVersion < 1 {
                    // 何もする必要はありません！
                    // Realmは自動的に新しく追加されたプロパティと、削除されたプロパティを認識します。
                    // そしてディスク上のスキーマを自動的にアップデートします。
                }
            }
        )
        
        // デフォルトRealmに新しい設定を適用します
        Realm.Configuration.defaultConfiguration = config
    }
    
    // User追加 login時
    static func createUser() {
        do {
            let realm = try Realm()
            // すでにいる場合作成しない
            let results = realm.objects(User.self)
            if !results.isEmpty {
                return
            }
            
            let user = User()
            user.customerID = NSUUID().uuidString
            
            try realm.write {
                realm.add(user)
            }
        } catch {
            print("error:\(error)")
        }
    }
    
    // User取得
    static func getUser() -> User? {
        do {
            let realm = try Realm()
            let user = realm.objects(User.self).first
            
            return user
        } catch {
            print("error:\(error)")
        }
        return nil
    }
    
    static func deleteUserData() {
        do {
            let realm = try Realm()
            let favorites = realm.objects(Favorite.self)
            let photos = realm.objects(Photo.self)
            let notes = realm.objects(Note.self)
            let actionLogs = realm.objects(ActionLog.self)
            let users = realm.objects(User.self)
            
            try realm.write {
                realm.delete(favorites)
                realm.delete(photos)
                realm.delete(notes)
                realm.delete(actionLogs)
                realm.delete(users)
            }
        } catch {
            print("error:\(error)")
        }
    }
}
