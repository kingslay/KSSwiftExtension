//
//  NSURL.swift
//  KSSwiftExtension
//
//  Created by king on 16/3/15.
//  Copyright © 2016年 king. All rights reserved.
//

import Foundation
extension Swifty where Base: URL {
    func getParams()->[String:String]{
        let components = URLComponents(url: self.base, resolvingAgainstBaseURL: false)
        var dict = [String:String]()
        components?.queryItems?.forEach {
            dict[$0.name] = $0.value ?? ""
        }
        return dict
    }
}
