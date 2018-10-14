
import UIKit
extension Swifty where Base: UIViewController {
    /// wait with your own animated images
    public func pleaseWaitWithImages(_ text: String, imageNames: Array<UIImage>, timeInterval: Int) {
        SwiftNotice.wait(text, imageNames: imageNames, timeInterval: Double(timeInterval))
    }

    // api changed from v3.3
    public func noticeTop(_ text: String, autoClear: Bool = true, autoClearTime: Int = 0) {
        SwiftNotice.noticeOnSatusBar(text, autoClear: autoClear, autoClearTime: autoClearTime)
    }

    // new apis from v3.3
    public func noticeSuccess(_ text: String, autoClear: Bool = true, autoClearTime: Int = 0) {
        SwiftNotice.showNoticeWithText(NoticeType.success, text: text, autoClear: autoClear, autoClearTime: autoClearTime)
    }

    public func noticeError(_ text: String, autoClear: Bool = true, autoClearTime: Int = 0) {
        SwiftNotice.showNoticeWithText(NoticeType.error, text: text, autoClear: autoClear, autoClearTime: autoClearTime)
    }

    public func noticeInfo(_ text: String, autoClear: Bool = true, autoClearTime: Int = 0) {
        SwiftNotice.showNoticeWithText(NoticeType.info, text: text, autoClear: autoClear, autoClearTime: autoClearTime)
    }

    public func pleaseWait(_ text: String = "") {
        SwiftNotice.wait(text)
    }

    public func noticeOnlyText(_ text: String) {
        SwiftNotice.showText(text)
    }

    public func clearAllNotice() {
        SwiftNotice.clear()
    }
}

enum NoticeType {
    case success
    case error
    case info
}

class SwiftNotice: NSObject {
    static var windows = Array<UIWindow!>()
    static let rv = UIApplication.shared.keyWindow?.subviews.first as UIView!
    static var timer: DispatchSource!
    static var timerTimes = 0
    static var degree: Double {
        get {
            switch UIApplication.shared.statusBarOrientation {
            case .portrait:
                return 0
            case .portraitUpsideDown:
                return 180
            case .landscapeLeft:
                return 270
            case .landscapeRight:
                return 90
            case .unknown:
                return 0
            }
        }
    }

    static var center: CGPoint {
        var array = [UIScreen.main.bounds.width, UIScreen.main.bounds.height]
        array = array.sorted(by: <)
        let screenWidth = array[0]
        let screenHeight = array[1]
        let x = [0, screenWidth / 2, screenWidth / 2, 10, screenWidth - 10][UIApplication.shared.statusBarOrientation.hashValue] as CGFloat
        let y = [0, 10, screenHeight - 10, screenHeight / 2, screenHeight / 2][UIApplication.shared.statusBarOrientation.hashValue] as CGFloat
        return CGPoint(x: x, y: y)
    }

    // fix https://github.com/johnlui/SwiftNotice/issues/2
    // thanks broccolii(https://github.com/broccolii) and his PR https://github.com/johnlui/SwiftNotice/pull/5
    static func clear() {
        cancelPreviousPerformRequests(withTarget: self)
        if let _ = timer {
            timer.cancel()
            timer = nil
            timerTimes = 0
        }
        windows.removeAll(keepingCapacity: false)
    }

    static func noticeOnSatusBar(_ text: String, autoClear: Bool, autoClearTime: Int) {
        let frame = UIApplication.shared.statusBarFrame
        let window = UIWindow()
        window.backgroundColor = UIColor.clear
        let view = UIView()
        view.backgroundColor = UIColor(red: 0x6A / 0x100, green: 0xB4 / 0x100, blue: 0x9F / 0x100, alpha: 1)

        let label = UILabel(frame: frame)
        label.textAlignment = NSTextAlignment.center
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = UIColor.white
        label.text = text
        view.addSubview(label)

        window.frame = frame
        view.frame = frame

        window.windowLevel = UIWindow.Level.statusBar
        window.isHidden = false
        // change orientation
        window.center = center
        window.transform = CGAffineTransform(rotationAngle: CGFloat(degree * Double.pi / 180))
        window.addSubview(view)
        windows.append(window)

        if autoClear {
            let selector = #selector(SwiftNotice.hideNotice(_:))
            perform(selector, with: window, afterDelay: TimeInterval(getClearTime(text, autoClearTime: autoClearTime)))
        }
    }

