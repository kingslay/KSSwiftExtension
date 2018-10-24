//
//  NSkUserDefaults.swift
//  PolyGe
//
//  Created by king on 15/4/20.
//  Copyright (c) 2015年 king. All rights reserved.
//

import Foundation
protocol Settings {
    subscript(_: String) -> AnyObject? { get nonmutating set }
}

extension UserDefaults: Settings {
    public subscript(key: String) -> AnyObject? {
        get { return object(forKey: key) as AnyObject? }
        set { set(newValue, forKey: key) }
    }
}
