//
//  NSURL.swift
//  KSSwiftExtension
//
//  Created by king on 16/3/15.
//  Copyright © 2016年 king. All rights reserved.
//

import Foundation
extension NSURL {
    func getParams()->[String:String]{
        let components = NSURLComponents(URL: self, resolvingAgainstBaseURL: false)
        return components?.queryItems?.reduce([String:String]()) { (var dict, item) -> [String:String] in
            dict[item.name] = item.value ?? ""
            return dict
            } ?? [:]
        
    }
}
