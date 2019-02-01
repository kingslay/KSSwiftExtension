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
    public static func post(_ message: String) {
        shareInstance.post(message)
    }

    var messageQueue = [String]()
    var messageLabel: UILabel
    fileprivate init() {
        let statusBarFrame = CGRect(x: 0, y: 0, width: KS.SCREEN_WIDTH, height: 20)
        messageLabel = UILabel(frame: statusBarFrame)
        super.init(frame: statusBarFrame)
        windowLevel = UIWindow.Level.statusBar + 1
        backgroundColor = UIColor.clear
        isUserInteractionEnabled = false
        messageLabel.font = UIFont.systemFont(ofSize: 13)
        messageLabel.backgroundColor = UIColor(white: 0, alpha: 0.8)
        messageLabel.alpha = 0
        messageLabel.textAlignment = .center
        messageLabel.textColor = UIColor.white
        addSubview(messageLabel)
        var keyWindow = UIApplication.shared.keyWindow
        if keyWindow == nil, let delegate = UIApplication.shared.delegate {
            keyWindow = delegate.window!
        }
        makeKeyAndVisible()
        keyWindow?.makeKeyAndVisible()
    }

    public required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func post(_ message: String) {
        messageQueue.append(message)
        if messageQueue.count == 1 {
            showNextMessage()
        }
    }

    fileprivate func showNextMessage() {
        messageLabel.text = messageQueue.first
        messageLabel.alpha = 1
        isHidden = false
        let transition = CATransition()
        transition.duration = 0.3
        transition.type = .fade
        messageLabel.layer.add(transition, forKey: nil)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
            self.messageQueue.removeFirst()
            if self.messageQueue.count == 0 {
                self.messageLabel.alpha = 0
                self.isHidden = true
            } else {
                self.showNextMessage()
            }
        }
    }
}
