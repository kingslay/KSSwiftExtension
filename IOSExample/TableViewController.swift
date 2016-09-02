//
//  TableViewController.swift
//  IOSExample
//
//  Created by king on 16/9/1.
//  Copyright © 2016年 king. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCellWithIdentifier("cell\(indexPath.row)")!
    }
}
