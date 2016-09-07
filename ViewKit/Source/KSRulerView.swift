//
//  rulerView.swift
//  rulerSwift
//
//  Created by Albert on 16/6/4.
//  Copyright © 2016年 Albert. All rights reserved.
//

import UIKit

@objc public protocol KSRulerDelegate {
    //声明方法
    func ruler(value: CGFloat)
}

public class KSRulerView: UIView, UIScrollViewDelegate {

    weak public var delegete: KSRulerDelegate?
    lazy public var rulerScrollView: KSRulerScrollView = {
        let scrollView = KSRulerScrollView()
        scrollView.delegate = self
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    public var strokeColor = UIColor.redColor()
    public var lineWidth:CGFloat = 1.0;
    public var currentValue: CGFloat {
        get {
            let offSetY = rulerScrollView.contentOffset.y + rulerScrollView.frame.size.height / 2
            return  rulerScrollView.beginValue + offSetY / rulerScrollView.distance * rulerScrollView.rulerAverage
        }
        set {
            let offSetY = (newValue - rulerScrollView.beginValue)/rulerScrollView.rulerAverage * rulerScrollView.distance - rulerScrollView.frame.size.height / 2
            rulerScrollView.contentOffset.y = offSetY
        }
    }

    public func showRulerScrollViewWithCount(count: NSInteger, beginValue: CGFloat, endValue: CGFloat) {
        rulerScrollView.rulerCount = count
        rulerScrollView.beginValue = beginValue
        rulerScrollView.endValue = endValue
        self.addSubview(rulerScrollView)
        rulerScrollView.frame = self.bounds
        rulerScrollView.autoresizingMask = [.FlexibleHeight,.FlexibleWidth]
        rulerScrollView.drawRuler()
        self.drawline()
    }

    func drawline() {
        let shapeLayerLine: CAShapeLayer = CAShapeLayer()
        shapeLayerLine.fillColor = UIColor.clearColor().CGColor
        shapeLayerLine.strokeColor = strokeColor.CGColor
        shapeLayerLine.lineWidth = lineWidth
//        shapeLayerLine.lineDashPattern = [8,12]
        shapeLayerLine.lineCap = kCALineCapRound
        shapeLayerLine.lineJoin = kCALineJoinRound
        let path = UIBezierPath(rect: CGRect(x: 0, y: self.frame.size.height/2, width: self.frame.width, height: 0))
        shapeLayerLine.path = path.CGPath
        self.layer.addSublayer(shapeLayerLine)
    }
    //MARK: ScrollView Delegete
    public func scrollViewDidScroll(scrollView: UIScrollView) {
        if let delegete = delegete {
            delegete.ruler(currentValue)
        }
    }

    public func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        self.animationRebound(scrollView)
    }

    public func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        self.animationRebound(scrollView)
    }

    func animationRebound(scrollView: UIScrollView) {
        
    }
    
}
