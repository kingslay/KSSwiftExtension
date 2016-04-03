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
    #if DEBUG
    #else
    #endif
    public override static func initialize() {
        struct Static {
            static var token: dispatch_once_t = 0
        }
        // 确保不是子类
        if self !== UIViewController.self {
            return
        }
        if KSSystem.isSimulator {
            dispatch_once(&Static.token) {
                let originalSelector = NSSelectorFromString("dealloc")
                let swizzledSelector = #selector(ks_deinit)
                UIViewController.ks_swizzle(originalSelector, swizzledSelector: swizzledSelector)
            }
        }
    }
    public func ks_deinit() {
//        ks_deinit()
        let message = "[标题:\(self.title)],[类:\(self.className()))]"
        if KSSystem.isSimulator {
            KSDebugStatusBar.post(message)
        }
        NSLog("dealloc vc = \(message)")
    }
    
    public func ksAutoAdjustKeyBoard() {
        NSNotificationCenter.defaultCenter().addObserverForName(UIKeyboardWillShowNotification, object: nil, queue: nil) { [unowned self] notification in
            if let inputView = self.ksFindFirstResponder() {
                let userInfo: NSDictionary = notification.userInfo!
                let keyboardRect = userInfo[UIKeyboardFrameEndUserInfoKey]!.CGRectValue
                let window = UIApplication.sharedApplication().keyWindow
                if let convertRect = inputView.superview?.convertRect(inputView.frame, toView: window) {
                    let diff = CGRectGetMaxY(convertRect) - CGRectGetMinY(keyboardRect) + 10
                    if diff > 0 {
                        let duration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as? NSTimeInterval ?? 0
                        UIView.animateWithDuration(duration, animations: {
                            var bounds = self.view.bounds
                            bounds.origin.y += diff
                            self.view.bounds = bounds
                        })
                    }
                }
            }
        }
        NSNotificationCenter.defaultCenter().addObserverForName(UIKeyboardWillHideNotification, object: nil, queue: nil) { [unowned self] notification in
            let userInfo: NSDictionary = notification.userInfo!
            let duration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as? NSTimeInterval ?? 0
            UIView.animateWithDuration(duration, animations: {
                let frame = self.view.frame
                self.view.bounds = frame
            })
        }
    }
    
    public func ksFindFirstResponder() -> UIView? {
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