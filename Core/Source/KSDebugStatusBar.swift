//
//  KSDebugStatusBar.swift
//  KSSwiftExtension
//
//  Created by king on 16/3/29.
//  Copyright © 2016年 king. All rights reserved.
//

import UIKit

public class KSDebugStatusBar: UIWindow {
    static let shareInstance = KSDebugStatusBar()
    public static func post(message: String) {
        shareInstance.post(message)
    }
    var messageQueue = [String]()
    var messageLabel: UILabel
    private init() {
        let statusBarFrame = CGRect(x: 0,y: 0,width: KS.SCREEN_WIDTH,height: 20)
        self.messageLabel = UILabel(frame: statusBarFrame)
        super.init(frame: statusBarFrame)
        self.windowLevel = UIWindowLevelStatusBar + 1
        self.backgroundColor = UIColor.clearColor();
        self.userInteractionEnabled = false
        self.messageLabel.font = UIFont.systemFontOfSize(13)
        self.messageLabel.backgroundColor = UIColor.init(white: 0, alpha: 0.8)
        self.messageLabel.alpha = 0
        self.messageLabel.textAlignment = .Center;
        self.messageLabel.textColor = UIColor.whiteColor()
        self.addSubview(self.messageLabel)
        var keyWindow = UIApplication.sharedApplication().keyWindow
        if keyWindow == nil, let delegate = UIApplication.sharedApplication().delegate {
            keyWindow = delegate.window!
        }
        self.makeKeyAndVisible()
        keyWindow?.makeKeyAndVisible()

    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func post(message: String) {
        self.messageQueue.append(message)
        if self.messageQueue.count == 1 {
            self.showNextMessage()
        }
    }
    private func showNextMessage() {
        self.messageLabel.text = self.messageQueue.first
        self.messageLabel.alpha = 1
        self.hidden = false
        let transition = CATransition()
        transition.duration = 0.3
        transition.type = kCATransitionFade
        self.messageLabel.layer.addAnimation(transition, forKey: nil)
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(1 * NSEC_PER_SEC)), dispatch_get_main_queue()) {
            self.messageQueue.removeFirst()
            if self.messageQueue.count == 0 {
                self.messageLabel.alpha = 0
                self.hidden = true
            }else{
                self.showNextMessage()
            }
        }
    }
}
