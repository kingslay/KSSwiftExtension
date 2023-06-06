
import UIKit
extension Swifty where Base: UIViewController {
    /// wait with your own animated images
    public func pleaseWaitWithImages(text: String, imageNames: Array<UIImage>, timeInterval: Int) {
        SwiftNotice.wait(text, imageNames: imageNames, timeInterval: timeInterval)
    }
    // api changed from v3.3
    public func noticeTop(text: String, autoClear: Bool = true, autoClearTime: Int = 0) {
        SwiftNotice.noticeOnSatusBar(text, autoClear: autoClear, autoClearTime: autoClearTime)
    }
    
    // new apis from v3.3
    public func noticeSuccess(text: String, autoClear: Bool = true, autoClearTime: Int = 0) {
        SwiftNotice.showNoticeWithText(NoticeType.success, text: text, autoClear: autoClear, autoClearTime: autoClearTime)
    }
    public func noticeError(text: String, autoClear: Bool = true, autoClearTime: Int = 0) {
        SwiftNotice.showNoticeWithText(NoticeType.error, text: text, autoClear: autoClear, autoClearTime: autoClearTime)
    }
    public func noticeInfo(text: String, autoClear: Bool = true, autoClearTime: Int = 0) {
        SwiftNotice.showNoticeWithText(NoticeType.info, text: text, autoClear: autoClear, autoClearTime: autoClearTime)
    }
    public func pleaseWait(text: String = "") {
        SwiftNotice.wait(text)
    }
    public func noticeOnlyText(text: String) {
        SwiftNotice.showText(text)
    }
    public func clearAllNotice() {
        SwiftNotice.clear()
    }
}

enum NoticeType{
    case success
    case error
    case info
}

class SwiftNotice: NSObject {
    
    static var windows = Array<UIWindow!>()
    static let rv = UIApplication.sharedApplication().keyWindow?.subviews.first as UIView!
    static var timer: dispatch_source_t!
    static var timerTimes = 0
    static var degree: Double {
        get {
            return [0, 0, 180, 270, 90][UIApplication.sharedApplication().statusBarOrientation.hashValue] as Double
        }
    }
    static var center: CGPoint {
        get {
            var array = [UIScreen.mainScreen().bounds.width, UIScreen.mainScreen().bounds.height]
            array = array.sort(<)
            let screenWidth = array[0]
            let screenHeight = array[1]
            let x = [0, screenWidth/2, screenWidth/2, 10, screenWidth-10][UIApplication.sharedApplication().statusBarOrientation.hashValue] as CGFloat
            let y = [0, 10, screenHeight-10, screenHeight/2, screenHeight/2][UIApplication.sharedApplication().statusBarOrientation.hashValue] as CGFloat
            return CGPointMake(x, y)
        }
    }
    
    // fix https://github.com/johnlui/SwiftNotice/issues/2
    // thanks broccolii(https://github.com/broccolii) and his PR https://github.com/johnlui/SwiftNotice/pull/5
    static func clear() {
        self.cancelPreviousPerformRequestsWithTarget(self)
        if let _ = timer {
            dispatch_source_cancel(timer)
            timer = nil
            timerTimes = 0
        }
        windows.removeAll(keepCapacity: false)
    }
    
