//
//  NSObject.swift
//  PolyGe
//
//  Created by king on 15/6/27.
//  Copyright © 2015年 king. All rights reserved.
//

import UIKit
extension NSObject {
    class func className() -> String {
        return "\(self)".componentsSeparatedByString(".").last!
    }
    func className() -> String {
        return "\(self.dynamicType)".componentsSeparatedByString(".").last!
    }
    func topView() -> UIView {
        if isKindOfClass(UIView) {
            return self as! UIView
        }else if isKindOfClass(UIViewController) {
            return (self as! UIViewController).view
        }else{
            return UIWindow.topWindow()
        }
    }
    
}