    static func wait(_ text: String = "", imageNames: Array<UIImage> = Array<UIImage>(), timeInterval: Double = 0) {
        var frame = CGRect(x: 0, y: 0, width: 78, height: 78)
        let window = UIWindow()
        window.backgroundColor = UIColor.clear
        let mainView = UIView()
        mainView.layer.cornerRadius = 12
        mainView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.8)

        if imageNames.count > 0 {
            if imageNames.count > timerTimes {
                let iv = UIImageView(frame: frame)
                iv.image = imageNames.first!
                iv.contentMode = UIView.ContentMode.scaleAspectFit
                mainView.addSubview(iv)
                timer = DispatchSource.makeTimerSource(queue: .main) as! DispatchSource
                timer.schedule(deadline: .now(), repeating: timeInterval)
                timer.setEventHandler {
                    let name = imageNames[timerTimes % imageNames.count]
                    iv.image = name
                    timerTimes = timerTimes + 1
                }
                timer.resume()
            }
        } else {
            let ai = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.whiteLarge)
            ai.frame = CGRect(x: 21, y: 21, width: 36, height: 36)
            ai.startAnimating()
            mainView.addSubview(ai)
        }
        if text.count > 0 {
            let label = UILabel()
            label.text = text
            label.numberOfLines = 0
            label.font = UIFont.systemFont(ofSize: 13)
            label.textAlignment = NSTextAlignment.center
            label.textColor = UIColor.white
            mainView.addSubview(label)
            let size = label.sizeThatFits(CGSize(width: UIScreen.main.bounds.width - frame.width - 31, height: UIScreen.main.bounds.height))
            label.ks.size(size)
            label.ks.left(frame.width)
            frame.size.width = label.ks.right + 21
            if size.height > frame.height {
                frame.size.height = size.height
            }
            label.ks.centerY(frame.height / 2)
        }
        window.frame = frame
        mainView.frame = frame

        window.windowLevel = UIWindow.Level.alert
        window.center = getRealCenter()
        // change orientation
        window.transform = CGAffineTransform(rotationAngle: CGFloat(degree * Double.pi / 180))
        window.isHidden = false
        window.addSubview(mainView)
        windows.append(window)
    }

    static func showText(_ text: String) {
        let window = UIWindow()
        window.backgroundColor = UIColor.clear
        let mainView = UIView()
        mainView.layer.cornerRadius = 12
        mainView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.8)

        let label = UILabel()
        label.text = text
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 13)
        label.textAlignment = NSTextAlignment.center
        label.textColor = UIColor.white
        label.sizeToFit()
        mainView.addSubview(label)

        let superFrame = CGRect(x: 0, y: 0, width: label.frame.width + 50, height: label.frame.height + 30)
        window.frame = superFrame
        mainView.frame = superFrame

        label.center = mainView.center

        window.windowLevel = UIWindow.Level.alert
        window.center = getRealCenter()
        // change orientation
        window.transform = CGAffineTransform(rotationAngle: CGFloat(degree * Double.pi / 180))
        window.isHidden = false
        window.addSubview(mainView)
        windows.append(window)
        let selector = #selector(SwiftNotice.hideNotice(_:))
        perform(selector, with: window, afterDelay: TimeInterval(getClearTime(text)))
    }

    static func showNoticeWithText(_ type: NoticeType, text: String, autoClear: Bool, autoClearTime: Int) {
        var frame = CGRect(x: 0, y: 0, width: 150, height: 150)
        let window = UIWindow()
        window.backgroundColor = UIColor.clear
        let mainView = UIView()
        mainView.layer.cornerRadius = 10
        mainView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.7)

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
        checkmarkView.frame = CGRect(x: 0, y: 15, width: 36, height: 36)
        mainView.addSubview(checkmarkView)

        let label = UILabel(frame: CGRect(x: 5, y: 60, width: frame.size.width - 10, height: 16))
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = UIColor.white
        label.text = text
        label.textAlignment = NSTextAlignment.center
        label.sizeToFit()
        mainView.addSubview(label)
        frame.size.height = label.frame.origin.y + label.frame.size.height + 14
        window.frame = frame
        mainView.frame = frame
        label.ks.centerX(mainView.ks.centerX)
        checkmarkView.ks.centerX(mainView.ks.centerX)

        window.windowLevel = UIWindow.Level.alert
        window.center = getRealCenter()
        // change orientation
        window.transform = CGAffineTransform(rotationAngle: CGFloat(degree * Double.pi / 180))
        window.isHidden = false
        window.addSubview(mainView)
        windows.append(window)

        if autoClear {
            let selector = #selector(SwiftNotice.hideNotice(_:))
            perform(selector, with: window, afterDelay: TimeInterval(getClearTime(text, autoClearTime: autoClearTime)))
        }
    }

    // fix https://github.com/johnlui/SwiftNotice/issues/2
    @objc static func hideNotice(_ sender: AnyObject) {
        if let window = sender as? UIWindow {
            if let index = windows.index(where: { (item) -> Bool in
                item == window
            }) {
                windows.remove(at: index)
            }
        }
    }

    // fix orientation problem
    static func getRealCenter() -> CGPoint {
        if UIApplication.shared.statusBarOrientation.hashValue >= 3 {
            return CGPoint(x: rv!.center.y, y: rv!.center.x)
        } else {
            return rv!.center
        }
    }

    static func getClearTime(_ text: String, autoClearTime: Int = 0) -> Double {
        if autoClearTime == 0 {
            return max(Double(text.count) * 0.08 + 0.3, 1)
        } else {
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

    class func draw(_ type: NoticeType) {
        let checkmarkShapePath = UIBezierPath()

        // draw circle
        checkmarkShapePath.move(to: CGPoint(x: 36, y: 18))
        checkmarkShapePath.addArc(withCenter: CGPoint(x: 18, y: 18), radius: 17.5, startAngle: 0, endAngle: CGFloat(Double.pi * 2), clockwise: true)
        checkmarkShapePath.close()

        switch type {
        case .success: // draw checkmark
            checkmarkShapePath.move(to: CGPoint(x: 10, y: 18))
            checkmarkShapePath.addLine(to: CGPoint(x: 16, y: 24))
            checkmarkShapePath.addLine(to: CGPoint(x: 27, y: 13))
            checkmarkShapePath.move(to: CGPoint(x: 10, y: 18))
            checkmarkShapePath.close()
        case .error: // draw X
            checkmarkShapePath.move(to: CGPoint(x: 10, y: 10))
            checkmarkShapePath.addLine(to: CGPoint(x: 26, y: 26))
            checkmarkShapePath.move(to: CGPoint(x: 10, y: 26))
            checkmarkShapePath.addLine(to: CGPoint(x: 26, y: 10))
            checkmarkShapePath.move(to: CGPoint(x: 10, y: 10))
            checkmarkShapePath.close()
        case .info:
            checkmarkShapePath.move(to: CGPoint(x: 18, y: 6))
            checkmarkShapePath.addLine(to: CGPoint(x: 18, y: 22))
            checkmarkShapePath.move(to: CGPoint(x: 18, y: 6))
            checkmarkShapePath.close()

            UIColor.white.setStroke()
            checkmarkShapePath.stroke()

            let checkmarkShapePath = UIBezierPath()
            checkmarkShapePath.move(to: CGPoint(x: 18, y: 27))
            checkmarkShapePath.addArc(withCenter: CGPoint(x: 18, y: 27), radius: 1, startAngle: 0, endAngle: CGFloat(Double.pi * 2), clockwise: true)
            checkmarkShapePath.close()

            UIColor.white.setFill()
            checkmarkShapePath.fill()
        }

        UIColor.white.setStroke()
        checkmarkShapePath.stroke()
    }

    class var imageOfCheckmark: UIImage {
        if Cache.imageOfCheckmark != nil {
            return Cache.imageOfCheckmark!
        }
        UIGraphicsBeginImageContextWithOptions(CGSize(width: 36, height: 36), false, 0)

        SwiftNoticeSDK.draw(NoticeType.success)

        Cache.imageOfCheckmark = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return Cache.imageOfCheckmark!
    }

    class var imageOfCross: UIImage {
        if Cache.imageOfCross != nil {
            return Cache.imageOfCross!
        }
        UIGraphicsBeginImageContextWithOptions(CGSize(width: 36, height: 36), false, 0)

        SwiftNoticeSDK.draw(NoticeType.error)

        Cache.imageOfCross = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return Cache.imageOfCross!
    }

    class var imageOfInfo: UIImage {
        if Cache.imageOfInfo != nil {
            return Cache.imageOfInfo!
        }
        UIGraphicsBeginImageContextWithOptions(CGSize(width: 36, height: 36), false, 0)

        SwiftNoticeSDK.draw(NoticeType.info)

        Cache.imageOfInfo = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return Cache.imageOfInfo!
    }
}
