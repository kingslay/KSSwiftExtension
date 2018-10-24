//
//  UIApplication.swift
//  Pods
//
//  Created by kintan on 2017/5/27.
//
//

import Foundation
import UIKit

extension UIApplication {
    private static let runOnce: Void = {
        if _isDebugAssertConfiguration() {
            KS.swizzleInstanceMethod(NSClassFromString("UIViewController")!, sel1: "motionBegan:withEvent:", sel2: "ksmotionBegan:with:")
            NotificationCenter.default.addObserver(forName: UIApplication.didFinishLaunchingNotification, object: nil, queue: nil) { _ in
                UIApplication.shared.applicationSupportsShakeToEdit = true
            }
        }
    }()

//    override open var next: UIResponder? {
//        // Called before applicationDidFinishLaunching
//        UIApplication.runOnce
//        return super.next
//    }
}
