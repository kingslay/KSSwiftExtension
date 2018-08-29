//
//  UIImage.swift
//  PolyGe
//
//  Created by king on 15/4/19.
//  Copyright (c) 2015年 king. All rights reserved.
//

import UIKit
extension Swifty where Base: UIImage {
    public func transformtoScale(_ scale: CGFloat) -> UIImage {
        return UIImage(cgImage: base.cgImage!, scale: scale, orientation: UIImageOrientation.up)

//        // 创建一个bitmap的context
//        UIGraphicsBeginImageContext(size)
//        // 绘制改变大小的图片
//        drawInRect(CGRectMake(0, 0, size.width, size.height))
//        // 从当前context中创建一个改变大小后的图片
//        let transformedImg=UIGraphicsGetImageFromCurrentImageContext()
//        // 使当前的context出堆栈
//        UIGraphicsEndImageContext()
//        // 返回新的改变大小后的图片
//        return transformedImg
    }

    public func normalizedImage() -> UIImage {
        var returnMe = base
        let width = KS.SCREEN_WIDTH * KS.SCREEN_SCALE
        if returnMe.size.width > width {
            returnMe = UIImage.ks.image(returnMe, scaledToWidth: width) as! Base
        }
        return returnMe
    }

    public static func image(_ sourceImage: UIImage, scaledToWidth: CGFloat) -> UIImage {
        let oldWidth = sourceImage.size.width
        let scaleFactor = scaledToWidth / oldWidth
        let newHeight = sourceImage.size.height * scaleFactor
        let newWidth = oldWidth * scaleFactor
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
        sourceImage.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }

    public static func imageFrom(_ view: UIView) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(view.frame.size, false, 0.0)
        view.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
}
