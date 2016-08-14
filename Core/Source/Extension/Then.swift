//
//  Then.swift
//  Pods
//
//  Created by king on 16/8/14.
//
//

import Foundation
public protocol Then {}

extension Then where Self: Any {

    /// Makes it available to set properties with closures just after initializing.
    ///
    ///     let label = UILabel().then {
    ///         $0.textAlignment = .Center
    ///         $0.textColor = UIColor.blackColor()
    ///         $0.text = "Hello, World!"
    ///     }
    public func then(@noescape block: inout Self -> Void) -> Self {
        var copy = self
        block(&copy)
        return copy
    }

}

extension Then where Self: AnyObject {

    /// Makes it available to set properties with closures just after initializing.
    ///
    ///     let label = UILabel().then {
    ///         $0.textAlignment = .Center
    ///         $0.textColor = UIColor.blackColor()
    ///         $0.text = "Hello, World!"
    ///     }
    public func then(@noescape block: Self -> Void) -> Self {
        block(self)
        return self
    }

}

extension NSObject: Then {}