//
//  UIScrollView.swift
//  KSSwiftExtension
//
//  Created by kintan on 2018/1/10.
//

import UIKit
import WebKit
extension Swifty where Base: UIScrollView {
    public func contentScrollCapture (_ completionHandler: @escaping (_ capturedImage: UIImage?) -> Void) {
        // Put a fake Cover of View
        let snapShotView = base.snapshotView(afterScreenUpdates: false)
        snapShotView?.frame = base.frame
        base.superview?.addSubview(snapShotView!)
        // Backup
        let contentOffset    = base.contentOffset
        let frame = base.frame
        let clipsToBounds = base.clipsToBounds
        base.clipsToBounds = false
        // Divide
        let page  = floorf(Float(self.base.contentSize.height / self.base.bounds.height))
        UIGraphicsBeginImageContextWithOptions(self.base.contentSize, false, UIScreen.main.scale)
        self.contentScrollPageDraw(0, maxIndex: Int(page), drawCallback: { () -> Void in
            let capturedImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            // Recover
            self.base.setContentOffset(contentOffset, animated: false)
            self.base.frame = frame
            self.base.clipsToBounds = clipsToBounds
            snapShotView?.removeFromSuperview()
            completionHandler(capturedImage)
        })
    }

    fileprivate func contentScrollPageDraw (_ index: Int, maxIndex: Int, drawCallback: @escaping () -> Void) {
        self.base.setContentOffset(CGPoint(x: -self.base.contentInset.left, y: CGFloat(index) * self.base.frame.size.height), animated: false)
        var delay = 0.6
        if base.superview is WKWebView {
            delay = 0.25
        }
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delay) { () -> Void in
            var frame = self.base.frame
            frame.size.width = self.base.contentSize.width
            self.base.frame = frame
            self.base.drawHierarchy(in: self.base.bounds, afterScreenUpdates: false)
//            self.base.layer.render(in: UIGraphicsGetCurrentContext()!)
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
