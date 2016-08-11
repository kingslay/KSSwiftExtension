//
//  UITableViewCell.swift
//  Pods
//
//  Created by king on 16/4/17.
//
//

import UIKit
import RxSwift
import RxCocoa
private var prepareForReusedisposableBagAssociationKey: UInt8 = 0
extension UITableViewCell {
    public private(set) var ks_prepareForReusedisposableBag: DisposeBag {
        get {
            return rx_synchronized {
                if let disposableBag = objc_getAssociatedObject(self, &prepareForReusedisposableBagAssociationKey) as? DisposeBag {
                    return disposableBag
                }
                let disposableBag = DisposeBag()
                self.ks_prepareForReusedisposableBag = disposableBag
                return disposableBag
            }
        }
        set {
            rx_synchronized {
                objc_setAssociatedObject(self, &prepareForReusedisposableBagAssociationKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                self.rx_sentMessage(#selector(prepareForReuse)).subscribeNext {
                    [unowned self] _ in
                    self.ks_prepareForReusedisposableBag = DisposeBag()
                }.addDisposableTo(newValue)
            }
        }
    }
}
extension UICollectionReusableView {
    
    public private(set) var ks_prepareForReusedisposableBag: DisposeBag {
        get {
            return rx_synchronized {
                if let disposableBag = objc_getAssociatedObject(self, &prepareForReusedisposableBagAssociationKey) as? DisposeBag {
                    return disposableBag
                }
                let disposableBag = DisposeBag()
                self.ks_prepareForReusedisposableBag = disposableBag
                return disposableBag
            }
        }
        set {
            rx_synchronized {
                objc_setAssociatedObject(self, &prepareForReusedisposableBagAssociationKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                self.rx_sentMessage(#selector(prepareForReuse)).subscribeNext {
                    [unowned self] _ in
                    self.ks_prepareForReusedisposableBag = DisposeBag()
                    }.addDisposableTo(newValue)
            }
        }
    }
}