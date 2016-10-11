//
//  NSURL.swift
//  KSSwiftExtension
//
//  Created by king on 16/3/15.
//  Copyright © 2016年 king. All rights reserved.
//

import Foundation

extension URL: KSCompatible {
    public var ks: SwiftyURL {
        return SwiftyURL(self)
    }
}
public struct SwiftyURL {
    let url: URL
    public init(_ url: URL) {
        self.url = url
    }
    func getParams()->[String:String]{
        var dict = [String:String]()
        URLComponents(url: self.url, resolvingAgainstBaseURL: false)?.queryItems?.forEach {
            dict[$0.name] = $0.value ?? ""
        }
        return dict
    }
}

