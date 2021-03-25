//
//  AppDelegate.swift
//  MinpakuMock
//
//  Created by 平林陽一 on 2019/02/19.
//  Copyright © 2019 hiratti. All rights reserved.
//

import Crashlytics
import Fabric
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        Fabric.with([Crashlytics.self])
        RealmKit.migrationRealm()
        FileConverter.registerFiles()
        
        return true
    }
}
