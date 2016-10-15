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
        return NSStringFromClass(Base).components(separatedBy: ".").last!
    }

    static public func loadXib() -> UIView? {
        return loadXib(className())
    }
    static public func loadXib(_ name: String) -> UIView?{
        return Bundle.main.loadNibNamed(name, owner: nil, options: nil)?.first as? UIView
    }
    public func className() -> String {
        return NSStringFromClass(type(of: self.base)).components(separatedBy: ".").last!
    }
    public func topView() -> UIView {
        if self.base.isKind(of: UIView.self) {
            return self.base as! UIView
        }else if self.base.isKind(of: UIViewController.self) {
            return (self.base as! UIViewController).view
        }else{
            return UIWindow.ks.topWindow()
        }
    }
    public func synchronized<T>(_ action: () -> T) -> T {
        objc_sync_enter(self.base)
        let result = action()
        objc_sync_exit(self.base)
        return result
    }
}
