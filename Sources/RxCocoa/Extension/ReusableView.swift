//
//  UITableViewCell.swift
//  Pods
//
//  Created by king on 16/4/17.
//
//

import RxCocoa
import RxSwift
import UIKit

private var prepareForReusedisposableBagAssociationKey: UInt8 = 0

public extension Swifty where Base: UITableViewCell {
    public var prepareForReusedisposableBag: DisposeBag {
        return synchronized {
            if let disposableBag = objc_getAssociatedObject(self.base, &prepareForReusedisposableBagAssociationKey) as? DisposeBag {
                return disposableBag
            }
            let disposableBag = DisposeBag()
            self.prepareForReusedisposableBag(disposableBag)
            return disposableBag
        }
    }

    fileprivate func prepareForReusedisposableBag(_ newValue: DisposeBag) {
        synchronized {
            objc_setAssociatedObject(self.base, &prepareForReusedisposableBagAssociationKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            let cell = self.base as UITableViewCell
            cell.rx.sentMessage(#selector(self.base.prepareForReuse)).subscribe(onNext: {
                [unowned cell] _ in
                cell.ks.prepareForReusedisposableBag(DisposeBag())
            }).disposed(by: newValue)
        }
    }
}

public extension Swifty where Base: UICollectionReusableView {
    public var prepareForReusedisposableBag: DisposeBag {
        return synchronized {
            if let disposableBag = objc_getAssociatedObject(self.base, &prepareForReusedisposableBagAssociationKey) as? DisposeBag {
                return disposableBag
            }
            let disposableBag = DisposeBag()
            self.prepareForReusedisposableBag(disposableBag)
            return disposableBag
        }
    }

    fileprivate func prepareForReusedisposableBag(_ newValue: DisposeBag) {
        synchronized {
            objc_setAssociatedObject(self.base, &prepareForReusedisposableBagAssociationKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            let cell = self.base as UICollectionReusableView
            cell.rx.sentMessage(#selector(self.base.prepareForReuse)).subscribe(onNext: {
                [unowned cell] _ in
                cell.ks.prepareForReusedisposableBag(DisposeBag())
            }).disposed(by: newValue)
        }
    }
}
