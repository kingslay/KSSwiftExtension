//
//  Swizzle.swift
//  Pods
//
//  Created by king on 16/4/12.
//
//
import ObjectiveC
extension KS {
    static internal func swizzleMethod(class_: AnyClass, selector1 sel1: String, selector2 sel2: String) {
        let selector1 = Selector(sel1)
        let selector2 = Selector(sel2)
        let method1: Method = class_getInstanceMethod(class_, selector1)
        let method2: Method = class_getInstanceMethod(class_, selector2)
        if class_addMethod(class_, selector1, method_getImplementation(method2), method_getTypeEncoding(method2)) {
            class_replaceMethod(class_, selector2, method_getImplementation(method1), method_getTypeEncoding(method1))
        } else {
            method_exchangeImplementations(method1, method2)
        }
    }

    static public func swizzleInstanceMethod(class_: AnyClass, sel1: String, sel2: String) {
        swizzleMethod(class_, selector1: sel1, selector2: sel2)
    }

    static public func swizzleClassMethod(class_: AnyClass, sel1: String, sel2: String) {
        swizzleMethod(object_getClass(class_), selector1: sel1, selector2: sel2)
    }
}
