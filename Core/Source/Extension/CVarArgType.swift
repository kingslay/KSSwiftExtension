//
//  Double.swift
//  Pods
//
//  Created by king on 16/9/7.
//
//

import Foundation
extension Int: KSCompatible {}
extension Double: KSCompatible {}
extension Swifty where Base: CVarArg {
    public func format(_ f: String) -> String {
        return String(format: "\(f)", base)
    }
}
