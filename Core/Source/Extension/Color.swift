//
//  KSColor.swift
//  PolyGe
//
//  Created by king on 15/4/16.
//  Copyright (c) 2015年 king. All rights reserved.
//

import UIKit

extension Swifty where Base: UIColor {
    static public func colorFrom(colorString: String) -> UIColor {
        let leftParenCharset: NSCharacterSet = NSCharacterSet(charactersInString: "( ")
        let commaCharset: NSCharacterSet = NSCharacterSet(charactersInString: ", ")

        let colorString = colorString.lowercaseString

        if colorString.hasPrefix("#")
        {
            var argb: [UInt] = [255, 0, 0, 0]
            let colorString = colorString.unicodeScalars
            var length = colorString.count
            var index = colorString.startIndex
            let endIndex = colorString.endIndex

            index = index.advancedBy(1)
            length = length - 1

            if length == 3 || length == 6 || length == 8
            {
                var i = length == 8 ? 0 : 1
                while index < endIndex
                {
                    var c = colorString[index]
                    index = index.advancedBy(1)

                    var val = (c.value >= 0x61 && c.value <= 0x66) ? (c.value - 0x61 + 10) : c.value - 0x30
                    argb[i] = UInt(val) * 16
                    if length == 3
                    {
                        argb[i] = argb[i] + UInt(val)
                    }
                    else
                    {
                        c = colorString[index]
                        index = index.advancedBy(1)

                        val = (c.value >= 0x61 && c.value <= 0x66) ? (c.value - 0x61 + 10) : c.value - 0x30
                        argb[i] = argb[i] + UInt(val)
                    }

                    i += 1
                }
            }

            return UIColor(red: CGFloat(argb[1]) / 255.0, green: CGFloat(argb[2]) / 255.0, blue: CGFloat(argb[3]) / 255.0, alpha: CGFloat(argb[0]) / 255.0)
        }
        else if colorString.hasPrefix("rgba")
        {
            var a: Float = 1.0
            var r: Int32 = 0
            var g: Int32 = 0
            var b: Int32 = 0
            let scanner: NSScanner = NSScanner(string: colorString)
            scanner.scanString("rgba", intoString: nil)
            scanner.scanCharactersFromSet(leftParenCharset, intoString: nil)
            scanner.scanInt(&r)
            scanner.scanCharactersFromSet(commaCharset, intoString: nil)
            scanner.scanInt(&g)
            scanner.scanCharactersFromSet(commaCharset, intoString: nil)
            scanner.scanInt(&b)
            scanner.scanCharactersFromSet(commaCharset, intoString: nil)
            scanner.scanFloat(&a)
            return UIColor(
                red: CGFloat(r) / 255.0,
                green: CGFloat(g) / 255.0,
                blue: CGFloat(b) / 255.0,
                alpha: CGFloat(a)
            )
        }
        else if colorString.hasPrefix("argb")
        {
            var a: Float = 1.0
            var r: Int32 = 0
            var g: Int32 = 0
            var b: Int32 = 0
            let scanner: NSScanner = NSScanner(string: colorString)
            scanner.scanString("argb", intoString: nil)
            scanner.scanCharactersFromSet(leftParenCharset, intoString: nil)
            scanner.scanFloat(&a)
            scanner.scanCharactersFromSet(commaCharset, intoString: nil)
            scanner.scanInt(&r)
            scanner.scanCharactersFromSet(commaCharset, intoString: nil)
            scanner.scanInt(&g)
            scanner.scanCharactersFromSet(commaCharset, intoString: nil)
            scanner.scanInt(&b)
            return UIColor(
                red: CGFloat(r) / 255.0,
                green: CGFloat(g) / 255.0,
                blue: CGFloat(b) / 255.0,
                alpha: CGFloat(a)
            )
        }
        else if colorString.hasPrefix("rgb")
        {
            var r: Int32 = 0
            var g: Int32 = 0
            var b: Int32 = 0
            let scanner: NSScanner = NSScanner(string: colorString)
            scanner.scanString("rgb", intoString: nil)
            scanner.scanCharactersFromSet(leftParenCharset, intoString: nil)
            scanner.scanInt(&r)
            scanner.scanCharactersFromSet(commaCharset, intoString: nil)
            scanner.scanInt(&g)
            scanner.scanCharactersFromSet(commaCharset, intoString: nil)
            scanner.scanInt(&b)
            return UIColor(
                red: CGFloat(r) / 255.0,
                green: CGFloat(g) / 255.0,
                blue: CGFloat(b) / 255.0,
                alpha: 1.0
            )
        }

        return UIColor.clearColor()
    }

    public func toHexString() -> String {
        var r:CGFloat = 0
        var g:CGFloat = 0
        var b:CGFloat = 0
        var a:CGFloat = 0
        self.base.getRed(&r, green: &g, blue: &b, alpha: &a)
        let rgb:Int = (Int)(r*255)<<16 | (Int)(g*255)<<8 | (Int)(b*255)<<0
        return String(format:"#%06x", rgb)
    }

    public static func createImage(color: UIColor) -> UIImage {
        let rect = CGRectMake(0.0, 0.0, 1.0, 1.0)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        CGContextSetFillColorWithColor(context, color.CGColor)
        CGContextFillRect(context, rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}
