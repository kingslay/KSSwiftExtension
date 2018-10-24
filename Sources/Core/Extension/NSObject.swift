//
//  NSObject.swift
//  PolyGe
//
//  Created by king on 15/6/27.
//  Copyright © 2015年 king. All rights reserved.
//

import UIKit
private var disposableBagAssociationKey: UInt8 = 0
extension Swifty where Base: NSObject {
    public static func className() -> String {
        return NSStringFromClass(Base.self).components(separatedBy: ".").last!
    }

    public static func loadXib() -> UIView? {
        return loadXib(className())
    }

    public static func loadXib(_ name: String) -> UIView? {
        return Bundle.main.loadNibNamed(name, owner: nil, options: nil)?.first as? UIView
    }

    public func className() -> String {
        return NSStringFromClass(type(of: base)).components(separatedBy: ".").last!
    }

    public func topView() -> UIView {
        if base.isKind(of: UIView.self) {
            return base as! UIView
        } else if base.isKind(of: UIViewController.self) {
            return (base as! UIViewController).view
        } else {
            return UIWindow.ks.topWindow()
        }
    }

    public func synchronized<T>(_ action: () -> T) -> T {
        objc_sync_enter(base)
        let result = action()
        objc_sync_exit(base)
        return result
    }
}
