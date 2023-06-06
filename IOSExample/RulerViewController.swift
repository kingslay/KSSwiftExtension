//
//  RulerViewController.swift
//  IOSExample
//
//  Created by king on 16/9/1.
//  Copyright © 2016年 king. All rights reserved.
//

import UIKit
import KSSwiftExtension
class RulerViewController: UIViewController {

    @IBOutlet weak var rulerView: KSRulerView!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        rulerView.showRulerScrollViewWithCount(200, beginValue: 100, endValue: 300)
        rulerView.currentValue = 190
    }
}
