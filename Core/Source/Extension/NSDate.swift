//
//  Date.swift
//  PolyGe
//
//  Created by king on 15/7/11.
//  Copyright © 2015年 king. All rights reserved.
//

import Foundation
import ObjectiveC

public func - (lhs: NSDate, rhs: NSDate) -> NSTimeInterval {
    return lhs.timeIntervalSinceDate(rhs)
}
extension NSDate {
    
    // MARK: To String
    
    public func ks_toString() -> String {
        return self.ks_toString(dateStyle: .ShortStyle, timeStyle: .ShortStyle, doesRelativeDateFormatting: false)
    }
    
    public func ks_toString(dateStyle dateStyle: NSDateFormatterStyle, timeStyle: NSDateFormatterStyle, doesRelativeDateFormatting: Bool = false) -> String
    {
        let formatter = NSDateFormatter()
        formatter.dateStyle = dateStyle
        formatter.timeStyle = timeStyle
        formatter.doesRelativeDateFormatting = doesRelativeDateFormatting
        return formatter.stringFromDate(self)
    }
    
    public func ks_relativeTimeToString(containTime: Bool = false) -> String
    {
        let timeInterval = NSDate() - self
        if timeInterval < 86400 {
            return self.ks_stringFromFormat("HH:mm")
        }else if timeInterval < 2*86400 {
            if containTime {
                 "\("昨天".localized)\(self.ks_stringFromFormat(" HH:mm"))"
            }else{
                return "昨天".localized
            }
        }else if timeInterval < 7*86400 {
            if containTime {
                return self.ks_stringFromFormat("EEE HH:mm")
            }else{
                return self.ks_stringFromFormat("EEE")
            }
        }
        if containTime {
            return self.ks_stringFromFormat("yy/MM/dd HH:mm")
        }else{
            return self.ks_stringFromFormat("yy/MM/dd")
        }
    }
    public func ks_stringFromFormat(format: String) -> String {
        let formatter = NSDateFormatter()
        formatter.dateFormat = format
        return formatter.stringFromDate(self)
    }
}

