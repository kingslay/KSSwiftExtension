//
//  TableViewController.swift
//  IOSExample
//
//  Created by king on 16/9/1.
//  Copyright © 2016年 king. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: "cell\((indexPath as NSIndexPath).row)")!
    }
}
