//
//  UINavigationController.swift
//  Pods
//
//  Created by king on 16/4/10.
//
//

import UIKit
extension Swifty where Base: UINavigationController {
    public func pushViewController(_ viewController: UIViewController) {
        if base.viewControllers.count > 0 {
            viewController.hidesBottomBarWhenPushed = true
        } else {
            viewController.hidesBottomBarWhenPushed = false
        }
        base.pushViewController(viewController, animated: true)
    }
}
