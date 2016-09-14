//
//  UIViewController.swift
//  PolyGe
//
//  Created by king on 15/6/22.
//  Copyright © 2015年 king. All rights reserved.
//

import UIKit
import RxCocoa
public extension UIViewController {
//    #if DEBUG
//    #else
//    #endif
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
                KS.swizzleInstanceMethod(self, sel1: "viewDidLoad", sel2: "ksviewDidLoad")
            }
        }
    }
    public func ksviewDidLoad() {
        self.ksviewDidLoad()
        let message = "[标题:\(self.title)],[类:\(self.ks.className()))]"
        self.rx_deallocating.subscribeNext {
            if KS.isSimulator {
                KSDebugStatusBar.post(message)
            }
            NSLog("dealloc vc = \(message)")
        }.addDisposableTo(self.ks.disposableBag)
    }
}
extension Swifty where Base: UIViewController {
    public func autoAdjustKeyBoard() {
        NSNotificationCenter.defaultCenter().rx_notification(UIKeyboardWillShowNotification).subscribeNext {
            [weak controller = self.base]  notification in
            //进入后台触发某些通知,不响应
            if UIApplication.sharedApplication().applicationState == .Background {
                return
            }
            if let controller = controller as? UIViewController, inputView = controller.ks.findFirstResponder() {
                let userInfo: NSDictionary = notification.userInfo!
                let keyboardRect = userInfo[UIKeyboardFrameEndUserInfoKey]!.CGRectValue
                let window = UIApplication.sharedApplication().keyWindow
                let relatedView = controller.relatedViewFor(inputView)
                if let convertRect = relatedView.superview?.convertRect(relatedView.frame, toView: window) {
                    let diff = CGRectGetMaxY(convertRect) - CGRectGetMinY(keyboardRect) + 10
                    if diff > 0 {
                        let duration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as? NSTimeInterval ?? 0
                        UIView.animateWithDuration(duration, animations: {
                            var bounds = controller.view.bounds
                            bounds.origin.y += diff
                            controller.view.bounds = bounds
                        })
                    }
                }
            }
            }.addDisposableTo(self.disposableBag)
        NSNotificationCenter.defaultCenter().rx_notification(UIKeyboardWillHideNotification).subscribeNext {
            [weak controller = self.base] notification in
            //进入后台触发某些通知,不响应
            if UIApplication.sharedApplication().applicationState == .Background {
                return
            }
            if let controller = controller {
                let userInfo: NSDictionary = notification.userInfo!
                let duration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as? NSTimeInterval ?? 0
                UIView.animateWithDuration(duration, animations: {
                    let frame = controller.view.frame
                    controller.view.bounds = frame
                })
            }
            }.addDisposableTo(self.disposableBag)
    }
}