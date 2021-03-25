//
//  GeneralMapViewController.swift
//  MinpakuMock
//
//  Created by 平林陽一 on 2019/02/19.
//  Copyright © 2019 hiratti. All rights reserved.
//

import UIKit

class GeneralMapViewController: UIViewController {
    var viewModel: GeneralMapViewModel!
    var beacons: [BeaconView]!
    var timer: Timer?
    
    @IBOutlet weak var mapImageView: UIImageView!
    @IBOutlet weak var header: GeneralHeader!
    
    @IBOutlet weak var oceaniaBtn: UIButton!
    @IBOutlet weak var americaBtn: UIButton!
    @IBOutlet weak var europaBtn: UIButton!
    @IBOutlet weak var afuricaBtn: UIButton!
    @IBOutlet weak var westAsiaBtn: UIButton!
    @IBOutlet weak var sourthAsiaBtn: UIButton!
    @IBOutlet weak var eastSourthAsiaBtn: UIButton!
    @IBOutlet weak var koreaBtn: UIButton!
    @IBOutlet weak var chinaBtn: UIButton!
    @IBOutlet weak var northAsiaBtn: UIButton!
    @IBOutlet weak var ainuBtn: UIButton!
    @IBOutlet weak var japanBtn: UIButton!
    @IBOutlet weak var musicBtn: UIButton!
    @IBOutlet weak var languageBtn: UIButton!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        // viewModel
        viewModel = GeneralMapViewModel()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // btn
        oceaniaBtn.tag = 1
        americaBtn.tag = 2
        europaBtn.tag = 3
        afuricaBtn.tag = 4
        westAsiaBtn.tag = 5
        sourthAsiaBtn.tag = 6
        eastSourthAsiaBtn.tag = 7
        koreaBtn.tag = 8
        chinaBtn.tag = 9
        northAsiaBtn.tag = 10
        ainuBtn.tag = 11
        japanBtn.tag = 12
        musicBtn.tag = 13
        languageBtn.tag = 14
        
        oceaniaBtn.addTarget(self, action: #selector(pressCategoryBtn(_:)), for: .touchUpInside)
        americaBtn.addTarget(self, action: #selector(pressCategoryBtn(_:)), for: .touchUpInside)
        europaBtn.addTarget(self, action: #selector(pressCategoryBtn(_:)), for: .touchUpInside)
        afuricaBtn.addTarget(self, action: #selector(pressCategoryBtn(_:)), for: .touchUpInside)
        westAsiaBtn.addTarget(self, action: #selector(pressCategoryBtn(_:)), for: .touchUpInside)
        sourthAsiaBtn.addTarget(self, action: #selector(pressCategoryBtn(_:)), for: .touchUpInside)
        eastSourthAsiaBtn.addTarget(self, action: #selector(pressCategoryBtn(_:)), for: .touchUpInside)
        koreaBtn.addTarget(self, action: #selector(pressCategoryBtn(_:)), for: .touchUpInside)
        chinaBtn.addTarget(self, action: #selector(pressCategoryBtn(_:)), for: .touchUpInside)
        northAsiaBtn.addTarget(self, action: #selector(pressCategoryBtn(_:)), for: .touchUpInside)
        ainuBtn.addTarget(self, action: #selector(pressCategoryBtn(_:)), for: .touchUpInside)
        japanBtn.addTarget(self, action: #selector(pressCategoryBtn(_:)), for: .touchUpInside)
        musicBtn.addTarget(self, action: #selector(pressCategoryBtn(_:)), for: .touchUpInside)
        languageBtn.addTarget(self, action: #selector(pressCategoryBtn(_:)), for: .touchUpInside)
        
        header.menuBtn.addTarget(self, action: #selector(pressMenuBtn(_:)), for: .touchUpInside)
        header.backBtn.addTarget(self, action: #selector(pressBackBtn(_:)), for: .touchUpInside)
        
        // title
        header.titleLbl.text = "みんぱくマップ"
        
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
        beacons = BeaconManager.sharedInstance.installBeacons(view: mapImageView, viewScale: 1.0)
    }
    
    @objc func refreshBeacons() {
        BeaconManager.sharedInstance.refreshBeacons(beaconViews: beacons)
    }
    
    @objc func pressCategoryBtn(_ sender: UIButton) {
        if let viewController: CultureViewController = CultureViewController.viewControllerFromStoryboard() {
            viewController.viewModel.search(query: viewModel.queryString(category: sender.tag))
            viewController.viewModel.setTag(tag: sender.tag)
            navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    @objc func pressMenuBtn(_ sender: UIButton) {
        if let viewController: MenuNavigationController = MenuNavigationController.viewControllerFromStoryboard() {
            present(viewController, animated: true, completion: nil)
        }
    }
    
    @objc func pressBackBtn(_ sender: UIButton) {
        dismiss(animated: true)
    }
}
