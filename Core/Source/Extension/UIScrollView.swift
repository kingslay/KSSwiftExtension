//
//  UIScrollView.swift
//  KSSwiftExtension
//
//  Created by kintan on 2018/1/10.
//

import UIKit
extension Swifty where Base: UIScrollView {
    public func contentScrollCapture (_ completionHandler: @escaping (_ capturedImage: UIImage?) -> Void) {
        // Put a fake Cover of View
        let snapShotView = self.base.snapshotView(afterScreenUpdates: true)
        snapShotView?.frame = self.base.frame
        self.base.superview?.addSubview(snapShotView!)
        // Backup
        let bakOffset    = self.base.contentOffset
        // Divide
        let page  = floorf(Float(self.base.contentSize.height / self.base.bounds.height))
        UIGraphicsBeginImageContextWithOptions(self.base.contentSize, false, UIScreen.main.scale)
        self.contentScrollPageDraw(0, maxIndex: Int(page), drawCallback: { () -> Void in
            let capturedImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            // Recover
            self.base.setContentOffset(bakOffset, animated: false)
            snapShotView?.removeFromSuperview()
            completionHandler(capturedImage)
        })
    }

    fileprivate func contentScrollPageDraw (_ index: Int, maxIndex: Int, drawCallback: @escaping () -> Void) {

        let splitFrame = CGRect(x: -self.base.contentInset.left, y: CGFloat(index) * self.base.frame.size.height, width: self.base.bounds.size.width, height: self.base.bounds.size.height)
        self.base.setContentOffset(splitFrame.origin, animated: false)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(0.3 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)) { () -> Void in
            self.base.drawHierarchy(in: splitFrame, afterScreenUpdates: true)
            if index < maxIndex {
                self.contentScrollPageDraw(index + 1, maxIndex: maxIndex, drawCallback: drawCallback)
            }else{
                drawCallback()
            }
        }
    }
}
extension UIScrollView {
    @objc public func contentScrollCapture (_ completionHandler: @escaping (_ capturedImage: UIImage?) -> Void) {
        self.ks.contentScrollCapture(completionHandler)
    }
}
