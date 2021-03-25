//
//  MenuViewController.swift
//  MinpakuMock
//
//  Created by 平林陽一 on 2019/02/19.
//  Copyright © 2019 hiratti. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {
    @IBOutlet weak var closeBtn: UIButton!
    @IBOutlet weak var mapBtn: UIButton!
    @IBOutlet weak var searchBtn: UIButton!
    @IBOutlet weak var myPageBtn: UIButton!
    @IBOutlet weak var nearbyBtn: UIButton!
    @IBOutlet weak var noteBtn: UIButton!
    @IBOutlet weak var cameraBtn: UIButton!
    @IBOutlet weak var backToTopBtn: UIButton!
    @IBOutlet weak var logoutBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // btn
        closeBtn.addTarget(self, action: #selector(pressCloseBtn(_:)), for: .touchUpInside)
        mapBtn.addTarget(self, action: #selector(pressMapBtn(_:)), for: .touchUpInside)
        searchBtn.addTarget(self, action: #selector(pressSearchBtn(_:)), for: .touchUpInside)
        myPageBtn.addTarget(self, action: #selector(pressMyPageBtn(_:)), for: .touchUpInside)
        nearbyBtn.addTarget(self, action: #selector(pressNearbyBtn(_:)), for: .touchUpInside)
        noteBtn.addTarget(self, action: #selector(pressNoteBtn(_:)), for: .touchUpInside)
        cameraBtn.addTarget(self, action: #selector(pressCameraBtn(_:)), for: .touchUpInside)
        backToTopBtn.addTarget(self, action: #selector(pressBackToTopBtn(_:)), for: .touchUpInside)
        logoutBtn.addTarget(self, action: #selector(pressLogoutBtn(_:)), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {}
    
    @objc func pressCloseBtn(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    @objc func pressMapBtn(_ sender: UIButton) {
        if let viewController: GeneralMapViewController = GeneralMapViewController.viewControllerFromStoryboard() {
            navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    @objc func pressSearchBtn(_ sender: UIButton) {
        if let viewController: SearchViewController = SearchViewController.viewControllerFromStoryboard() {
            navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    @objc func pressMyPageBtn(_ sender: UIButton) {
        if let viewController: MyPageViewController = MyPageViewController.viewControllerFromStoryboard() {
            navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    @objc func pressNearbyBtn(_ sender: UIButton) {
        if let viewController: NearbyViewController = NearbyViewController.viewControllerFromStoryboard() {
            navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    @objc func pressNoteBtn(_ sender: UIButton) {
        if let viewController: NoteViewController = NoteViewController.viewControllerFromStoryboard() {
            navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    @objc func pressCameraBtn(_ sender: UIButton) {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            if let viewController: CameraViewController = CameraViewController.viewControllerFromStoryboard() {
                navigationController?.pushViewController(viewController, animated: true)
            }
        }
    }
    
    @objc func pressBackToTopBtn(_ sender: UIButton) {
        // MainNavigationControllerを乗せる(実際には戻っていない。)
        if let viewController: MainNavigationController = MainNavigationController.viewControllerFromStoryboard() {
            present(viewController, animated: true)
        }
    }
    
    @objc func pressLogoutBtn(_ sender: UIButton) {
        if let viewController: PassCodeViewController = PassCodeViewController.viewControllerFromStoryboard() {
            viewController.viewModel.isLogin = false
            
            navigationController?.pushViewController(viewController, animated: true)
        }
    }
}
