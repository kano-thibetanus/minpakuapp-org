//
//  CultureMapViewController.swift
//  MinpakuMock
//
//  Created by hiratti on 2019/03/18.
//  Copyright © 2019 hiratti. All rights reserved.
//

import UIKit

class CultureMapViewController: UIViewController {
    var viewModel: CultureMapViewModel!
    var beacons: [BeaconView]!
    var timer: Timer?
    
    @IBOutlet weak var mapImageView: UIImageView!
    @IBOutlet weak var header: GeneralHeader!
    @IBOutlet weak var matsuriMapBtn: UIButton!
    @IBOutlet weak var matsuriMapSubBtn: UIButton!
    @IBOutlet weak var hibiMapBtn: UIButton!
    @IBOutlet weak var hibiMapSubBtn: UIButton!
    @IBOutlet weak var taminzokuMapBtn: UIButton!
    @IBOutlet weak var okinawaMapBtn: UIButton!
    
    @IBOutlet weak var matsuriBtn: UIButton!
    @IBOutlet weak var hibiBtn: UIButton!
    @IBOutlet weak var taminzokuBtn: UIButton!
    @IBOutlet weak var okinawaBtn: UIButton!
    @IBOutlet weak var mapBtn: UIButton!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        // viewModel
        viewModel = CultureMapViewModel()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // btn
        matsuriBtn.tag = 1201
        hibiBtn.tag = 1202
        taminzokuBtn.tag = 1204
        okinawaBtn.tag = 1203
        
        matsuriMapBtn.tag = 1201
        matsuriMapSubBtn.tag = 1201
        hibiMapBtn.tag = 1202
        hibiMapSubBtn.tag = 1202
        taminzokuMapBtn.tag = 1204
        okinawaMapBtn.tag = 1203
        
        matsuriBtn.addTarget(self, action: #selector(pressCategoryBtn(_:)), for: .touchUpInside)
        hibiBtn.addTarget(self, action: #selector(pressCategoryBtn(_:)), for: .touchUpInside)
        taminzokuBtn.addTarget(self, action: #selector(pressCategoryBtn(_:)), for: .touchUpInside)
        okinawaBtn.addTarget(self, action: #selector(pressCategoryBtn(_:)), for: .touchUpInside)
        
        matsuriMapBtn.addTarget(self, action: #selector(pressCategoryBtn(_:)), for: .touchUpInside)
        matsuriMapSubBtn.addTarget(self, action: #selector(pressCategoryBtn(_:)), for: .touchUpInside)
        hibiMapBtn.addTarget(self, action: #selector(pressCategoryBtn(_:)), for: .touchUpInside)
        hibiMapSubBtn.addTarget(self, action: #selector(pressCategoryBtn(_:)), for: .touchUpInside)
        taminzokuMapBtn.addTarget(self, action: #selector(pressCategoryBtn(_:)), for: .touchUpInside)
        okinawaMapBtn.addTarget(self, action: #selector(pressCategoryBtn(_:)), for: .touchUpInside)
        
        mapBtn.addTarget(self, action: #selector(pressMapBtn(_:)), for: .touchUpInside)
        header.menuBtn.addTarget(self, action: #selector(pressMenuBtn(_:)), for: .touchUpInside)
        header.backBtn.addTarget(self, action: #selector(pressBackBtn(_:)), for: .touchUpInside)
        
        // title
        header.titleLbl.text = "日本の文化エリアマップ"
        
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
        beacons = BeaconManager.sharedInstance.installBeacons(view: mapImageView, viewScale: 3.0)
    }
    
    @objc func refreshBeacons() {
        BeaconManager.sharedInstance.refreshBeacons(beaconViews: beacons)
    }
    
    @objc func pressCategoryBtn(_ sender: UIButton) {
        if let viewController: SearchResultViewController = SearchResultViewController.viewControllerFromStoryboard() {
            viewController.viewModel.search(query: viewModel.queryString(category: sender.tag))
            viewController.viewModel.searchKeys = [Mokuroku.SearchKey.category.rawValue]
            viewController.viewModel.searchWords = [String(describing: sender.tag)]
            
            navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    @objc func pressMapBtn(_ sender: UIButton) {
        if let cnt = navigationController?.viewControllers.count {
            navigationController?.popToViewController(navigationController!.viewControllers[cnt - 3], animated: true)
        }
    }
    
    @objc func pressMenuBtn(_ sender: UIButton) {
        if let viewController: MenuNavigationController = MenuNavigationController.viewControllerFromStoryboard() {
            present(viewController, animated: true, completion: nil)
        }
    }
    
    @objc func pressBackBtn(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
}
