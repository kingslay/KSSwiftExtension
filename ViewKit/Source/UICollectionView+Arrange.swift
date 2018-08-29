//
//  UICollectionView.swift
//  Cup
//
//  Created by king on 15/11/3.
//  Copyright © 2015年 king. All rights reserved.
//

import UIKit
public protocol KSArrangeCollectionViewDelegate: NSObjectProtocol {
    func moveDataItem(_ fromIndexPath: IndexPath, toIndexPath: IndexPath) -> Void
    func deleteItemAtIndexPath(_ indexPath: IndexPath) -> Void
}

private var bundleAssociationKey: UInt8 = 0
private var deleteButtonAssociationKey: UInt8 = 0
extension UICollectionView: UIGestureRecognizerDelegate {
    class Bundle {
        var offset: CGPoint = CGPoint.zero
        var sourceCell: UICollectionViewCell
        var representationImageView: UIView
        var currentIndexPath: IndexPath
        var deleteButton: UIButton?
        init(offset: CGPoint, sourceCell: UICollectionViewCell, representationImageView: UIView, currentIndexPath: IndexPath) {
            self.offset = offset
            self.sourceCell = sourceCell
            self.representationImageView = representationImageView
            self.currentIndexPath = currentIndexPath
        }
    }

    var bundle: Bundle? {
        get {
            return objc_getAssociatedObject(self, &bundleAssociationKey) as? Bundle
        }
        set(newValue) {
            objc_setAssociatedObject(self, &bundleAssociationKey, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }

    public func addMoveGestureRecognizerForPan() {
        let panGestureRecogniser = UIPanGestureRecognizer(target: self, action: #selector(handleGesture(_:)))
        panGestureRecogniser.delegate = self
        addGestureRecognizer(panGestureRecogniser)
    }

    public func addMoveGestureRecognizerForLongPress() {
        let longPressGestureRecogniser = UILongPressGestureRecognizer(target: self, action: #selector(handleGesture(_:)))
        longPressGestureRecogniser.delegate = self
        addGestureRecognizer(longPressGestureRecogniser)
    }

    // MARK: - UIGestureRecognizerDelegate

    open override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        bundle?.deleteButton?.removeFromSuperview()
        bundle = nil
        let pointPressedInCollectionView = gestureRecognizer.location(in: self)
        if let indexPath = self.indexPathForItem(at: pointPressedInCollectionView), let cell = self.cellForItem(at: indexPath) {
            let representationImage = cell.snapshotView(afterScreenUpdates: true)
            representationImage?.frame = cell.frame

            let offset = CGPoint(x: pointPressedInCollectionView.x - (representationImage?.frame.origin.x)!, y: pointPressedInCollectionView.y - (representationImage?.frame.origin.y)!)

            bundle = Bundle(offset: offset, sourceCell: cell, representationImageView: representationImage!, currentIndexPath: indexPath)
            if gestureRecognizer.isKind(of: UILongPressGestureRecognizer.self) {
                let button = UIButton()
                bundle!.deleteButton = button
                button.setImage(UIImage(named: "tata_close"), for: UIControlState())
                button.frame = CGRect(x: cell.frame.origin.x, y: cell.frame.origin.y, width: 18, height: 18)
                button.addTarget(self, action: #selector(touchUpInside(_:)), for: .touchUpInside)
                let tapGestureRecogniser = UITapGestureRecognizer()
                addGestureRecognizer(tapGestureRecogniser)
                tapGestureRecogniser.addTarget(self, action: #selector(tapGesture(_:)))
            }
        }
        return (bundle != nil)
    }

    @objc public func handleGesture(_ gesture: UIGestureRecognizer) {
        if let bundle = self.bundle {
            let dragPointOnCollectionView = gesture.location(in: self)

            if gesture.state == UIGestureRecognizerState.began {
                bundle.sourceCell.isHidden = true
                addSubview(bundle.representationImageView)
                if let deleteButton = bundle.deleteButton {
                    addSubview(deleteButton)
                }
                UIView.animate(withDuration: 0.5, animations: { () -> Void in
                    bundle.representationImageView.alpha = 0.8
                })
            }
            if gesture.state == UIGestureRecognizerState.changed {
                // Update the representation image
                var imageViewFrame = bundle.representationImageView.frame
                var point = CGPoint.zero
                point.x = dragPointOnCollectionView.x - bundle.offset.x
                point.y = dragPointOnCollectionView.y - bundle.offset.y
                imageViewFrame.origin = point
                bundle.representationImageView.frame = imageViewFrame
                bundle.deleteButton?.frame = CGRect(x: point.x, y: point.y, width: 18, height: 18)

                if let indexPath: IndexPath = self.indexPathForItem(at: dragPointOnCollectionView) {
                    if (indexPath == bundle.currentIndexPath) == false {
                        bundle.deleteButton?.removeFromSuperview()
                        // If we have a collection view controller that implements the delegate we call the method first
                        if let delegate = self.delegate as? KSArrangeCollectionViewDelegate {
                            delegate.moveDataItem(bundle.currentIndexPath, toIndexPath: indexPath)
                        }
                        moveItem(at: bundle.currentIndexPath, to: indexPath)
                        self.bundle!.currentIndexPath = indexPath
                    }
                }
            }

            if gesture.state == UIGestureRecognizerState.ended {
                bundle.sourceCell.isHidden = false
                bundle.representationImageView.removeFromSuperview()

                if let _ = self.delegate as? KSArrangeCollectionViewDelegate { // if we have a proper data source then we can reload and have the data displayed correctly
                    reloadData()
                }
            }
        }
    }

    @objc fileprivate func tapGesture(_ gesture: UIGestureRecognizer) {
        bundle?.deleteButton?.removeFromSuperview()
        removeGestureRecognizer(gesture)
    }

    @objc fileprivate func touchUpInside(_ target: UIButton) {
        target.removeFromSuperview()
        if let indexPath = self.bundle?.currentIndexPath {
            if let delegate = self.delegate as? KSArrangeCollectionViewDelegate {
                delegate.deleteItemAtIndexPath(indexPath)
            }
            deleteItems(at: [indexPath])
        }
    }
}
