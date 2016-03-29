//
//  UIViewController.swift
//  PolyGe
//
//  Created by king on 15/6/22.
//  Copyright © 2015年 king. All rights reserved.
//

import UIKit
extension UIViewController {
    class public func loadXib() -> UIViewController? {
        return UIViewController.loadXib(self.className())
    }
    class public func loadXib(name: String) -> UIViewController?{
        return NSBundle.mainBundle().loadNibNamed(name, owner: nil, options: nil).first as? UIViewController
    }
    public func ksNavigationController() -> UINavigationController?{
        if let nav = self as? UINavigationController {
            return nav
        }else if let tabBar = self as? UITabBarController {
            return tabBar.selectedViewController?.ksNavigationController()
        }
        return self.navigationController
    }
    public override static func initialize() {
        struct Static {
            static var token: dispatch_once_t = 0
        }
        // 确保不是子类
        if self !== UIViewController.self {
            return
        }
        dispatch_once(&Static.token) {
            let originalSelector = Selector("dealloc")
            let swizzledSelector = #selector(ks_deinit)
            UIViewController.ks_swizzle(originalSelector, swizzledSelector: swizzledSelector)
        }
    }
    public func ks_deinit() {
        let message = "[标题:\(self.title)],[类:\(self.className()))]"
        KSDebugStatusBar.post(message)
        self.ks_deinit()
        NSLog("dealloc vc = \(message)")
    }
}