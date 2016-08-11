//
//  UIViewController.swift
//  PolyGe
//
//  Created by king on 15/6/22.
//  Copyright © 2015年 king. All rights reserved.
//

import UIKit
import KSSwiftExtension
import RxSwift
public extension UIViewController {
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
//        _isReleaseAssertConfiguration()
//        _isFastAssertConfiguration()
        if _isDebugAssertConfiguration() {
            dispatch_once(&Static.token) {
                ks_swizzleInstanceMethod(self, sel1: "viewDidLoad", sel2: "ks_viewDidLoad")
            }
        }
    }
    public func ks_viewDidLoad() {
        self.ks_viewDidLoad()
        let message = "[标题:\(self.title)],[类:\(self.className()))]"
        self.rx_deallocating.subscribeNext {
            if KSSystem.isSimulator {
                KSDebugStatusBar.post(message)
            }
            NSLog("dealloc vc = \(message)")
        }.addDisposableTo(self.ks_disposableBag)
    }
    
    public func ks_autoAdjustKeyBoard() {
        NSNotificationCenter.defaultCenter().rx_notification(UIKeyboardWillShowNotification).subscribeNext {
            [weak self]  notification in
            //进入后台触发某些通知,不响应
            if UIApplication.sharedApplication().applicationState == .Background {
                return
            }
            if let stongSelf = self, inputView = stongSelf.ks_findFirstResponder() {
                let userInfo: NSDictionary = notification.userInfo!
                let keyboardRect = userInfo[UIKeyboardFrameEndUserInfoKey]!.CGRectValue
                let window = UIApplication.sharedApplication().keyWindow
                let relatedView = stongSelf.ks_relatedViewFor(inputView)
                if let convertRect = relatedView.superview?.convertRect(relatedView.frame, toView: window) {
                    let diff = CGRectGetMaxY(convertRect) - CGRectGetMinY(keyboardRect) + 10
                    if diff > 0 {
                        let duration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as? NSTimeInterval ?? 0
                        UIView.animateWithDuration(duration, animations: {
                            var bounds = stongSelf.view.bounds
                            bounds.origin.y += diff
                            stongSelf.view.bounds = bounds
                        })
                    }
                }
            }
        }.addDisposableTo(self.ks_disposableBag)
        NSNotificationCenter.defaultCenter().rx_notification(UIKeyboardWillHideNotification).subscribeNext {
            [weak self] notification in
            //进入后台触发某些通知,不响应
            if UIApplication.sharedApplication().applicationState == .Background {
                return
            }
            if let stongSelf = self {
                let userInfo: NSDictionary = notification.userInfo!
                let duration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as? NSTimeInterval ?? 0
                UIView.animateWithDuration(duration, animations: {
                    let frame = stongSelf.view.frame
                    stongSelf.view.bounds = frame
                })
            }
        }.addDisposableTo(self.ks_disposableBag)
    }
}