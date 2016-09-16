//
//  Date.swift
//  PolyGe
//
//  Created by king on 15/7/11.
//  Copyright © 2015年 king. All rights reserved.
//

import Foundation
import ObjectiveC

public func - (lhs: Date, rhs: Date) -> TimeInterval {
    return lhs.timeIntervalSince(rhs)
}
extension Swifty where Base: Date {
    
    public func toString() -> String {
        return self.toString(dateStyle: .short, timeStyle: .short, doesRelativeDateFormatting: false)
    }
    
    public func toString(dateStyle: DateFormatter.Style, timeStyle: DateFormatter.Style, doesRelativeDateFormatting: Bool = false) -> String
    {
        let formatter = DateFormatter()
        formatter.dateStyle = dateStyle
        formatter.timeStyle = timeStyle
        formatter.doesRelativeDateFormatting = doesRelativeDateFormatting
        return formatter.string(from: self.base)
    }
    
    public func relativeTimeToString(_ containTime: Bool = false) -> String
    {
        let timeInterval = Date() - self.base
        if timeInterval < 86400 {
            return self.stringFromFormat("HH:mm")
        }else if timeInterval < 2*86400 {
            if containTime {
                 "\("昨天".localized)\(self.stringFromFormat(" HH:mm"))"
            }else{
                return "昨天".localized
            }
        }else if timeInterval < 7*86400 {
            if containTime {
                return self.stringFromFormat("EEE HH:mm")
            }else{
                return self.stringFromFormat("EEE")
            }
        }
        if containTime {
            return self.stringFromFormat("yy/MM/dd HH:mm")
        }else{
            return self.stringFromFormat("yy/MM/dd")
        }
    }
    public func stringFromFormat(_ format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self.base)
    }
}

