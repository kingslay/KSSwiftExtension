//
//  FSRulerScrollView.swift
//  rulerSwift
//
//  Created by Albert on 16/6/4.
//  Copyright © 2016年 Albert. All rights reserved.
//

import UIKit

open class KSRulerScrollView: UIScrollView {
    open var ruleLength: CGFloat = 20 //刻度实际长度
    open var distance: CGFloat = 8.0 //标尺上下距离
    open var stroke1Color = UIColor.lightGray
    open var stroke2Color = UIColor.lightGray
    var rulerCount = 1
    var beginValue: CGFloat = 0.0
    var endValue: CGFloat = 0.0
    var rulerAverage: CGFloat = 0.0
    func drawRuler() {
        let pathRef1 = CGMutablePath()
        let pathRef2 = CGMutablePath()
        
        let shapeLayer1 = CAShapeLayer()
        shapeLayer1.strokeColor = stroke1Color.cgColor
        shapeLayer1.fillColor = UIColor.clear.cgColor
        shapeLayer1.lineWidth = 1
        shapeLayer1.lineCap = kCALineCapButt
        
        let shapeLayer2 = CAShapeLayer()
        shapeLayer2.strokeColor = stroke2Color.cgColor
        shapeLayer2.fillColor = UIColor.clear.cgColor
        shapeLayer2.lineWidth = 1
        shapeLayer2.lineCap = kCALineCapButt
        rulerAverage = (endValue - beginValue)/CGFloat(rulerCount)
        for index in 0...rulerCount {
            let y = distance * CGFloat(index)
            if index % 10 == 0 {
                pathRef2.move(to: CGPoint(x:0,y:y))
                pathRef2.addLine(to:CGPoint(x:ruleLength, y:y))
                pathRef2.move(to: CGPoint(x:self.frame.size.width,y:y))
                pathRef2.addLine(to: CGPoint(x:self.frame.size.width-ruleLength, y:y))
                let rule: UILabel = UILabel.init()
                rule.textColor = stroke2Color
                rule.text = "\(CGFloat(index)*rulerAverage + beginValue)"
                rule.sizeToFit()
                rule.center = CGPoint(x: self.center.x, y: y)
                self.addSubview(rule)
            } else if index % 5 == 0 {
                pathRef1.move(to:CGPoint(x:0,y:y))
                pathRef1.addLine(to: CGPoint(x:ruleLength*3/4, y:y))
                pathRef1.move(to: CGPoint(x:self.frame.size.width,y:y))
                pathRef1.addLine(to: CGPoint(x:self.frame.size.width-ruleLength*3/4, y:y))
            } else {
                pathRef1.move(to: CGPoint(x:0,y:y))
                pathRef1.addLine(to: CGPoint(x:ruleLength/2, y:y))
                pathRef1.move(to: CGPoint(x:self.frame.size.width,y:y))
                pathRef1.addLine(to: CGPoint(x:self.frame.size.width-ruleLength/2, y:y))
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
