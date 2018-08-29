//
//  Date.swift
//  PolyGe
//
//  Created by king on 15/7/11.
//  Copyright © 2015年 king. All rights reserved.
//

import Foundation
import ObjectiveC
extension DateComponents {
    /// Define a list of all calendar components as a set
    internal static let allComponentsSet: Set<Calendar.Component> = [.nanosecond, .second, .minute, .hour, .day, .month, .year, .yearForWeekOfYear, .weekOfYear, .weekday, .quarter, .weekdayOrdinal, .weekOfMonth, .calendar]

    /// Define a list of all calendar components as array
    internal static let allComponents: [Calendar.Component] = [.nanosecond, .second, .minute, .hour, .day, .month, .year, .yearForWeekOfYear, .weekOfYear, .weekday, .quarter, .weekdayOrdinal, .weekOfMonth, .calendar]
}

public func - (lhs: Date, rhs: Date) -> TimeInterval {
    return lhs.timeIntervalSince(rhs)
}

public prefix func - (dateComponents: DateComponents) -> DateComponents {
    var invertedCmps = DateComponents()

    DateComponents.allComponents.forEach { component in
        let value = dateComponents.value(for: component)
        if value != nil && value != Int(NSDateComponentUndefined) {
            invertedCmps.setValue(-value!, for: component)
        }
    }
    return invertedCmps
}

public func - (lhs: Date, rhs: DateComponents) -> Date {
    return lhs + (-rhs)
}

public func + (lhs: Date, rhs: DateComponents) -> Date {
    return lhs.ks.add(components: rhs)
}

public func + (lhs: Date, rhs: TimeInterval) -> Date {
    return lhs.addingTimeInterval(rhs)
}

public func - (lhs: Date, rhs: TimeInterval) -> Date {
    return lhs.addingTimeInterval(-rhs)
}

public func + (lhs: Date, rhs: [Calendar.Component: Int]) -> Date {
    return lhs.ks.add(components: Date.components(fromValues: rhs))
}

public func - (lhs: Date, rhs: [Calendar.Component: Int]) -> Date {
    return lhs.ks.add(components: Date.components(fromValues: rhs, multipler: -1))
}

extension Date {
    public var ks: SwiftyDate {
        return SwiftyDate(self)
    }

    internal static func components(fromValues: [Calendar.Component: Int], multipler: Int = 1) -> DateComponents {
        var cmps = DateComponents()
        cmps.calendar = NSCalendar.current
        cmps.timeZone = TimeZone.current
        fromValues.forEach { key, value in
            if key != .timeZone && key != .calendar {
                cmps.setValue(multipler * value, for: key)
            }
        }
        return cmps
    }
}

public struct SwiftyDate {
    let date: Date
    public var dateComponents: DateComponents
    public var weekOfYear: Int {
        return dateComponents.weekOfYear!
    }

    public var year: Int {
        return dateComponents.year!
    }

    public var month: Int {
        return dateComponents.month!
    }

    public var day: Int {
        return dateComponents.day!
    }

    public var hour: Int {
        return dateComponents.hour!
    }

    public var minute: Int {
        return dateComponents.minute!
    }

    public var second: Int {
        return dateComponents.second!
    }

    public init(_ date: Date) {
        self.date = date
        dateComponents = NSCalendar.current.dateComponents(DateComponents.allComponentsSet, from: date)
        dateComponents.timeZone = TimeZone.current
    }

    public func date(fromValues: [Calendar.Component: Int]) -> Date {
        var dateComponents = self.dateComponents
        fromValues.forEach { key, value in
            if key != .timeZone && key != .calendar {
                dateComponents.setValue(value, for: key)
            }
        }
        return NSCalendar.autoupdatingCurrent.date(from: dateComponents)!
    }

    public func add(components: DateComponents) -> Date {
        let nextDate = dateComponents.calendar!.date(byAdding: components, to: date)
        return nextDate!
    }

    public func toString() -> String {
        return toString(.short, timeStyle: .short, doesRelativeDateFormatting: false)
    }

    public func toString(_ dateStyle: DateFormatter.Style, timeStyle: DateFormatter.Style, doesRelativeDateFormatting: Bool = false) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = dateStyle
        formatter.timeStyle = timeStyle
        formatter.doesRelativeDateFormatting = doesRelativeDateFormatting
        return formatter.string(from: date)
    }

    public func relativeTimeToString(_ containTime: Bool = false) -> String {
        let timeInterval = Date() - date
        if timeInterval < 86400 {
            return string(fromFormat: "HH:mm")
        } else if timeInterval < 2 * 86400 {
            if containTime {
                return "\("昨天".localized)\(string(fromFormat: " HH:mm"))"
            } else {
                return "昨天".localized
            }
        } else if timeInterval < 7 * 86400 {
            if containTime {
                return string(fromFormat: "EEE HH:mm")
            } else {
                return string(fromFormat: "EEE")
            }
        }
        if containTime {
            return string(fromFormat: "yy/MM/dd HH:mm")
        } else {
            return string(fromFormat: "yy/MM/dd")
        }
    }

    public func string(fromFormat: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = fromFormat
        return formatter.string(from: date)
    }
}
