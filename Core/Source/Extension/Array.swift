//
//  Array.swift
//  KSSwiftExtension
//
//  Created by king on 16/3/29.
//  Copyright © 2016年 king. All rights reserved.
//

import Foundation
extension Swifty where Base: SequenceType {
    typealias Element = Base.Generator.Element
    
    func partitionBy(fu: (Element)->Bool)->([Element],[Element]){
        var first=[Element]()
        var second=[Element]()
        for el in base {
            if fu(el) {
                first.append(el)
            }else{
                second.append(el)
            }
        }
        return (first,second)
    }
}