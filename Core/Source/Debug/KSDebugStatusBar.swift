//
//  KSDebugStatusBar.swift
//  KSSwiftExtension
//
//  Created by king on 16/3/29.
//  Copyright © 2016年 king. All rights reserved.
//

import UIKit

open class KSDebugStatusBar: UIWindow {
    static let shareInstance = KSDebugStatusBar()
    open static func post(_ message: String) {
        shareInstance.post(message)
    }
    var messageQueue = [String]()
    var messageLabel: UILabel
    fileprivate init() {
        let statusBarFrame = CGRect(x: 0,y: 0,width: KS.SCREEN_WIDTH,height: 20)
        self.messageLabel = UILabel(frame: statusBarFrame)
        super.init(frame: statusBarFrame)
        self.windowLevel = UIWindowLevelStatusBar + 1
        self.backgroundColor = UIColor.clear;
        self.isUserInteractionEnabled = false
        self.messageLabel.font = UIFont.systemFont(ofSize: 13)
        self.messageLabel.backgroundColor = UIColor.init(white: 0, alpha: 0.8)
        self.messageLabel.alpha = 0
        self.messageLabel.textAlignment = .center;
        self.messageLabel.textColor = UIColor.white
        self.addSubview(self.messageLabel)
        var keyWindow = UIApplication.shared.keyWindow
        if keyWindow == nil, let delegate = UIApplication.shared.delegate {
            keyWindow = delegate.window!
        }
        self.makeKeyAndVisible()
        keyWindow?.makeKeyAndVisible()

    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func post(_ message: String) {
        self.messageQueue.append(message)
        if self.messageQueue.count == 1 {
            self.showNextMessage()
        }
    }
    fileprivate func showNextMessage() {
        self.messageLabel.text = self.messageQueue.first
        self.messageLabel.alpha = 1
        self.isHidden = false
        let transition = CATransition()
        transition.duration = 0.3
        transition.type = kCATransitionFade
        self.messageLabel.layer.add(transition, forKey: nil)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
            self.messageQueue.removeFirst()
            if self.messageQueue.count == 0 {
                self.messageLabel.alpha = 0
                self.isHidden = true
            }else{
                self.showNextMessage()
            }
        }
    }
}
