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
    public func appendInt64(_ value : Int64) {
        var val = value.bigEndian
        self.base.append(&val, length: MemoryLayout.size(ofValue: val))
    }
    public func appendUInt64(_ value : UInt64) {
        var val = value.bigEndian
        self.base.append(&val, length: MemoryLayout.size(ofValue: val))
    }

    
    public func appendInt32(_ value : Int32) {
        var val = value.bigEndian
        self.base.append(&val, length: MemoryLayout.size(ofValue: val))
    }
    public func appendUInt32(_ value : UInt32) {
        var val = value.bigEndian
        self.base.append(&val, length: MemoryLayout.size(ofValue: val))
    }
    
    public func appendInt16(_ value : Int16) {
        var val = value.bigEndian
        self.base.append(&val, length: MemoryLayout.size(ofValue: val))
    }
    public func appendUInt16(_ value : UInt16) {
        var val = value.bigEndian
        self.base.append(&val, length: MemoryLayout.size(ofValue: val))
    }
    
    public func appendUInt8(_ value : UInt8) {
        var val = value
        self.base.append(&val, length: MemoryLayout.size(ofValue: val))
    }
    public func appendUInt8(_ values : [UInt8]) {
        for value in values {
            appendUInt8(value)
        }
    }
    public func appendInt8(_ value : Int8) {
        var val = value
        self.base.append(&val, length: MemoryLayout.size(ofValue: val))
    }
    
    public func appendString(_ value : String) {
        value.withCString {
            self.base.append($0, length: Int(strlen($0)))
        }
    }
}
