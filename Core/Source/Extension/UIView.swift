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
            return UIColor(cgColor: layer.borderColor!)
        }
        set {
            layer.borderColor = newValue.cgColor
        }
    }
    
    @IBInspectable public var onePx: Bool {
        get {
            return self.onePx
        }
        set {
            if (onePx == true){
                self.frame = CGRect(x: self.frame.origin.x, y: self.frame.origin.y, width: self.frame.size.width, height: 1 / UIScreen.main.scale)
            }
        }
    }
}
open class LayerContainerView: UIView {
    override open class var layerClass: Swift.AnyClass {
        return CAGradientLayer.self
    }
}
public struct KSDirection : OptionSet {
    public let rawValue: UInt
    public init(rawValue: UInt) {
        self.rawValue = rawValue
    }
    public static var top = KSDirection(rawValue: 1 << 0)
    public static var left = KSDirection(rawValue: 1 << 1)
    public static var bottom = KSDirection(rawValue: 1 << 2)
    public static var right = KSDirection(rawValue: 1 << 3)
    public static var all = [top,left,bottom,right]
}
extension Swifty where Base: UIView {
    /**
     Masks the view's layer to be in a cirle.
     */
    public func maskToCircle() {
        base.cornerRadius = base.frame.size.width / 2.0
    }

    public func showBorder(_ direction:KSDirection,margin:CGFloat=0,color:UIColor = UIColor.black,borderWidth:CGFloat = 1) {
        if direction.contains(.top) {
            let layer = CALayer()
            layer.frame = CGRect(x: margin,y: 0,width: base.frame.width-margin,height: borderWidth)
            layer.backgroundColor = color.cgColor
            base.layer.addSublayer(layer)
        }
        if direction.contains(.left) {
            let layer = CALayer()
            layer.frame = CGRect(x: 0,y: margin,width: borderWidth,height: base.frame.height-margin)
            layer.backgroundColor = color.cgColor
            base.layer.addSublayer(layer)
        }
        if direction.contains(.bottom) {
            let layer = CALayer()
            layer.frame = CGRect(x: margin,y: base.frame.height-borderWidth,width: base.frame.width-margin,height: borderWidth)
            layer.backgroundColor = color.cgColor
            base.layer.addSublayer(layer)
        }
        if direction.contains(.right) {
            let layer = CALayer()
            layer.frame = CGRect(x:base.frame.width-borderWidth,y: margin,width: borderWidth,height: base.frame.height-margin)
            layer.backgroundColor = color.cgColor
            base.layer.addSublayer(layer)
        }
    }

    public func viewController() -> UIViewController? {
        if let window = base as? UIWindow {
            return window.rootViewController
        }else{
            var next = base.next
            while next != nil {
                if let viewController = next as? UIViewController {
                    return viewController
                }
                next = next?.next
            }
            return nil
        }
    }
}

extension Swifty where Base: UIView {
    public var left: CGFloat {
        get {
            return base.frame.origin.x
        }
    }
    public func left(_ newValue: CGFloat) {
        var frame = base.frame
        if frame.origin.x != newValue {
            frame.origin.x = newValue
            base.frame = frame
        }
    }

    public var top: CGFloat {
        get {
            return base.frame.origin.y
        }
    }
    public func top(_ newValue: CGFloat) {
        var frame = base.frame
        if frame.origin.y != newValue {
            frame.origin.y = newValue
            base.frame = frame
        }
    }

    public var right: CGFloat {
        get {
            return base.frame.origin.x + base.frame.width
        }
    }
    public func right(_ newValue: CGFloat) {
        var frame = base.frame
        let newRight = newValue - base.frame.width
        if frame.origin.x != newRight {
            frame.origin.x = newRight
            base.frame = frame
        }
    }

