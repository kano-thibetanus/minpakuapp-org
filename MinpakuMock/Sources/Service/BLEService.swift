//
//  BLEService.swift
//  MinpakuMock
//
//  Created by HitomiKano on 2021/03/25.
//  Copyright © 2021 hiratti. All rights reserved.
//

import CoreBluetooth
import UIKit

class BLEService: NSObject {
    static let shared = BLEService()
    
    static let ServiceUuid: String = "651E"
    static let C12sUuid: String = "651F"

    private var centralManager: CBCentralManager!
    private var peripheralManager: CBPeripheralManager!
    
    let serviceUuid = CBUUID(string: BLEService.ServiceUuid)
    let c12Uuid = CBUUID(string: BLEService.C12sUuid)
    
    override private init() {
        super.init()
    }
    
    func start() {
        let options = [CBCentralManagerOptionRestoreIdentifierKey: "restoreKey"]
        centralManager = CBCentralManager(delegate: self, queue: nil, options: options)
        peripheralManager = CBPeripheralManager(delegate: self, queue: nil, options: options)
    }
}

extension BLEService: CBCentralManagerDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if UIApplication.shared.applicationState == .active {
            scanStartInActive()
        } else if UIApplication.shared.applicationState == .background {
            scanStartInBackground()
        }
    }
    
    func scanStartInActive() {
        if centralManager == nil {
            return
        }
        
        if centralManager.state != .poweredOn {
            return
        }
        if centralManager.isScanning {
            centralManager.stopScan()
        }
        centralManager.scanForPeripherals(withServices: nil, options: nil)
    }
    
    func scanStartInBackground() {
        // バックグラウンドでは指定したUUIDをスキャンする。
        // 本アプリがペリフェラル兼セントラルとして稼働する。
        if centralManager == nil {
            return
        }
        
        if centralManager.state != .poweredOn {
            return
        }
        if centralManager.isScanning {
            centralManager.stopScan()
        }
        centralManager.scanForPeripherals(withServices: [serviceUuid], options: nil)
    }
    
    // ペリフェラル発見の場合。
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral,
                        advertisementData: [String: Any], rssi RSSI: NSNumber)
    {
        #if false
            let envLog = EnvironmentLogModel(name: peripheral.name ?? "", advertisementData: advertisementData, rssi: RSSI)
            EventLogger.shared.logEnvironment(value: EventLogModel(log: envLog.toDict()))
        #endif
    }
    
    // バックグラウンドからの呼び出し。
    func centralManager(_ central: CBCentralManager, willRestoreState dict: [String: Any]) {
        // 接続処理を行わないのでとりあえずは定義のみ。
        debugPrint("central.willRestoreState", dict)
    }
}

extension BLEService: CBPeripheralManagerDelegate {
    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        if peripheral.state == .poweredOn {
            startAdvertise()
        }
    }
    
    func startAdvertise() {
        // サービスの追加。
        let service = CBMutableService(type: serviceUuid, primary: true)
        peripheralManager.add(service)
    }
    
    func peripheralManager(_ peripheral: CBPeripheralManager, didAdd service: CBService, error: Error?) {
        if error != nil {
            return
        }
        if !peripheralManager.isAdvertising {
            // ユーザコードとUUIDをadvatiseに含める。
            let adavatisementData: [String: Any] = [CBAdvertisementDataLocalNameKey: "minpaku",
                                                    CBAdvertisementDataServiceUUIDsKey: [serviceUuid]]
            peripheralManager.startAdvertising(adavatisementData)
        }
    }
    
    func peripheralManager(_ peripheral: CBPeripheralManager, willRestoreState dict: [String: Any]) {
        // 接続処理を行わないのでとりいそぎ、定義のみ。
        debugPrint("peripheral.willRestoreState", dict)
    }
}
