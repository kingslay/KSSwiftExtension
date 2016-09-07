//
//  Double.swift
//  Pods
//
//  Created by king on 16/9/7.
//
//

import Foundation
extension Int: KSCompatible { }
extension Double: KSCompatible { }
extension Swifty where Base: CVarArgType {
    public func format(f:String) -> String {
        return String(format:"\(f)",self.base)
    }
}