    public var bottom: CGFloat {
        get {
            return base.frame.origin.y + base.frame.height
        }
    }
    public func bottom(_ newValue: CGFloat) {
        var frame = base.frame
        let newBottom = newValue - base.frame.height
        if frame.origin.y != newBottom {
            frame.origin.y = newBottom
            base.frame = frame
        }
    }

    public var centerX: CGFloat {
        get {
            return base.center.x
        }
        set {
            var center = base.center
            if center.x != newValue {
                center.x = newValue
                base.center = center
            }
        }
    }
    public func centerX(_ newValue: CGFloat) {
        var center = base.center
        if center.x != newValue {
            center.x = newValue
            base.center = center
        }

    }

    public var centerY: CGFloat {
        get {
            return base.center.y
        }
    }
    public func centerY(_ newValue: CGFloat) {
        var center = base.center
        if center.y != newValue {
            center.y = newValue
            base.center = center
        }
    }

    public var width: CGFloat {
        get {
            return base.frame.width
        }
    }
    public func width(_ newValue: CGFloat) {
        var frame = base.frame
        if frame.width != newValue {
            frame.size.width = newValue
            base.frame = frame
        }
    }
    public var height: CGFloat {
        get {
            return base.frame.height
        }
    }
    public func height(_ newValue: CGFloat) {
        var frame = base.frame
        if frame.height != newValue {
            frame.size.height = newValue
            base.frame = frame
        }
    }

    public var origin: CGPoint {
        get {
            return base.frame.origin
        }
    }
    public func origin(_ newValue: CGPoint) {
        var frame = base.frame
        if frame.origin != newValue {
            frame.origin = newValue
            base.frame = frame
        }
    }

    public var size: CGSize {
        get {
            return base.frame.size
        }
    }
    public func size(_ newValue: CGSize) {
        var frame = base.frame
        if frame.size != newValue {
            frame.size = newValue
            base.frame = frame
        }
    }
}
extension Swifty where Base: UIView {
    var widthConstraint: NSLayoutConstraint? {
        get {
            for constraint in base.constraints {
                //防止返回NSContentSizeLayoutConstraint
                if constraint.isMember(of: NSLayoutConstraint.self) && constraint.firstAttribute == .width {
                    return constraint
                }
            }
            return nil
        }
    }
    var heightConstraint: NSLayoutConstraint? {
        get {
            for constraint in base.constraints {
                //防止返回NSContentSizeLayoutConstraint
                if constraint.isMember(of: NSLayoutConstraint.self) && constraint.firstAttribute == .height {
                    return constraint
                }
            }
            return nil
        }
    }
    var rightConstraint: NSLayoutConstraint? {
        get {
            if let constraints = base.superview?.constraints {
                for constraint in base.constraints {
                    if constraint.firstItem === base && constraint.firstAttribute == .right {
                        return constraint
                    }
                }
            }
            return nil
        }
    }
    var leftConstraint: NSLayoutConstraint? {
        get {
            if let constraints = base.superview?.constraints {
                for constraint in base.constraints {
                    if constraint.firstItem === base && constraint.firstAttribute == .left {
                        return constraint
                    }
                }
            }
            return nil
        }
    }
    var safeTopAnchor: NSLayoutYAxisAnchor {
        if #available(iOS 11.0, *) {
            return base.safeAreaLayoutGuide.topAnchor
        } else {
            return base.topAnchor
        }
    }

    var safeLeftAnchor: NSLayoutXAxisAnchor {
        if #available(iOS 11.0, *){
            return base.safeAreaLayoutGuide.leftAnchor
        }else {
            return base.leftAnchor
        }
    }

    var safeRightAnchor: NSLayoutXAxisAnchor {
        if #available(iOS 11.0, *){
            return base.safeAreaLayoutGuide.rightAnchor
        }else {
            return base.rightAnchor
        }
    }

    var safeBottomAnchor: NSLayoutYAxisAnchor {
        if #available(iOS 11.0, *) {
            return base.safeAreaLayoutGuide.bottomAnchor
        } else {
            return base.bottomAnchor
        }
    }
}
