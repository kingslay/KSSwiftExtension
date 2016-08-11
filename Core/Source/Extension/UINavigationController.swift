//
//  UINavigationController.swift
//  Pods
//
//  Created by king on 16/4/10.
//
//

import UIKit
extension UINavigationController {
    public func pushViewController(viewController: UIViewController) {
        if self.viewControllers.count > 0 {
            viewController.hidesBottomBarWhenPushed = true
        } else {
            viewController.hidesBottomBarWhenPushed = false
        }
      self.pushViewController(viewController, animated: true)
    }
}