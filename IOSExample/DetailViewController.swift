//
//  DetailViewController.swift
//  IOSExample
//
//  Created by king on 16/3/29.
//  Copyright © 2016年 king. All rights reserved.
//

import KSSwiftExtension
import UIKit
class DetailViewController: UIViewController {
    @IBOutlet var detailDescriptionLabel: UILabel!

    var detailItem: AnyObject? {
        didSet {
            // Update the view.
            configureView()
        }
    }

    func configureView() {
        // Update the user interface for the detail item.
        if let detail = self.detailItem {
            if let label = self.detailDescriptionLabel {
                label.text = detail.description
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        configureView()
        ks.autoAdjustKeyBoard()
        let a = NotificationCenter.default.addObserver(forName: UIApplication.didBecomeActiveNotification, object: nil, queue: nil) { _ in
            print(self)
        }
        NotificationCenter.default.removeObserver(a)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
