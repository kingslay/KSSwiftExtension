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

public extension Swifty where Base: UITableViewCell {
    public var prepareForReusedisposableBag: DisposeBag {
         get {
            return self.synchronized {
                if let disposableBag = objc_getAssociatedObject(self.base, &prepareForReusedisposableBagAssociationKey) as? DisposeBag {
                    return disposableBag
                }
                let disposableBag = DisposeBag()
                self.prepareForReusedisposableBag(disposableBag)
                return disposableBag
            }
        }
    }
    private func prepareForReusedisposableBag(newValue: DisposeBag) {
        self.synchronized {
            objc_setAssociatedObject(self.base, &prepareForReusedisposableBagAssociationKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            self.base.rx_sentMessage(#selector(self.base.prepareForReuse)).subscribeNext {
                [unowned cell = self.base as UITableViewCell] _ in
                cell.ks.prepareForReusedisposableBag(DisposeBag())
                }.addDisposableTo(newValue)
        }
    }
}

public extension Swifty where Base: UICollectionReusableView {
    public var prepareForReusedisposableBag: DisposeBag {
        get {
            return self.synchronized {
                if let disposableBag = objc_getAssociatedObject(self.base, &prepareForReusedisposableBagAssociationKey) as? DisposeBag {
                    return disposableBag
                }
                let disposableBag = DisposeBag()
                self.prepareForReusedisposableBag(disposableBag)
                return disposableBag
            }
        }
    }
    private func prepareForReusedisposableBag(newValue: DisposeBag) {
        self.synchronized {
            objc_setAssociatedObject(self.base, &prepareForReusedisposableBagAssociationKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            self.base.rx_sentMessage(#selector(self.base.prepareForReuse)).subscribeNext {
                [unowned cell = self.base as UICollectionReusableView] _ in
                cell.ks.prepareForReusedisposableBag(DisposeBag())
                }.addDisposableTo(newValue)
        }
    }
}