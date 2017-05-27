//
//  KSDebug.swift
//  Pods
//
//  Created by kintan on 2017/5/27.
//
//

import UIKit

public extension UIViewController {
    func ksmotionBegan(_ motion: UIEventSubtype, with event: UIEvent?) {
        let overlayClass = NSClassFromString("UIDebuggingInformationOverlay") as? UIWindow.Type
        _=overlayClass?.perform(NSSelectorFromString("prepareDebuggingOverlay"))
        let overlay = overlayClass?.perform(NSSelectorFromString("overlay")).takeUnretainedValue() as? UIWindow
        _=overlay?.perform(NSSelectorFromString("toggleVisibility"))

    }
}
