//
//  NSObject.swift
//  PolyGe
//
//  Created by king on 15/6/27.
//  Copyright © 2015年 king. All rights reserved.
//

import UIKit
import KSSwiftExtension
import RxSwift
private var disposableBagAssociationKey: UInt8 = 0
extension NSObject {
    public var ks_disposableBag : DisposeBag {
        return rx_synchronized {
            if let disposableBag = objc_getAssociatedObject(self, &disposableBagAssociationKey) as? DisposeBag {
                return disposableBag
            }
            let disposableBag = DisposeBag()
            objc_setAssociatedObject(self, &disposableBagAssociationKey, disposableBag, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            return disposableBag
        }
    }
}
