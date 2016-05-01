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
    
    /**
     Masks the view's layer to be in a cirle.
     */
    public func maskToCircle() {
        cornerRadius = frame.size.width / 2.0
    }
    
    public func ks_viewController() -> UIViewController? {
        if let window = self as? UIWindow {
            return window.rootViewController
        }else{
            var next = self.nextResponder()
            while next != nil {
                if let viewController = next as? UIViewController {
                    return viewController
                }
                next = next?.nextResponder()
            }
            return nil
        }
    }
    class public func ks_loadXib() -> UIView? {
        return UIView.ks_loadXib(self.className())
    }
    class public func ks_loadXib(name: String) -> UIView?{
        return NSBundle.mainBundle().loadNibNamed(name, owner: nil, options: nil).first as? UIView
    }
}

extension UIView {
    public var ks_left: CGFloat {
        get {
            return self.frame.origin.x
        }
        set {
            var frame = self.frame
            if frame.origin.x != newValue {
                frame.origin.x = newValue
                self.frame = frame
            }
        }
    }
    
    public var ks_top: CGFloat {
        get {
            return self.frame.origin.y
        }
        set {
            var frame = self.frame
            if frame.origin.y != newValue {
                frame.origin.y = newValue
                self.frame = frame
            }
        }
    }
    
    public var ks_right: CGFloat {
        get {
            return self.frame.origin.x + self.frame.width
        }
        set {
            var frame = self.frame
            let newRight = newValue - self.frame.width
            if frame.origin.x != newRight {
                frame.origin.x = newRight
                self.frame = frame
            }
        }
    }
    
    public var ks_bottom: CGFloat {
        get {
            return self.frame.origin.y + self.frame.height
        }
        set {
            var frame = self.frame
            let newBottom = newValue - self.frame.height
            if frame.origin.y != newBottom {
                frame.origin.y = newBottom
                self.frame = frame
            }
        }
    }
    
    public var ks_centerX: CGFloat {
        get {
            return self.center.x
        }
        set {
            var center = self.center
            if center.x != newValue {
                center.x = newValue
                self.center = center
            }
        }
    }
    
    public var ks_centerY: CGFloat {
        get {
            return self.center.y
        }
        set {
            var center = self.center
            if center.y != newValue {
                center.y = newValue
                self.center = center
            }
        }
    }
    
    public var ks_width: CGFloat {
        get {
            return self.frame.width
        }
        set {
            var frame = self.frame
            if frame.width != newValue {
                frame.size.width = newValue
                self.frame = frame
            }
        }
    }
    public var ks_height: CGFloat {
        get {
            return self.frame.height
        }
        set {
            var frame = self.frame
            if frame.height != newValue {
                frame.size.height = newValue
                self.frame = frame
            }
        }
    }
    
    public var ks_origin: CGPoint {
        get {
            return self.frame.origin
        }
        set {
            var frame = self.frame
            if frame.origin != newValue {
                frame.origin = newValue
                self.frame = frame
            }
        }
    }
    
    public var ks_size: CGSize {
        get {
            return self.frame.size
        }
        set {
            var frame = self.frame
            if frame.size != newValue {
                frame.size = newValue
                self.frame = frame
            }
        }
    }
}