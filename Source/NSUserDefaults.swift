//
//  NSkUserDefaults.swift
//  PolyGe
//
//  Created by king on 15/4/20.
//  Copyright (c) 2015年 king. All rights reserved.
//

import Foundation
extension NSUserDefaults {
    subscript (key: String) -> AnyObject? {
        get{
            return objectForKey(key)
        }
        set(newValue){
            setObject(newValue, forKey: key)
            synchronize()
        }
    }    
}
