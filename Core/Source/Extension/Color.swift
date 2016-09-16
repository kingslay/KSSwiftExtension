//
//  KSColor.swift
//  PolyGe
//
//  Created by king on 15/4/16.
//  Copyright (c) 2015年 king. All rights reserved.
//

import UIKit

extension Swifty where Base: UIColor {
    static public func colorFrom(_ colorString: String) -> UIColor {
        let leftParenCharset: CharacterSet = CharacterSet(charactersIn: "( ")
        let commaCharset: CharacterSet = CharacterSet(charactersIn: ", ")

        let colorString = colorString.lowercased()

        if colorString.hasPrefix("#")
        {
            var argb: [UInt] = [255, 0, 0, 0]
            let colorString = colorString.unicodeScalars
            var length = colorString.count
            var index = colorString.startIndex
            let endIndex = colorString.endIndex
            index = colorString.index(index, offsetBy:1)
            length = length - 1

            if length == 3 || length == 6 || length == 8
            {
                var i = length == 8 ? 0 : 1
                while index < endIndex
                {
                    var c = colorString[index]
                    index = colorString.index(index, offsetBy:1)

                    var val = (c.value >= 0x61 && c.value <= 0x66) ? (c.value - 0x61 + 10) : c.value - 0x30
                    argb[i] = UInt(val) * 16
                    if length == 3
                    {
                        argb[i] = argb[i] + UInt(val)
                    }
                    else
                    {
                        c = colorString[index]
                        index = colorString.index(index, offsetBy:1)
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
            let scanner: Scanner = Scanner(string: colorString)
            scanner.scanString("rgba", into: nil)
            scanner.scanCharacters(from: leftParenCharset, into: nil)
            scanner.scanInt32(&r)
            scanner.scanCharacters(from: commaCharset, into: nil)
            scanner.scanInt32(&g)
            scanner.scanCharacters(from: commaCharset, into: nil)
            scanner.scanInt32(&b)
            scanner.scanCharacters(from: commaCharset, into: nil)
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
            let scanner: Scanner = Scanner(string: colorString)
            scanner.scanString("argb", into: nil)
            scanner.scanCharacters(from: leftParenCharset, into: nil)
            scanner.scanFloat(&a)
            scanner.scanCharacters(from: commaCharset, into: nil)
            scanner.scanInt32(&r)
            scanner.scanCharacters(from: commaCharset, into: nil)
            scanner.scanInt32(&g)
            scanner.scanCharacters(from: commaCharset, into: nil)
            scanner.scanInt32(&b)
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
            let scanner: Scanner = Scanner(string: colorString)
            scanner.scanString("rgb", into: nil)
            scanner.scanCharacters(from: leftParenCharset, into: nil)
            scanner.scanInt32(&r)
            scanner.scanCharacters(from: commaCharset, into: nil)
            scanner.scanInt32(&g)
            scanner.scanCharacters(from: commaCharset, into: nil)
            scanner.scanInt32(&b)
            return UIColor(
                red: CGFloat(r) / 255.0,
                green: CGFloat(g) / 255.0,
                blue: CGFloat(b) / 255.0,
                alpha: 1.0
            )
        }

        return UIColor.clear
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

    public static func createImage(_ color: UIColor) -> UIImage {
        let rect = CGRect(x: 0.0, y: 0.0, width: 1.0, height: 1.0)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        context?.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
}
