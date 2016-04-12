//
//  NSObject.swift
//  PolyGe
//
//  Created by king on 15/6/27.
//  Copyright © 2015年 king. All rights reserved.
//

import UIKit
import RxSwift
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
    
    public var ks_disposableBag : DisposeBag {
        if let disposableBag = objc_getAssociatedObject(self, &disposableBagAssociationKey) as? DisposeBag {
            return disposableBag
        }
        let disposableBag = DisposeBag()
        objc_setAssociatedObject(self, &disposableBagAssociationKey, disposableBag, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        return disposableBag
    }
}
