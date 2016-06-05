//
//  NSkUserDefaults.swift
//  PolyGe
//
//  Created by king on 15/4/20.
//  Copyright (c) 2015年 king. All rights reserved.
//

import Foundation
protocol Settings {
    subscript(key: String) -> AnyObject? { get nonmutating set }
}
extension NSUserDefaults: Settings {
    public subscript (key: String) -> AnyObject? {
        get{ return objectForKey(key) }
        set{ setObject(newValue, forKey: key) }
    }    
}
