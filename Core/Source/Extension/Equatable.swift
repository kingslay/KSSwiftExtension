//
//  Dictory.swift
//  Pods
//
//  Created by king on 2016/10/20.
//
//

import Foundation

func ==<T: Equatable, K1: Hashable>(lhs: [K1: T], rhs: [K1: T]) -> Bool {
    if lhs.count != rhs.count { return false }
    for (key, lhsub) in lhs {
        if lhsub != rhs[key] {
            return false
        }
    }
    return true
}
