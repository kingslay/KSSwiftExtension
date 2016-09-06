//
//  UIView.swift
//  PolyGe
//
//  Created by king on 15/4/19.
//  Copyright (c) 2015年 king. All rights reserved.
//
import UIKit

public extension UIView {
    @IBInspectable public var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    
    @IBInspectable public var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable public var borderColor: UIColor {
        get {
            return UIColor(CGColor: layer.borderColor!)
        }
        set {
            layer.borderColor = newValue.CGColor
        }
    }
    
    @IBInspectable public var onePx: Bool {
        get {
            return self.onePx
        }
        set {
            if (onePx == true){
                self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, 1 / UIScreen.mainScreen().scale)
            }
        }
    }
}
//extension UIView: KSCompatible { }
extension Swifty where Base: UIView {
    /**
     Masks the view's layer to be in a cirle.
     */
    public func maskToCircle() {
        self.base.cornerRadius = self.base.frame.size.width / 2.0
    }
    
    public func viewController() -> UIViewController? {
        if let window = self.base as? UIWindow {
            return window.rootViewController
        }else{
            var next = self.base.nextResponder()
            while next != nil {
                if let viewController = next as? UIViewController {
                    return viewController
                }
                next = next?.nextResponder()
            }
            return nil
        }
    }
}

extension Swifty where Base: UIView {
    public var left: CGFloat {
        get {
            return self.base.frame.origin.x
        }
    }
    public func left(newValue: CGFloat) {
        var frame = self.base.frame
        if frame.origin.x != newValue {
            frame.origin.x = newValue
            self.base.frame = frame
        }
    }

    public var top: CGFloat {
        get {
            return self.base.frame.origin.y
        }
    }
    public func top(newValue: CGFloat) {
        var frame = self.base.frame
        if frame.origin.y != newValue {
            frame.origin.y = newValue
            self.base.frame = frame
        }
    }

    public var right: CGFloat {
        get {
            return self.base.frame.origin.x + self.base.frame.width
        }
    }
    public func right(newValue: CGFloat) {
        var frame = self.base.frame
        let newRight = newValue - self.base.frame.width
        if frame.origin.x != newRight {
            frame.origin.x = newRight
            self.base.frame = frame
        }
    }

    public var bottom: CGFloat {
        get {
            return self.base.frame.origin.y + self.base.frame.height
        }
    }
    public func bottom(newValue: CGFloat) {
        var frame = self.base.frame
        let newBottom = newValue - self.base.frame.height
        if frame.origin.y != newBottom {
            frame.origin.y = newBottom
            self.base.frame = frame
        }
    }

    public var centerX: CGFloat {
        get {
            return self.base.center.x
        }
        set {
            var center = self.base.center
            if center.x != newValue {
                center.x = newValue
                self.base.center = center
            }
        }
    }
    public func centerX(newValue: CGFloat) {
        var center = self.base.center
        if center.x != newValue {
            center.x = newValue
            self.base.center = center
        }

    }

    public var centerY: CGFloat {
        get {
            return self.base.center.y
        }
    }
    public func centerY(newValue: CGFloat) {
        var center = self.base.center
        if center.y != newValue {
            center.y = newValue
            self.base.center = center
        }
    }

    public var width: CGFloat {
        get {
            return self.base.frame.width
        }
    }
    public func width(newValue: CGFloat) {
        var frame = self.base.frame
        if frame.width != newValue {
            frame.size.width = newValue
            self.base.frame = frame
        }
    }
    public var height: CGFloat {
        get {
            return self.base.frame.height
        }
    }
    public func height(newValue: CGFloat) {
        var frame = self.base.frame
        if frame.height != newValue {
            frame.size.height = newValue
            self.base.frame = frame
        }
    }

    public var origin: CGPoint {
        get {
            return self.base.frame.origin
        }
    }
    public func origin(newValue: CGPoint) {
        var frame = self.base.frame
        if frame.origin != newValue {
            frame.origin = newValue
            self.base.frame = frame
        }
    }

    public var size: CGSize {
        get {
            return self.base.frame.size
        }
    }
    public func size(newValue: CGSize) {
        var frame = self.base.frame
        if frame.size != newValue {
            frame.size = newValue
            self.base.frame = frame
        }
    }
}