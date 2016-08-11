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
        let s = NSLocalizedString(self, tableName: nil, bundle: NSBundle.mainBundle(), value: "", comment: "")
        return s
    }
    public var length : Int {
        return self.characters.count
    }
    public init(data: NSData){
        let str =  NSString(data: data, encoding: NSUTF8StringEncoding)  as! String
        self.init(stringLiteral: str)
    }
    public subscript (i: Int) -> Character {
        return self[self.startIndex.advancedBy(i)]
    }
    
    public subscript (i: Int) -> String {
        return String(self[i] as Character)
    }
    
    public subscript (r: Range<Int>) -> String {
        return substringWithRange(self.startIndex.advancedBy(r.startIndex) ..< self.startIndex.advancedBy(r.endIndex))
    }
    public func checkMobileNumble() -> Bool {
        return String.phoneRegex.evaluateWithObject(self)
    }
    public func checkEmail() -> Bool {
        return String.emailRegex.evaluateWithObject(self)
    }
}