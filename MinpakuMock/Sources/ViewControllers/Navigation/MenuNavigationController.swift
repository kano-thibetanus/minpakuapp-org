//
//  MenuNavigationController.swift
//  MinpakuMock
//
//  Created by hiratti on 2019/03/05.
//  Copyright © 2019 hiratti. All rights reserved.
//

import UIKit

class MenuNavigationController: UINavigationController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // viewControllers
        var viewControllers: [UIViewController] = []
        if let viewController: MenuViewController = MenuViewController.viewControllerFromStoryboard() {
            viewControllers.append(viewController)
        }
        setViewControllers(viewControllers, animated: false)
        
        setNavigationBarHidden(true, animated: false)
    }
}
