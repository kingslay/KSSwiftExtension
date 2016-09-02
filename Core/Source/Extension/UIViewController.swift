//
//  UIViewController.swift
//  PolyGe
//
//  Created by king on 15/6/22.
//  Copyright © 2015年 king. All rights reserved.
//

import UIKit

extension UIViewController {
    ///弹出键盘的时候，那个控制不能被键盘遮住。默认是自己本身
    public func relatedViewFor(inputView: UIView) -> UIView {
        return inputView
    }
}
extension Swifty where Base: UIViewController {
    static public func loadXib() -> UIViewController? {
        return loadXib(self.className())
    }
    static public func loadXib(name: String) -> UIViewController?{
        return NSBundle.mainBundle().loadNibNamed(name, owner: nil, options: nil).first as? UIViewController
    }
    public func navigationController() -> UINavigationController?{
        if let nav = self.base as? UINavigationController {
            return nav
        }else if let tabBar = self.base as? UITabBarController {
            return tabBar.selectedViewController?.ks.navigationController()
        }
        return self.base.navigationController
    }

    public func findFirstResponder() -> UIView? {
        return recursionTraverseFindFirstResponderIn(self.base.view)
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