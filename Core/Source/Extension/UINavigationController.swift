//
//  UINavigationController.swift
//  Pods
//
//  Created by king on 16/4/10.
//
//

import UIKit
extension Swifty where Base: UINavigationController {
    public func pushViewController(viewController: UIViewController) {
        if self.base.viewControllers.count > 0 {
            viewController.hidesBottomBarWhenPushed = true
        } else {
            viewController.hidesBottomBarWhenPushed = false
        }
      self.base.pushViewController(viewController, animated: true)
    }
}