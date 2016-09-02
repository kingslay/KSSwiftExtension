//
//  rulerView.swift
//  rulerSwift
//
//  Created by Albert on 16/6/4.
//  Copyright © 2016年 Albert. All rights reserved.
//

import UIKit
@objc protocol FSRulerDelegate {
    //声明方法
    @objc func ruler(_ rulerValue: CGFloat)
}

public class KSRulerView: UIView, UIScrollViewDelegate {

    weak var delegete: FSRulerDelegate?
    lazy public var rulerScrollView: KSRulerScrollView = {
        let scrollView = KSRulerScrollView(frame: self.bounds)
        scrollView.delegate = self
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    let DISTANCELEFTANDRIGHT :CGFloat = 8  //标尺左右距离
    let DISTANCEVALUE: CGFloat = 8 //刻度实际长度
    let DISTANCETOPANDBOTTOM: CGFloat = 20 //标尺上下距离
    var strokeColor = UIColor.redColor()
    var lineWidth:CGFloat = 1.0;
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

    public func showRulerScrollViewWithCount(_ count: NSInteger, beginValue: CGFloat, endValue: CGFloat) {
        rulerScrollView.rulerCount = count
        rulerScrollView.beginValue = beginValue
        rulerScrollView.endValue = endValue
        self.addSubview(rulerScrollView)
        rulerScrollView.drawRuler()
        self.drawline()
    }

    func drawline() {
        let pathLine = CGPathCreateMutable()
        let shapeLayerLine: CAShapeLayer = CAShapeLayer()
        shapeLayerLine.strokeColor = strokeColor.CGColor
        shapeLayerLine.lineWidth = lineWidth
        shapeLayerLine.lineCap = kCALineCapSquare
        CGPathMoveToPoint(pathLine, nil, 0, self.frame.size.height/2)
        CGPathAddLineToPoint(pathLine, nil, self.frame.size.width, self.frame.size.height/2)
        shapeLayerLine.path = pathLine
        self.layer.addSublayer(shapeLayerLine)
    }



    //MARK: ScrollView Delegete
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if let delegete = delegete {
            delegete.ruler(currentValue)
        }
    }

    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.animationRebound(scrollView)
    }

    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        self.animationRebound(scrollView)
    }

    func animationRebound(_ scrollView: UIScrollView) {
        
    }
    
}
