//
//  NSMutableData.swift
//  PolyGe
//
//  Created by king on 15/6/27.
//  Copyright © 2015年 king. All rights reserved.
//

import Foundation
//大端序
extension Swifty where Base: NSMutableData {
    public func appendInt64(value : Int64) {
        var val = value.bigEndian
        self.base.appendBytes(&val, length: sizeofValue(val))
    }
    public func appendUInt64(value : UInt64) {
        var val = value.bigEndian
        self.base.appendBytes(&val, length: sizeofValue(val))
    }

    
    public func appendInt32(value : Int32) {
        var val = value.bigEndian
        self.base.appendBytes(&val, length: sizeofValue(val))
    }
    public func appendUInt32(value : UInt32) {
        var val = value.bigEndian
        self.base.appendBytes(&val, length: sizeofValue(val))
    }
    
    public func appendInt16(value : Int16) {
        var val = value.bigEndian
        self.base.appendBytes(&val, length: sizeofValue(val))
    }
    public func appendUInt16(value : UInt16) {
        var val = value.bigEndian
        self.base.appendBytes(&val, length: sizeofValue(val))
    }
    
    public func appendUInt8(value : UInt8) {
        var val = value
        self.base.appendBytes(&val, length: sizeofValue(val))
    }
    public func appendInt8(value : Int8) {
        var val = value
        self.base.appendBytes(&val, length: sizeofValue(val))
    }
    
    public func appendString(value : String) {
        value.withCString {
            self.base.appendBytes($0, length: Int(strlen($0)))
        }
    }
}