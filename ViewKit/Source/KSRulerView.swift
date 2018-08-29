//
//  rulerView.swift
//  rulerSwift
//
//  Created by Albert on 16/6/4.
//  Copyright © 2016年 Albert. All rights reserved.
//

import UIKit

@objc public protocol KSRulerDelegate {
    // 声明方法
    func ruler(_ value: CGFloat)
}

open class KSRulerView: UIView, UIScrollViewDelegate {
    open weak var delegete: KSRulerDelegate?
    open lazy var rulerScrollView: KSRulerScrollView = {
        let scrollView = KSRulerScrollView()
        scrollView.delegate = self
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()

    open var strokeColor = UIColor.red
    open var lineWidth: CGFloat = 1.0
    open var currentValue: CGFloat {
        get {
            let offSetY = rulerScrollView.contentOffset.y + rulerScrollView.frame.size.height / 2
            return rulerScrollView.beginValue + offSetY / rulerScrollView.distance * rulerScrollView.rulerAverage
        }
        set {
            let offSetY = (newValue - rulerScrollView.beginValue) / rulerScrollView.rulerAverage * rulerScrollView.distance - rulerScrollView.frame.size.height / 2
            rulerScrollView.contentOffset.y = offSetY
        }
    }

    open func showRulerScrollViewWithCount(_ count: NSInteger, beginValue: CGFloat, endValue: CGFloat) {
        rulerScrollView.rulerCount = count
        rulerScrollView.beginValue = beginValue
        rulerScrollView.endValue = endValue
        addSubview(rulerScrollView)
        rulerScrollView.frame = bounds
        rulerScrollView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        rulerScrollView.drawRuler()
        drawline()
    }

    func drawline() {
        let shapeLayerLine: CAShapeLayer = CAShapeLayer()
        shapeLayerLine.fillColor = UIColor.clear.cgColor
        shapeLayerLine.strokeColor = strokeColor.cgColor
        shapeLayerLine.lineWidth = lineWidth
//        shapeLayerLine.lineDashPattern = [8,12]
        shapeLayerLine.lineCap = kCALineCapRound
        shapeLayerLine.lineJoin = kCALineJoinRound
        let path = UIBezierPath(rect: CGRect(x: 0, y: frame.size.height / 2, width: frame.width, height: 0))
        shapeLayerLine.path = path.cgPath
        layer.addSublayer(shapeLayerLine)
    }

    // MARK: ScrollView Delegete

    open func scrollViewDidScroll(_: UIScrollView) {
        if let delegete = delegete {
            delegete.ruler(currentValue)
        }
    }

    open func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        animationRebound(scrollView)
    }

    open func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate _: Bool) {
        animationRebound(scrollView)
    }

    func animationRebound(_: UIScrollView) {}
}
