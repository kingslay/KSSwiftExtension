//
//  KSString.swift
//  PolyGe
//
//  Created by king on 15/4/17.
//  Copyright (c) 2015年 king. All rights reserved.
//

import Foundation
extension String {
    static let phoneRegex = NSPredicate(format: "SELF MATCHES %@", "^1[34578]\\d{9}$")
    static let  emailRegex = NSPredicate(format: "SELF MATCHES %@", "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}")
    
    public var localized: String {
        let s = NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: "")
        return s
    }
    public var length : Int {
        return self.characters.count
    }
    public init(data: Data){
        let str =  NSString(data: data, encoding: String.Encoding.utf8.rawValue)  as! String
        self.init(stringLiteral: str)
    }
    public subscript (i: Int) -> Character {
        return self[self.characters.index(self.startIndex, offsetBy: i)]
    }
    
    public subscript (i: Int) -> String {
        return String(self[i] as Character)
    }
    
    public subscript (r: Range<Int>) -> String {
        return substring(with: self.characters.index(self.startIndex, offsetBy: r.lowerBound) ..< self.characters.index(self.startIndex, offsetBy: r.upperBound))
    }
    public func checkMobileNumble() -> Bool {
        return String.phoneRegex.evaluate(with: self)
    }
    public func checkEmail() -> Bool {
        return String.emailRegex.evaluate(with: self)
    }
}
