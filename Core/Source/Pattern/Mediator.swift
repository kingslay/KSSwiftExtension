//
//  Mediator.swift
//  KSSwiftExtension
//
//  Created by king on 16/3/15.
//  Copyright © 2016年 king. All rights reserved.
//

import Foundation
open class Mediator {
    open static func performAction(_ url: URL, completion: ((NSDictionary?) -> Void)?) -> AnyObject? {
        if let host = url.host, url.path.hasPrefix("native") {
            let result = perform(host, actionName: url.path, params: url.ks.getParams() as NSDictionary)
            if let completion = completion {
                if let result = result {
                    completion(["result": result])
                } else {
                    completion(nil)
                }
            }
        }
        return nil
    }

    open static func perform(_ targetName: String, actionName: String, params: NSDictionary) -> AnyObject? {
        if let targetClass = NSClassFromString("Target_" + targetName) as? NSObject.Type {
            var action = NSSelectorFromString("Action_\(actionName):")
            let target = targetClass.init()
            if target.responds(to: action) {
                return target.perform(action, with: params).takeUnretainedValue()
            } else {
                action = NSSelectorFromString("notFound:")
                if target.responds(to: action) {
                    return target.perform(action, with: params).takeUnretainedValue()
                }
            }
        }
        return nil
    }
}
