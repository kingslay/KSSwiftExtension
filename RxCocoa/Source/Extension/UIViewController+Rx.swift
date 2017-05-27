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
    private static let runOnce: Void = {
        if _isDebugAssertConfiguration() {
            KS.swizzleInstanceMethod(NSClassFromString("UIViewController")!, sel1: "motionBegan:withEvent:", sel2: "ksmotionBegan:with:")
            NotificationCenter.default.addObserver(forName: NSNotification.Name.UIApplicationDidFinishLaunching, object: nil, queue: nil){ _ in
                UIApplication.shared.applicationSupportsShakeToEdit = true
            }
        }
    }()
    override open var next: UIResponder? {
        UIViewController.runOnce
        return super.next
    }
    public func ksviewDidLoad() {
        self.ksviewDidLoad()
        let message = "[标题:\(String(describing: self.title))],[类:\(self.ks.className()))]"
        self.rx.deallocating.subscribe(onNext: {
            if KS.isSimulator {
                KSDebugStatusBar.post(message)
            }
            NSLog("dealloc vc = \(message)")
        }).addDisposableTo(self.ks.disposableBag)
    }
}
extension Swifty where Base: UIViewController {
    public func autoAdjustKeyBoard() {
        NotificationCenter.default.rx.notification(NSNotification.Name.UIKeyboardWillShow).subscribe(onNext: {
            [weak controller = self.base]  notification in
            //进入后台触发某些通知,不响应
            if UIApplication.shared.applicationState == .background {
                return
            }
            if let controller = controller, let inputView = controller.ks.findFirstResponder() {
                let userInfo = notification.userInfo! as NSDictionary
                let keyboardRect = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
                let window = UIApplication.shared.keyWindow
                let relatedView = controller.relatedViewFor(inputView)
                if let convertRect = relatedView.superview?.convert(relatedView.frame, to: window) {
                    let diff = convertRect.maxY - keyboardRect.minY + 10
                    if diff > 0 {
                        let duration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as? TimeInterval ?? 0
                        UIView.animate(withDuration: duration, animations: {
                            var bounds = controller.view.bounds
                            bounds.origin.y += diff
                            controller.view.bounds = bounds
                        })
                    }
                }
            }
            }).addDisposableTo(self.disposableBag)
        NotificationCenter.default.rx.notification(NSNotification.Name.UIKeyboardWillHide).subscribe(onNext: {
            [weak controller = self.base] notification in
            //进入后台触发某些通知,不响应
            if UIApplication.shared.applicationState == .background {
                return
            }
            if let controller = controller {
                let userInfo = notification.userInfo! as NSDictionary
                let duration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as? TimeInterval ?? 0
                UIView.animate(withDuration: duration, animations: {
                    let frame = controller.view.frame
                    controller.view.bounds = frame
                })
            }
            }).addDisposableTo(self.disposableBag)
    }
}