    static func noticeOnSatusBar(text: String, autoClear: Bool, autoClearTime: Int) {
        let frame = UIApplication.sharedApplication().statusBarFrame
        let window = UIWindow()
        window.backgroundColor = UIColor.clearColor()
        let view = UIView()
        view.backgroundColor = UIColor(red: 0x6a/0x100, green: 0xb4/0x100, blue: 0x9f/0x100, alpha: 1)
        
        let label = UILabel(frame: frame)
        label.textAlignment = NSTextAlignment.Center
        label.font = UIFont.systemFontOfSize(12)
        label.textColor = UIColor.whiteColor()
        label.text = text
        view.addSubview(label)
        
        window.frame = frame
        view.frame = frame
        
        window.windowLevel = UIWindowLevelStatusBar
        window.hidden = false
        // change orientation
        window.center = center
        window.transform = CGAffineTransformMakeRotation(CGFloat(degree * M_PI / 180))
        window.addSubview(view)
        windows.append(window)
        
        if autoClear {
            let selector = #selector(SwiftNotice.hideNotice(_:))
            self.performSelector(selector, withObject: window, afterDelay: NSTimeInterval(getClearTime(text,autoClearTime: autoClearTime)))
        }
    }
    static func wait(text: String = "", imageNames: Array<UIImage> = Array<UIImage>(), timeInterval: Int = 0) {
        var frame = CGRectMake(0, 0, 78, 78)
        let window = UIWindow()
        window.backgroundColor = UIColor.clearColor()
        let mainView = UIView()
        mainView.layer.cornerRadius = 12
        mainView.backgroundColor = UIColor(red:0, green:0, blue:0, alpha: 0.8)
        
        if imageNames.count > 0 {
            if imageNames.count > timerTimes {
                let iv = UIImageView(frame: frame)
                iv.image = imageNames.first!
                iv.contentMode = UIViewContentMode.ScaleAspectFit
                mainView.addSubview(iv)
                timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_main_queue())
                dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, UInt64(timeInterval) * NSEC_PER_MSEC, 0)
                dispatch_source_set_event_handler(timer, { () -> Void in
                    let name = imageNames[timerTimes % imageNames.count]
                    iv.image = name
                    timerTimes = timerTimes+1
                })
                dispatch_resume(timer)
            }
        } else {
            let ai = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.WhiteLarge)
            ai.frame = CGRectMake(21, 21, 36, 36)
            ai.startAnimating()
            mainView.addSubview(ai)
        }
        if text.length > 0 {
            let label = UILabel()
            label.text = text
            label.numberOfLines = 0
            label.font = UIFont.systemFontOfSize(13)
            label.textAlignment = NSTextAlignment.Center
            label.textColor = UIColor.whiteColor()
            mainView.addSubview(label)
            let size = label.sizeThatFits(CGSizeMake(UIScreen.mainScreen().bounds.width-frame.width-31, UIScreen.mainScreen().bounds.height))
            label.ks.size(size)
            label.ks.left(frame.width)
            frame.size.width = label.ks.right + 21
            if size.height > frame.height {
                frame.size.height = size.height
            }
            label.ks.centerY(frame.height/2)
        }
        window.frame = frame
        mainView.frame = frame
        
        window.windowLevel = UIWindowLevelAlert
        window.center = getRealCenter()
        // change orientation
        window.transform = CGAffineTransformMakeRotation(CGFloat(degree * M_PI / 180))
        window.hidden = false
        window.addSubview(mainView)
        windows.append(window)
    }
    static func showText(text: String) {
        let window = UIWindow()
        window.backgroundColor = UIColor.clearColor()
        let mainView = UIView()
        mainView.layer.cornerRadius = 12
        mainView.backgroundColor = UIColor(red:0, green:0, blue:0, alpha: 0.8)
        
        let label = UILabel()
        label.text = text
        label.numberOfLines = 0
        label.font = UIFont.systemFontOfSize(13)
        label.textAlignment = NSTextAlignment.Center
        label.textColor = UIColor.whiteColor()
        label.sizeToFit()
        mainView.addSubview(label)
        
        let superFrame = CGRectMake(0, 0, label.frame.width + 50 , label.frame.height + 30)
        window.frame = superFrame
        mainView.frame = superFrame
        
        label.center = mainView.center
        
        window.windowLevel = UIWindowLevelAlert
        window.center = getRealCenter()
        // change orientation
        window.transform = CGAffineTransformMakeRotation(CGFloat(degree * M_PI / 180))
        window.hidden = false
        window.addSubview(mainView)
        windows.append(window)
        let selector = #selector(SwiftNotice.hideNotice(_:))
        self.performSelector(selector, withObject: window, afterDelay: NSTimeInterval(getClearTime(text)))
    }
    
    static func showNoticeWithText(type: NoticeType,text: String, autoClear: Bool, autoClearTime: Int) {
        var frame = CGRectMake(0, 0, 150, 150)
        let window = UIWindow()
        window.backgroundColor = UIColor.clearColor()
        let mainView = UIView()
        mainView.layer.cornerRadius = 10
        mainView.backgroundColor = UIColor(red:0, green:0, blue:0, alpha: 0.7)
        
        var image = UIImage()
        switch type {
        case .success:
            image = SwiftNoticeSDK.imageOfCheckmark
        case .error:
            image = SwiftNoticeSDK.imageOfCross
        case .info:
            image = SwiftNoticeSDK.imageOfInfo
        }
        let checkmarkView = UIImageView(image: image)
        checkmarkView.frame = CGRectMake(0, 15, 36, 36)
        mainView.addSubview(checkmarkView)
        
        let label = UILabel(frame: CGRectMake(5, 60, frame.size.width-10, 16))
        label.numberOfLines = 0
        label.font = UIFont.systemFontOfSize(13)
        label.textColor = UIColor.whiteColor()
        label.text = text
        label.textAlignment = NSTextAlignment.Center
        label.sizeToFit()
        mainView.addSubview(label)
        frame.size.height = label.frame.origin.y + label.frame.size.height + 14
        window.frame = frame
        mainView.frame = frame
        label.ks.centerX(mainView.ks.centerX)
        checkmarkView.ks.centerX(mainView.ks.centerX)
        
        window.windowLevel = UIWindowLevelAlert
        window.center = getRealCenter()
        // change orientation
        window.transform = CGAffineTransformMakeRotation(CGFloat(degree * M_PI / 180))
        window.hidden = false
        window.addSubview(mainView)
        windows.append(window)
        
        if autoClear {
            let selector = #selector(SwiftNotice.hideNotice(_:))
            self.performSelector(selector, withObject: window, afterDelay: NSTimeInterval(getClearTime(text,autoClearTime: autoClearTime)))
        }
    }
    
    // fix https://github.com/johnlui/SwiftNotice/issues/2
    static func hideNotice(sender: AnyObject) {
        if let window = sender as? UIWindow {
            if let index = windows.indexOf({ (item) -> Bool in
                return item == window
            }) {
                windows.removeAtIndex(index)
            }
        }
    }
    
    // fix orientation problem
    static func getRealCenter() -> CGPoint {
        if UIApplication.sharedApplication().statusBarOrientation.hashValue >= 3 {
            return CGPoint(x: rv.center.y, y: rv.center.x)
        } else {
            return rv.center
        }
    }
    static func getClearTime(text: String,autoClearTime:Int = 0) -> Double{
        if autoClearTime == 0 {
            return max(Double(text.length) * 0.08 + 0.3,1)
        }else{
            return Double(autoClearTime)
        }
    }
}

