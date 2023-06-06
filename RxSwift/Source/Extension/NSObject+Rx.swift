//
//  NSObject.swift
//  PolyGe
//
//  Created by king on 15/6/27.
//  Copyright © 2015年 king. All rights reserved.
//

import UIKit
import RxSwift
private var disposableBagAssociationKey: UInt8 = 0
extension Swifty where Base: NSObject {
    public var disposableBag : DisposeBag {
        return synchronized {
            if let disposableBag = objc_getAssociatedObject(self.base, &disposableBagAssociationKey) as? DisposeBag {
                return disposableBag
            }
            let disposableBag = DisposeBag()
            objc_setAssociatedObject(self.base, &disposableBagAssociationKey, disposableBag, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            return disposableBag
        }
    }
}
