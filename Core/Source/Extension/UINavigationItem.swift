//
//  UINavigationItem.swift
//  Pods
//
//  Created by king on 16/9/8.
//
//

import Foundation
private var backBarButtonItemAssociationKey: UInt8 = 0
public extension UINavigationItem {
    open override static func initialize() {
        struct Static {
            static var token: Int = 0
        }
        // 确保不是子类
        if self !== UINavigationItem.self {
            return
        }
        dispatch_once(&Static.token) {
            KS.swizzleInstanceMethod(self, sel1: "backBarButtonItem", sel2: "ksbackBarbuttonItem")
        }
    }
    public func ksbackBarbuttonItem() -> UIBarButtonItem? {
        var item = self.ksbackBarbuttonItem()
        if item == nil {
            item = objc_getAssociatedObject(self, &backBarButtonItemAssociationKey) as? UIBarButtonItem
            if (item == nil) {
                item = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
            }
        }
        return item
    }
}
