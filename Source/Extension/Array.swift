//
//  Array.swift
//  KSSwiftExtension
//
//  Created by king on 16/3/29.
//  Copyright © 2016年 king. All rights reserved.
//

import Foundation
extension Array {
    public func forEach(iterator: (Element) -> Void) -> Array {
        for item in self {
            iterator(item)
        }
        return self;
    }
}