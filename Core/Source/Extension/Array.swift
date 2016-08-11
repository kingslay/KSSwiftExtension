//
//  Array.swift
//  KSSwiftExtension
//
//  Created by king on 16/3/29.
//  Copyright © 2016年 king. All rights reserved.
//

import Foundation
extension SequenceType {
    typealias Element = Self.Generator.Element
    
    func partitionBy(fu: (Element)->Bool)->([Element],[Element]){
        var first=[Element]()
        var second=[Element]()
        for el in self {
            if fu(el) {
                first.append(el)
            }else{
                second.append(el)
            }
        }
        return (first,second)
    }
}