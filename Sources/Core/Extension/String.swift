//
//  KSString.swift
//  PolyGe
//
//  Created by king on 15/4/17.
//  Copyright (c) 2015年 king. All rights reserved.
//

import Foundation
import UIKit

extension String {
    static let phoneRegex = NSPredicate(format: "SELF MATCHES %@", "^1[34578]\\d{9}$")
    static let emailRegex = NSPredicate(format: "SELF MATCHES %@", "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}")

    public var localized: String {
        return NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: "")
    }

    public var length: Int {
        return count
    }

    public init(data: Data) {
        let str = NSString(data: data, encoding: String.Encoding.utf8.rawValue)! as String
        self.init(stringLiteral: str)
    }

    public func checkMobileNumble() -> Bool {
        return String.phoneRegex.evaluate(with: self)
    }

    public func checkEmail() -> Bool {
        return String.emailRegex.evaluate(with: self)
    }

    public func widthForComment(fontSize: CGFloat, height: CGFloat) -> CGFloat {
        let font = UIFont.systemFont(ofSize: fontSize)
        let rect = NSString(string: self).boundingRect(with: CGSize(width: CGFloat(MAXFLOAT), height: height), options: .usesLineFragmentOrigin, attributes: [.font: font], context: nil)
        return ceil(rect.width)
    }

    public func heightForComment(fontSize: CGFloat, width: CGFloat) -> CGFloat {
        let font = UIFont.systemFont(ofSize: fontSize)
        let rect = NSString(string: self).boundingRect(with: CGSize(width: width, height: CGFloat(MAXFLOAT)), options: .usesLineFragmentOrigin, attributes: [.font: font], context: nil)
        return ceil(rect.height)
    }

    public func heightForComment(fontSize: CGFloat, width: CGFloat, maxHeight: CGFloat) -> CGFloat {
        return min(heightForComment(fontSize: fontSize, width: width), maxHeight)
    }
}
