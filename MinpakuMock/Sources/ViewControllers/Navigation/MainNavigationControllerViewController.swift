//
//  MainNavigationControllerViewController.swift
//  MinpakuMock
//
//  Created by hiratti on 2019/02/27.
//  Copyright © 2019 hiratti. All rights reserved.
//

import UIKit

class MainNavigationController: UINavigationController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // viewControllers
        var viewControllers: [UIViewController] = []
        if let viewController: RecommendedViewController = RecommendedViewController.viewControllerFromStoryboard() {
            viewControllers.append(viewController)
        }
        setViewControllers(viewControllers, animated: false)
        
        setNavigationBarHidden(true, animated: false)
    }
}
