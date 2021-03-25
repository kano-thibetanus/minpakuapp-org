//
//  BeaconManager.swift
//  MinpakuMock
//
//  Created by hiratti on 2019/03/24.
//  Copyright © 2019 hiratti. All rights reserved.
//

import CoreLocation
import RealmSwift
import UIKit

class BeaconManager: NSObject {
    var locationManager: CLLocationManager!
//    var uuid: UUID!
    // 2019.12 fitted for multiple uuids, aihara
    var uuidArray: [UUID?] = [
        UUID(uuidString: "EE634BED-258D-1801-898D-001C4D94EE82"),
        UUID(uuidString: "00000000-18DF-1001-B000-001C4D0D0F6A"),
        UUID(uuidString: "D89A5539-1A55-1801-B1DA-001C4D2A22C9"),
        UUID(uuidString: "FE286171-368A-1801-8EE9-001C4D754764"),
        UUID(uuidString: "EB66ACD2-258D-1801-9B56-001C4D7B4C10"),
        UUID(uuidString: "D88E627F-258D-1801-B9FD-001C4D44B3B9"),
        UUID(uuidString: "E6A9D09C-258D-1801-AEF2-001C4D987378"),
        UUID(uuidString: "29E58FB2-258D-1801-964F-001C4D54B8F7"),
        UUID(uuidString: "6B1BCA53-258D-1801-8428-001C4D6765CE")
    ]
//    var beaconRegion: CLBeaconRegion!
    var beaconRegions: [CLBeaconRegion] = []
    var beaconArray: [CLBeacon] = []
    var beaconArrays: [String: [CLBeacon]] = [:]
    
    var timer: Timer?
    let mapRefreshInterval = 1
    let logRegisterInterval = 10
    
    static var sharedInstance: BeaconManager {
        struct Static {
            static let instance: BeaconManager = BeaconManager()
        }
        return Static.instance
    }
    
