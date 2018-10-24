//
//  CitySearchResultVC.swift
//  CFCityPickerVC
//
//  Created by 冯成林 on 15/8/6.
//  Copyright (c) 2015年 冯成林. All rights reserved.
//

import UIKit

class CitySearchResultVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var touchBeganAction: (() -> Void)!
    var tableViewScrollAction: (() -> Void)!
    var tableViewDidSelectedRowAction: ((cityModel: CityModel) -> Void)!

    var cityModels: [CityModel]! { didSet { dataPrepare() } }

    @IBOutlet var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
    }
}

extension CitySearchResultVC {
    func tableView(tableView _: UITableView, numberOfRowsInSection _: Int) -> Int {
        if cityModels == nil { return 0 }

        return cityModels.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = CFCityCell.cityCellInTableView(tableView)

        cell.cityModel = cityModels[indexPath.item]

        return cell
    }

    func tableView(tableView _: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableViewDidSelectedRowAction?(cityModel: cityModels[indexPath.row])
    }

    func tableView(tableView _: UITableView, titleForHeaderInSection _: Int) -> String? {
        if cityModels == nil { return nil }
        return "共检索到\(cityModels.count)到记录"
    }

    override func touchesBegan(touches _: Set<UITouch>, withEvent _: UIEvent?) {
        touchBeganAction?()
    }

    func dataPrepare() {
        tableView.hidden = cityModels == nil

        tableView.reloadData()
    }

    func scrollViewDidScroll(scrollView _: UIScrollView) {
        tableViewScrollAction?()
    }
}