class SwiftNoticeSDK {
    struct Cache {
        static var imageOfCheckmark: UIImage?
        static var imageOfCross: UIImage?
        static var imageOfInfo: UIImage?
    }
    class func draw(type: NoticeType) {
        let checkmarkShapePath = UIBezierPath()
        
        // draw circle
        checkmarkShapePath.moveToPoint(CGPointMake(36, 18))
        checkmarkShapePath.addArcWithCenter(CGPointMake(18, 18), radius: 17.5, startAngle: 0, endAngle: CGFloat(M_PI*2), clockwise: true)
        checkmarkShapePath.closePath()
        
        switch type {
        case .success: // draw checkmark
            checkmarkShapePath.moveToPoint(CGPointMake(10, 18))
            checkmarkShapePath.addLineToPoint(CGPointMake(16, 24))
            checkmarkShapePath.addLineToPoint(CGPointMake(27, 13))
            checkmarkShapePath.moveToPoint(CGPointMake(10, 18))
            checkmarkShapePath.closePath()
        case .error: // draw X
            checkmarkShapePath.moveToPoint(CGPointMake(10, 10))
            checkmarkShapePath.addLineToPoint(CGPointMake(26, 26))
            checkmarkShapePath.moveToPoint(CGPointMake(10, 26))
            checkmarkShapePath.addLineToPoint(CGPointMake(26, 10))
            checkmarkShapePath.moveToPoint(CGPointMake(10, 10))
            checkmarkShapePath.closePath()
        case .info:
            checkmarkShapePath.moveToPoint(CGPointMake(18, 6))
            checkmarkShapePath.addLineToPoint(CGPointMake(18, 22))
            checkmarkShapePath.moveToPoint(CGPointMake(18, 6))
            checkmarkShapePath.closePath()
            
            UIColor.whiteColor().setStroke()
            checkmarkShapePath.stroke()
            
            let checkmarkShapePath = UIBezierPath()
            checkmarkShapePath.moveToPoint(CGPointMake(18, 27))
            checkmarkShapePath.addArcWithCenter(CGPointMake(18, 27), radius: 1, startAngle: 0, endAngle: CGFloat(M_PI*2), clockwise: true)
            checkmarkShapePath.closePath()
            
            UIColor.whiteColor().setFill()
            checkmarkShapePath.fill()
        }
        
        UIColor.whiteColor().setStroke()
        checkmarkShapePath.stroke()
    }
    class var imageOfCheckmark: UIImage {
        if (Cache.imageOfCheckmark != nil) {
            return Cache.imageOfCheckmark!
        }
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(36, 36), false, 0)
        
        SwiftNoticeSDK.draw(NoticeType.success)
        
        Cache.imageOfCheckmark = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return Cache.imageOfCheckmark!
    }
    class var imageOfCross: UIImage {
        if (Cache.imageOfCross != nil) {
            return Cache.imageOfCross!
        }
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(36, 36), false, 0)
        
        SwiftNoticeSDK.draw(NoticeType.error)
        
        Cache.imageOfCross = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return Cache.imageOfCross!
    }
    class var imageOfInfo: UIImage {
        if (Cache.imageOfInfo != nil) {
            return Cache.imageOfInfo!
        }
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(36, 36), false, 0)
        
        SwiftNoticeSDK.draw(NoticeType.info)
        
        Cache.imageOfInfo = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return Cache.imageOfInfo!
    }
}