    private override init() {
        super.init()
        
//        uuid = UUID(uuidString: "00000000-18DF-1001-B000-001C4D0D0F6A")
//        uuid = UUID(uuidString: "D89A5539-1A55-1801-B1DA-001C4D2A22C9")
        // 2019.12 fitted for multiple uuids, aihara
        uuidArray.forEach { uuid in
            // 20190907 yang add start
            //        beaconRegion = CLBeaconRegion(proximityUUID: uuid, identifier: uuid!.uuidString)
//        if #available(iOS 13.0, *) {
//            beaconRegion = CLBeaconRegion(uuid: uuid, identifier: uuid!.uuidString)
//        } else {
//            beaconRegion = CLBeaconRegion(proximityUUID: uuid, identifier: uuid!.uuidString)
//        }
            if #available(iOS 13.0, *) {
                beaconRegions.append(CLBeaconRegion(uuid: uuid!, identifier: uuid!.uuidString))
            } else {
                beaconRegions.append(CLBeaconRegion(proximityUUID: uuid!, identifier: uuid!.uuidString))
            }
        }
        // end
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
    }
    
    func start() {
        // 位置情報認証
        let status = CLLocationManager.authorizationStatus()
        if status == CLAuthorizationStatus.notDetermined {
            locationManager.requestAlwaysAuthorization()
        }
        
        // timer
        timer = Timer.scheduledTimer(timeInterval: TimeInterval(logRegisterInterval),
                                     target: self,
                                     selector: #selector(registerLog),
                                     userInfo: nil,
                                     repeats: true)
    }
    
    func end() {
        // Beacon 計測停止
        // timer
        // 2019.11 yang
        // locationManager.stopRangingBeacons(in: beaconRegion)
        // 2019.12 fitted for multiple uuids, aihara
        beaconRegions.forEach { beaconRegion in
            if #available(iOS 13.0, *) {
                locationManager.startRangingBeacons(satisfying: beaconRegion.beaconIdentityConstraint)
            } else {
                locationManager.startRangingBeacons(in: beaconRegion)
            }
        }
        // end
        // timer
        timer?.invalidate()
    }
    
    // 位置情報の許可などを確認
    private func checkForLocationServices() -> Bool {
        if CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self) {
            print("INFO: 探索に対応しています")
        } else {
            print("ERROR: 探索に対応していません")
            return false
        }
        
        if CLLocationManager.locationServicesEnabled() {
            print("INFO: 位置情報はONです")
        } else {
            print("ERROR: 位置情報はOffです")
            return false
        }
        
        return true
    }
    
    func nearBeacons() -> [Beacon] {
        // query
        var beaconQuery = ""
        let sep = " OR "
        for clBeacon in beaconArray {
            beaconQuery += String(format: "minor = \"%@\"", String(describing: clBeacon.minor)) + sep
        }
        if beaconQuery.count > sep.count {
            // 末尾を削除
            beaconQuery = String(beaconQuery.prefix(beaconQuery.count - sep.count))
        }
        
        if !beaconArray.isEmpty {
            do {
                let realm = try Realm()
                let beacons = realm.objects(Beacon.self).filter(NSPredicate(format: beaconQuery))
                
                return beacons.shuffled()
            } catch {
                print("error:\(error)")
            }
        }
        
        return []
    }
    
    func allBeacons() -> [Beacon] {
        do {
            let realm = try Realm()
            let beacons = realm.objects(Beacon.self)
            
            return beacons.shuffled()
        } catch {
            print("error:\(error)")
        }
        
        return []
    }
    
    func installBeacons(view: UIView, viewScale: Float) -> [BeaconView] {
        let beacons = BeaconManager.sharedInstance.allBeacons()
        var beaconViews = [BeaconView]()
        let beaconSize = CGSize(width: CGFloat(16.0 * viewScale), height: CGFloat(16.0 * viewScale))
        for beacon in beacons {
            let beaconView = BeaconView(image: UIImage(named: "icon_beacon"))
            beaconView.beacon = beacon
            beaconView.frame = CGRect(x: Int(Float(beacon.x()) * viewScale) - Int(beaconSize.width * 0.5),
                                      y: Int(Float(beacon.y()) * viewScale) - Int(beaconSize.height * 0.5),
                                      width: Int(beaconSize.width),
                                      height: Int(beaconSize.height))
            
            view.addSubview(beaconView)
            beaconViews.append(beaconView)
            beaconView.animate()
        }
        refreshBeacons(beaconViews: beaconViews)
        return beaconViews
    }
    
    func refreshBeacons(beaconViews: [BeaconView]) {
        let nearBeacons = BeaconManager.sharedInstance.nearBeacons()
        for beaconView in beaconViews {
            beaconView.isHidden = true
            for nearBeacon in nearBeacons where beaconView.beacon.minor == nearBeacon.minor {
                beaconView.isHidden = false
            }
        }
    }
    
    func proximityString(beacon: CLBeacon) -> String {
        var proximityStr = ""
        switch beacon.proximity {
        case .far:
            proximityStr = "far" // 10m
        case .near:
            proximityStr = "near" // 1m
        case .immediate:
            proximityStr = "immediate" // 数cm
        case .unknown:
            proximityStr = "unknown"
        default:
            proximityStr = "unknown"
        }
        return proximityStr
    }
    
    @objc func registerLog() {
        // MARK: Log
        
        // 2019.11 yang
//        for beacon in beaconArray {
//            ActivityLogManager.registerBeaconLog(event: .beaconDetect,
//                                                 uuid: beacon.proximityUUID.uuidString,
//                                                 major: String(describing: beacon.major),
//                                                 minor: String(describing: beacon.minor))
//        }
        if #available(iOS 13.0, *) {
            for beacon in beaconArray {
                ActivityLogManager.registerBeaconLog(event: .beaconDetect,
                                                     uuid: beacon.uuid.uuidString,
                                                     major: String(describing: beacon.major),
                                                     minor: String(describing: beacon.minor))
            }
        } else {
            for beacon in beaconArray {
                ActivityLogManager.registerBeaconLog(event: .beaconDetect,
                                                     uuid: beacon.proximityUUID.uuidString,
                                                     major: String(describing: beacon.major),
                                                     minor: String(describing: beacon.minor))
            }
        }
    }
}

extension BeaconManager: CLLocationManagerDelegate {
    // didChangeAuthorization：アプリへの位置情報の許可状況が変化した時
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        print("Delegate: didChangeAuthorization : \(status)")
        beaconRegions.forEach { beaconRegion in
            locationManager.startMonitoring(for: beaconRegion)
        }
    }
    
    // didStartMonitoringFor：Regionの探索が開始されたとき
    func locationManager(_ manager: CLLocationManager, didStartMonitoringFor region: CLRegion) {
        print("Delegate: didStartMonitoringFor \(region.identifier)")
        if region is CLBeaconRegion {
            if CLLocationManager.isRangingAvailable() {
                locationManager.requestState(for: (region as? CLBeaconRegion)!)
                beaconArrays[region.identifier] = []
                print("  call requestState for \(region.identifier)")
            }
        }
//        beaconRegions.forEach { beaconRegion in
//            locationManager.requestState(for: beaconRegion)
//        }
    }
    
    // didEnterRegion：探索条件に合ったiBeacon情報が格納されたRegionが最初に検知されたとき
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        print("Delegate: didEnterRegion : \(region.identifier)")
        // →(didRangeBeacons)で測定をはじめる
        // 2019.12 aihara
        //        locationManager.startRangingBeacons(in: beaconRegion)
        if #available(iOS 13.0, *) {
