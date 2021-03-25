//
//  UIViewControllerExtension.swift
//  MinpakuMock
//
//  Created by 平林陽一 on 2019/02/19.
//  Copyright © 2019 hiratti. All rights reserved.
//

import UIKit

extension UIViewController {
    class func viewControllerFromStoryboard<T>() -> T? {
        let storyboard = UIStoryboard(name: String(describing: self), bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: String(describing: self)) as? T
        
        return viewController
    }
}
