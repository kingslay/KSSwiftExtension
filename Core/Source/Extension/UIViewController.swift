//
//  UIViewController.swift
//  PolyGe
//
//  Created by king on 15/6/22.
//  Copyright © 2015年 king. All rights reserved.
//

import UIKit
public extension UIViewController {
    class public func loadXib() -> UIViewController? {
        return UIViewController.loadXib(self.className())
    }
    class public func loadXib(name: String) -> UIViewController?{
        return NSBundle.mainBundle().loadNibNamed(name, owner: nil, options: nil).first as? UIViewController
    }
    public func ks_navigationController() -> UINavigationController?{
        if let nav = self as? UINavigationController {
            return nav
        }else if let tabBar = self as? UITabBarController {
            return tabBar.selectedViewController?.ks_navigationController()
        }
        return self.navigationController
    }
    ///弹出键盘的时候，那个控制不能被键盘遮住。默认是自己本身
    public func ks_relatedViewFor(inputView: UIView) -> UIView {
        return inputView
    }

    public func ks_findFirstResponder() -> UIView? {
        return recursionTraverseFindFirstResponderIn(self.view)
    }
    private func recursionTraverseFindFirstResponderIn(view: UIView) -> UIView? {
        for subView in view.subviews {
            if subView.isFirstResponder() {
                return subView
            }
            if let subView = recursionTraverseFindFirstResponderIn(subView) {
                return subView
            }
        }
        return nil
    }
}