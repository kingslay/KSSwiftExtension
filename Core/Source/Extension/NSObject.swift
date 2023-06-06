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
        return NSStringFromClass(Base).componentsSeparatedByString(".").last!
    }

    static public func loadXib() -> UIView? {
        return loadXib(className())
    }
    static public func loadXib(name: String) -> UIView?{
        return NSBundle.mainBundle().loadNibNamed(name, owner: nil, options: nil).first as? UIView
    }
    public func className() -> String {
        return NSStringFromClass(self.base.dynamicType).componentsSeparatedByString(".").last!
    }
    public func topView() -> UIView {
        if self.base.isKindOfClass(UIView) {
            return self.base as! UIView
        }else if self.base.isKindOfClass(UIViewController) {
            return (self.base as! UIViewController).view
        }else{
            return Swifty<UIWindow>.topWindow()
        }
    }
    public func synchronized<T>(@noescape action: () -> T) -> T {
        objc_sync_enter(self.base)
        let result = action()
        objc_sync_exit(self.base)
        return result
    }
}
