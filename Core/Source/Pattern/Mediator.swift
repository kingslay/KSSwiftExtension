//
//  Mediator.swift
//  KSSwiftExtension
//
//  Created by king on 16/3/15.
//  Copyright © 2016年 king. All rights reserved.
//

import Foundation
public class Mediator {
    public static func performAction(url: NSURL,completion: (NSDictionary? -> Void)? ) -> AnyObject? {
        if let host = url.host, path = url.path where !path.hasPrefix("native") {
            let result = perform(host, actionName: path, params: url.ks.getParams())
            if let completion = completion {
                if let result = result {
                    completion(["result":result])
                }else{
                    completion(nil)
                }
            }
        }
        return nil
    }
    public static func perform(targetName: String,actionName: String,params: NSDictionary) -> AnyObject? {
        if let targetClass = NSClassFromString("Target_"+targetName) as? NSObject.Type {
            var action = NSSelectorFromString("Action_\(actionName):")
            let target = targetClass.init()
            if target.respondsToSelector(action) {
                return target.performSelector(action, withObject: params).takeUnretainedValue()
            }else{
                action = NSSelectorFromString("notFound:")
                if target.respondsToSelector(action) {
                    return target.performSelector(action, withObject: params).takeUnretainedValue()
                }
            }
        }
        return nil
    }
}
