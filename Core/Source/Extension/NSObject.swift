//
//  NSObject.swift
//  PolyGe
//
//  Created by king on 15/6/27.
//  Copyright © 2015年 king. All rights reserved.
//

import UIKit
private var disposableBagAssociationKey: UInt8 = 0
extension NSObject {
    public static func className() -> String {
        return NSStringFromClass(self).componentsSeparatedByString(".").last!
    }
    public func className() -> String {
        return NSStringFromClass(self.dynamicType).componentsSeparatedByString(".").last!
    }
    public func ks_topView() -> UIView {
        if isKindOfClass(UIView) {
            return self as! UIView
        }else if isKindOfClass(UIViewController) {
            return (self as! UIViewController).view
        }else{
            return UIWindow.ks_topWindow()
        }
    }
    public func rx_synchronized<T>(@noescape action: () -> T) -> T {
        objc_sync_enter(self)
        let result = action()
        objc_sync_exit(self)
        return result
    }
}
