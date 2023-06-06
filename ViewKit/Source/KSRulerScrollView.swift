//
//  FSRulerScrollView.swift
//  rulerSwift
//
//  Created by Albert on 16/6/4.
//  Copyright © 2016年 Albert. All rights reserved.
//

import UIKit

public class KSRulerScrollView: UIScrollView {
    public var ruleLength: CGFloat = 20 //刻度实际长度
    public var distance: CGFloat = 8.0 //标尺上下距离
    public var stroke1Color = UIColor.lightGrayColor()
    public var stroke2Color = UIColor.lightGrayColor()
    var rulerCount = 1
    var beginValue: CGFloat = 0.0
    var endValue: CGFloat = 0.0
    var rulerAverage: CGFloat = 0.0
    func drawRuler() {
        let pathRef1 = CGPathCreateMutable()
        let pathRef2 = CGPathCreateMutable()
        
        let shapeLayer1 = CAShapeLayer()
        shapeLayer1.strokeColor = stroke1Color.CGColor
        shapeLayer1.fillColor = UIColor.clearColor().CGColor
        shapeLayer1.lineWidth = 1
        shapeLayer1.lineCap = kCALineCapButt
        
        let shapeLayer2 = CAShapeLayer()
        shapeLayer2.strokeColor = stroke2Color.CGColor
        shapeLayer2.fillColor = UIColor.clearColor().CGColor
        shapeLayer2.lineWidth = 1
        shapeLayer2.lineCap = kCALineCapButt
        rulerAverage = (endValue - beginValue)/CGFloat(rulerCount)
        for index in 0...rulerCount {
            let y = distance * CGFloat(index)
            if index % 10 == 0 {
                CGPathMoveToPoint(pathRef2, nil, 0, y)
                CGPathAddLineToPoint(pathRef2, nil, ruleLength, y)
                CGPathMoveToPoint(pathRef2, nil, self.frame.size.width, y)
                CGPathAddLineToPoint(pathRef2, nil, self.frame.size.width-ruleLength, y)
                let rule: UILabel = UILabel.init()
                rule.textColor = stroke2Color
                rule.text = "\(CGFloat(index)*rulerAverage + beginValue)"
                rule.sizeToFit()
                rule.center = CGPoint(x: self.center.x, y: y)
                self.addSubview(rule)
            }
            else if index % 5 == 0 {
                CGPathMoveToPoint(pathRef1, nil, 0, y)
                CGPathAddLineToPoint(pathRef1, nil, ruleLength*3/4, y)
                CGPathMoveToPoint(pathRef1, nil, self.frame.size.width, y)
                CGPathAddLineToPoint(pathRef1, nil, self.frame.size.width-ruleLength*3/4, y)
            }
            else {
                CGPathMoveToPoint(pathRef1, nil, 0, y)
                CGPathAddLineToPoint(pathRef1, nil, ruleLength/2, y)
                CGPathMoveToPoint(pathRef1, nil, self.frame.size.width, y)
                CGPathAddLineToPoint(pathRef1, nil, self.frame.size.width-ruleLength/2, y)
            }
        }
        shapeLayer1.path = pathRef1
        shapeLayer2.path = pathRef2
        self.layer.addSublayer(shapeLayer1)
        self.layer.addSublayer(shapeLayer2)
        self.contentInset = UIEdgeInsets(top: distance, left: 0, bottom: distance, right: 0)
        self.contentSize = CGSize(width: self.frame.size.width, height: CGFloat(self.rulerCount+1)*distance)
    }

}
