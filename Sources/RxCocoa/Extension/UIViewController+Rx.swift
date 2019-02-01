//
//  UIViewController.swift
//  PolyGe
//
//  Created by king on 15/6/22.
//  Copyright © 2015年 king. All rights reserved.
//

import RxCocoa
import UIKit
public extension UIViewController {
    public func ksviewDidLoad() {
        ksviewDidLoad()
        let message = "[标题:\(String(describing: title))],[类:\(ks.className()))]"
        rx.deallocating.subscribe(onNext: {
            if KS.isSimulator {
                KSDebugStatusBar.post(message)
            }
            NSLog("dealloc vc = \(message)")
        }).disposed(by: ks.disposableBag)
    }
}

extension Swifty where Base: UIViewController {
    public func autoAdjustKeyBoard() {
        NotificationCenter.default.rx.notification(UIResponder.keyboardWillShowNotification).subscribe(onNext: {
            [weak controller = self.base] notification in
            // 进入后台触发某些通知,不响应
            if UIApplication.shared.applicationState == .background {
                return
            }
            if let controller = controller, let inputView = controller.ks.findFirstResponder() {
                let userInfo = notification.userInfo! as NSDictionary
                let keyboardRect = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
                let window = UIApplication.shared.keyWindow
                let relatedView = controller.relatedViewFor(inputView)
                if let convertRect = relatedView.superview?.convert(relatedView.frame, to: window) {
                    let diff = convertRect.maxY - keyboardRect.minY + 10
                    if diff > 0 {
                        let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval ?? 0
                        UIView.animate(withDuration: duration) {
                            var bounds = controller.view.bounds
                            bounds.origin.y += diff
                            controller.view.bounds = bounds
                        }
                    }
                }
            }
        }).disposed(by: disposableBag)
        NotificationCenter.default.rx.notification(UIResponder.keyboardWillHideNotification).subscribe(onNext: {
            [weak controller = self.base] notification in
            // 进入后台触发某些通知,不响应
            if UIApplication.shared.applicationState == .background {
                return
            }
            if let controller = controller {
                let userInfo = notification.userInfo! as NSDictionary
                let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval ?? 0
                UIView.animate(withDuration: duration) {
                    let frame = controller.view.frame
                    controller.view.bounds = frame
                }
            }
        }).disposed(by: disposableBag)
    }
}