//            locationManager.startRangingBeacons(satisfying: beaconRegion.beaconIdentityConstraint)
            if region is CLBeaconRegion {
                if CLLocationManager.isRangingAvailable() {
                    locationManager.startRangingBeacons(satisfying: (region as? CLBeaconRegion)!.beaconIdentityConstraint)
                }
            }
        } else {
            locationManager.startRangingBeacons(in: (region as? CLBeaconRegion)!)
        }
        // end
    }
    
    // didExitRegion：Regionの探索条件に合ったiBeaconが全て検知されなくなったとき
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        print("Delegate: didExitRegion : \(region.identifier)")
        // 測定を停止する
        // 2019.12 aihara
        // locationManager.stopRangingBeacons(in: beaconRegion)
        if #available(iOS 13.0, *) {
            if region is CLBeaconRegion {
                if CLLocationManager.isRangingAvailable() {
                    locationManager.stopRangingBeacons(satisfying: (region as? CLBeaconRegion)!.beaconIdentityConstraint)
                }
            }
        } else {
            locationManager.stopRangingBeacons(in: (region as? CLBeaconRegion)!)
        }
        beaconArrays[region.identifier] = []
        // end
    }
    
    // CLLocationManager#requestState()が実行されたとき
    func locationManager(_ manager: CLLocationManager, didDetermineState state: CLRegionState, for region: CLRegion) {
        switch state {
        case .inside: // すでに領域内にいる場合は（didEnterRegion）は呼ばれない
            // →(didRangeBeacons)で測定をはじめる
            // 2019.12 aihara
            // locationManager.startRangingBeacons(in: beaconRegion)
            if #available(iOS 13.0, *) {
                if region is CLBeaconRegion {
                    if CLLocationManager.isRangingAvailable() {
                        locationManager.startRangingBeacons(satisfying: (region as? CLBeaconRegion)!.beaconIdentityConstraint)
                    }
                }
            } else {
                locationManager.startRangingBeacons(in: (region as? CLBeaconRegion)!)
            }
            // end
            print("Delegate: didDetermineState = inside : \(region.identifier)")
            
        case .outside:
            // 領域外→領域に入った場合はdidEnterRegionが呼ばれる
            if #available(iOS 13.0, *) {
                if region is CLBeaconRegion {
                    if CLLocationManager.isRangingAvailable() {
                        locationManager.stopRangingBeacons(satisfying: (region as? CLBeaconRegion)!.beaconIdentityConstraint)
                    }
                }
            } else {
                locationManager.stopRangingBeacons(in: (region as? CLBeaconRegion)!)
            }
            beaconArrays[region.identifier] = []
            beaconArray.removeAll()
            for (_, value) in beaconArrays {
                beaconArray += value
            }
            print("Delegate: didDetermineState = outside : \(region.identifier)")
        case .unknown:
            // 不明→領域に入った場合はdidEnterRegionが呼ばれる
            print("Delegate: didDetermineState = unknown : \(region.identifier)")
            
        default:
            print("Delegate: didDetermineState = else : \(region.identifier)")
        }
    }
    
    // didRangeBeacons：レンジング中にiBeacon情報が到着したとき
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        // 2019.12 fixed for multiple regions, aihara
        var targetUuid: String
        if #available(iOS 13.0, *) {
            targetUuid = region.uuid.uuidString
        } else {
            targetUuid = region.proximityUUID.uuidString
        }
//        beaconArrays[targetUuid].removeAll()
        beaconArrays[targetUuid] = beacons
        beaconArray.removeAll()
        for (_, value) in beaconArrays {
            beaconArray += value
        }
        print("Delegate: didRangeBeacons : \(beaconArray.count)")
    }
    
    // rangingBeaconsDidFailFor：レンジング中にエラーが発生したとき
    func locationManager(_ manager: CLLocationManager, rangingBeaconsDidFailFor region: CLBeaconRegion, withError error: Error) {
        print("Delegate: rangingBeaconsDidFailFor \(region.identifier)")
    }
}
