//
//  WhereIsViewController.swift
//  MinpakuMock
//
//  Created by hiratti on 2019/03/15.
//  Copyright © 2019 hiratti. All rights reserved.
//

import UIKit

class WhereIsViewController: UIViewController {
    var viewModel: WhereIsViewModel!
    var beacons: [BeaconView]!
    var timer: Timer?
    
    @IBOutlet weak var closeBtn: UIButton!
    @IBOutlet weak var whreIsView: WhereIsView!
    @IBOutlet weak var whereIsLbl: UILabel!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        // viewModel
        viewModel = WhereIsViewModel()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // btn
        closeBtn.addTarget(self, action: #selector(pressCloseBtn(_:)), for: .touchUpInside)
        
        // where
        whreIsView.highLightArea(shelf: Shelf.whereShelf(shelf: viewModel.mokuroku.shelf))
        whreIsView.addGrid()
        whreIsView.addLbl()
        
        // lbl
        let frontString = NSAttributedString(string: "お探しの展示物は ", attributes: [
            .foregroundColor: UIColor.black,
            .font: UIFont.boldSystemFont(ofSize: 26.0)
        ])
        
        let middleString = NSAttributedString(string: "\(whreIsView.getArea(shelf: Shelf.whereShelf(shelf: viewModel.mokuroku.shelf)))", attributes: [
            .foregroundColor: UIColor.red,
            .font: UIFont.boldSystemFont(ofSize: 44.0)
        ])
        
        let tailString = NSAttributedString(string: " のエリアにあります。", attributes: [
            .foregroundColor: UIColor.black,
            .font: UIFont.boldSystemFont(ofSize: 26.0)
        ])
        
        let mutableAttributedString = NSMutableAttributedString()
        mutableAttributedString.append(frontString)
        mutableAttributedString.append(middleString)
        mutableAttributedString.append(tailString)
        
        whereIsLbl.attributedText = mutableAttributedString
        
        // timer
        timer = Timer.scheduledTimer(timeInterval: TimeInterval(BeaconManager.sharedInstance.mapRefreshInterval),
                                     target: self,
                                     selector: #selector(refreshBeacons),
                                     userInfo: nil,
                                     repeats: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // beacon
        installBeacon()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        // timer
        timer?.invalidate()
    }
    
    func installBeacon() {
        beacons = BeaconManager.sharedInstance.installBeacons(view: whreIsView, viewScale: 1.0)
    }
    
    @objc func refreshBeacons() {
        BeaconManager.sharedInstance.refreshBeacons(beaconViews: beacons)
    }
    
    @objc func pressCloseBtn(_ sender: UIButton) {
        dismiss(animated: true)
    }
}
