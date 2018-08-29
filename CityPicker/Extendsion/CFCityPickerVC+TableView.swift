//
//  CFCityPickerVC+TableView.swift
//  CFCityPickerVC
//
//  Created by 冯成林 on 15/7/30.
//  Copyright (c) 2015年 冯成林. All rights reserved.
//

import Foundation
import UIKit

extension CFCityPickerVC: UITableViewDataSource, UITableViewDelegate {
    var searchH: CGFloat { return 60 }

    private var currentCityModel: CityModel? { if currentCity == nil { return nil }; return CityModel.findCityModelWithCityName([self.currentCity], cityModels: cityModels, isFuzzy: false)?.first }
    private var hotCityModels: [CityModel]? { if hotCities == nil { return nil }; return CityModel.findCityModelWithCityName(hotCities, cityModels: cityModels, isFuzzy: false) }
    private var historyModels: [CityModel]? { if selectedCityArray.count == 0 { return nil }; return CityModel.findCityModelWithCityName(selectedCityArray, cityModels: cityModels, isFuzzy: false) }

    private var headViewWith: CGFloat { return UIScreen.mainScreen().bounds.width - 10 }

    private var headerViewH: CGFloat {
        let h0: CGFloat = searchH
        let h1: CGFloat = 100
        var h2: CGFloat = 100; if historyModels?.count > 4 { h2 += 40 }
        var h3: CGFloat = 100; if hotCities?.count > 4 { h3 += 40 }
        return h0 + h1 + h2 + h3
    }

    private var sortedCityModles: [CityModel] {
        return cityModels.sort({ (m1, m2) -> Bool in
            m1.getFirstUpperLetter < m2.getFirstUpperLetter
        })
    }

    /** 计算高度 */
    private func headItemViewH(count: Int) -> CGRect {
        let height: CGFloat = count <= 4 ? 96 : 140
        return CGRectMake(0, 0, headViewWith, height)
    }

    /** 为tableView准备 */
    func tableViewPrepare() {
        title = "城市选择"

        tableView = UITableView(frame: CGRectZero, style: UITableViewStyle.Plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self

        // vfl
        let viewDict = ["tableView": tableView]
        let vfl_arr_H = NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[tableView]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict)
        let vfl_arr_V = NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[tableView]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict)

        view.addConstraints(vfl_arr_H)
        view.addConstraints(vfl_arr_V)
    }

    func notiAction(noti: NSNotification) {
        let userInfo = noti.userInfo as! [String: CityModel]
        let cityModel = userInfo["citiModel"]!
        citySelected(cityModel)
    }

    /** 定位处理 */
    func locationPrepare() {
        if currentCity != nil { return }

        // 定位开始
        let location = LocationManager.sharedInstance

        location.autoUpdate = true

        location.startUpdatingLocationWithCompletionHandler { (latitude, longitude, _, _, error) -> Void in

            location.stopUpdatingLocation()

            location.reverseGeocodeLocationWithLatLon(latitude: latitude, longitude: longitude, onReverseGeocodingCompletionHandler: { (_, placemark, error) -> Void in

                guard error == nil else { return }
                guard let placemark = placemark, let locality = placemark.locality else { return }
                self.currentCity = (locality as NSString).stringByReplacingOccurrencesOfString("市", withString: "")

            })
        }
    }

    /** headerView */
    func headerviewPrepare() {
        let headerView = UIView()

        // 搜索框
        searchBar = CitySearchBar()
        headerView.addSubview(searchBar)

        // vfl
        let searchBarViewDict = ["searchBar": searchBar]
        let searchBar_vfl_arr_H = NSLayoutConstraint.constraintsWithVisualFormat("H:|-18-[searchBar]-20-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: searchBarViewDict)
        let searchBar_vfl_arr_V = NSLayoutConstraint.constraintsWithVisualFormat("V:|-10-[searchBar(==36)]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: searchBarViewDict)
        headerView.addConstraints(searchBar_vfl_arr_H)
        headerView.addConstraints(searchBar_vfl_arr_V)

        searchBar.searchAction = { (searchText: String) -> Void in

            print(searchText)
        }

        searchBar.searchBarShouldBeginEditing = { [unowned self] in

            self.navigationController?.setNavigationBarHidden(true, animated: true)

            self.searchRVC.cityModels = nil

            UIView.animateWithDuration(0.15, animations: { [unowned self] () -> Void in
                self.searchRVC.view.alpha = 1
            })
        }

        searchBar.searchBarDidEndditing = { [unowned self] in

            if self.searchRVC.cityModels != nil { return }

            self.searchBar.setShowsCancelButton(false, animated: true)
            self.searchBar.text = ""

            self.navigationController?.setNavigationBarHidden(false, animated: true)

            UIView.animateWithDuration(0.14, animations: { [unowned self] () -> Void in
                self.searchRVC.view.alpha = 0
            })
        }

        searchBar.searchTextDidChangedAction = { [unowned self] (text: String) in

            if text.characters.count == 0 { self.searchRVC.cityModels = nil; return }

            let searchCityModols = CityModel.searchCityModelsWithCondition(text, cities: self.cityModels)

            self.searchRVC.cityModels = searchCityModols
        }

        searchBar.searchBarCancelAction = { [unowned self] in

            self.searchRVC.cityModels = nil
            self.searchBar.searchBarDidEndditing?()
        }

        // SeatchResultVC
        searchRVC = CitySearchResultVC(nibName: "CitySearchResultVC", bundle: nil)
        addChildViewController(searchRVC)

        view.addSubview(searchRVC.view)
        view.bringSubviewToFront(searchRVC.view)
        searchRVC.view.translatesAutoresizingMaskIntoConstraints = false
        // vfl
        let maskViewDict = ["maskView": searchRVC.view]
        let maskView_vfl_arr_H = NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[maskView]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: maskViewDict)
        let maskView_vfl_arr_V = NSLayoutConstraint.constraintsWithVisualFormat("V:|-80-[maskView]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: maskViewDict)
        view.addConstraints(maskView_vfl_arr_H)
        view.addConstraints(maskView_vfl_arr_V)
        searchRVC.view.alpha = 0
        searchRVC.touchBeganAction = { [unowned self] in
            self.searchBar.endEditing(true)
        }

        searchRVC.tableViewScrollAction = { [unowned self] in
            self.searchBar.endEditing(true)
        }

        searchRVC.tableViewDidSelectedRowAction = { [unowned self] (cityModel: CityModel) in

            self.citySelected(cityModel)
        }

        headerView.frame = CGRectMake(0, 0, headViewWith, headerViewH)

        let itemView = HeaderItemView.getHeaderItemView("当前城市")
        currentCityItemView = itemView
        var currentCities: [CityModel] = []
        if currentCityModel != nil { currentCities.append(currentCityModel!) }
        itemView.cityModles = currentCities
        var frame1 = headItemViewH(itemView.cityModles.count)
        frame1.origin.y = searchH
        itemView.frame = frame1
        headerView.addSubview(itemView)

        let itemView2 = HeaderItemView.getHeaderItemView("历史选择")
        var historyCityModels: [CityModel] = []
        if historyModels != nil { historyCityModels += historyModels! }
        itemView2.cityModles = historyCityModels
        var frame2 = headItemViewH(itemView2.cityModles.count)
        frame2.origin.y = CGRectGetMaxY(frame1)
        itemView2.frame = frame2
        headerView.addSubview(itemView2)

        let itemView3 = HeaderItemView.getHeaderItemView("热门城市")
        var hotCityModels: [CityModel] = []
        if self.hotCityModels != nil { hotCityModels += self.hotCityModels! }
        itemView3.cityModles = hotCityModels
        var frame3 = headItemViewH(itemView3.cityModles.count)
        frame3.origin.y = CGRectGetMaxY(frame2)
        itemView3.frame = frame3
        headerView.addSubview(itemView3)

        tableView?.tableHeaderView = headerView
    }

    /**  定位到具体的城市了  */
    func getedCurrentCityWithName(currentCityName _: String) {
        if currentCityModel == nil { return }
        if currentCityItemView?.cityModles.count != 0 { return }
        currentCityItemView?.cityModles = [self.currentCityModel!]
    }

    /** 处理label */
    func labelPrepare() {
        indexTitleLabel.backgroundColor = CFCityPickerVC.rgba(0, g: 0, b: 0, a: 0.4)
        indexTitleLabel.center = view.center
        indexTitleLabel.bounds = CGRectMake(0, 0, 120, 100)
        indexTitleLabel.font = UIFont.boldSystemFontOfSize(80)
        indexTitleLabel.textAlignment = NSTextAlignment.Center
        indexTitleLabel.textColor = UIColor.whiteColor()
    }

    func numberOfSectionsInTableView(tableView _: UITableView) -> Int {
        return sortedCityModles.count
    }

    func tableView(tableView _: UITableView, numberOfRowsInSection section: Int) -> Int {
        let children = sortedCityModles[section].children

        return children == nil ? 0 : children!.count
    }

    func tableView(tableView _: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sortedCityModles[section].name
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = CFCityCell.cityCellInTableView(tableView)

        cell.cityModel = sortedCityModles[indexPath.section].children?[indexPath.item]

        return cell
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)

        let cityModel = sortedCityModles[indexPath.section].children![indexPath.row]
        citySelected(cityModel)
    }

    func tableView(tableView _: UITableView, heightForHeaderInSection _: Int) -> CGFloat {
        return 44
    }

    func sectionIndexTitlesForTableView(tableView _: UITableView) -> [String]? {
        return indexHandle()
    }

    func tableView(tableView _: UITableView, sectionForSectionIndexTitle title: String, atIndex index: Int) -> Int {
        showIndexTitle(title)

        showTime = 1

        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(0.2 * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), { [unowned self] () -> Void in

            self.showTime = 0.8

        })

        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(0.4 * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), { [unowned self] () -> Void in

            if self.showTime == 0.8 {
                self.showTime = 0.6
            }
        })

        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(0.6 * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), { [unowned self] () -> Void in

            if self.showTime == 0.6 {
                self.showTime = 0.4
            }
        })

        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(0.8 * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), { [unowned self] () -> Void in

            if self.showTime == 0.4 {
                self.showTime = 0.2
            }
        })

        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(1 * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), { [unowned self] () -> Void in

            if self.showTime == 0.2 {
                self.dismissIndexTitle()
            }

        })

        return indexTitleIndexArray[index]
    }

    func scrollViewDidScroll(scrollView _: UIScrollView) {
        searchBar.endEditing(true)
    }

    func showIndexTitle(indexTitle: String) {
        dismissBtn.enabled = false
        view.userInteractionEnabled = false
        indexTitleLabel.text = indexTitle
        view.addSubview(indexTitleLabel)
    }

    func dismissIndexTitle() {
        dismissBtn.enabled = true
        view.userInteractionEnabled = true
        indexTitleLabel.removeFromSuperview()
    }

    /** 选中城市处理 */
    func citySelected(cityModel: CityModel) {
        if let cityIndex = self.selectedCityArray.indexOf(cityModel.name) {
            selectedCityArray.removeAtIndex(cityIndex)

        } else {
            if selectedCityArray.count >= 8 { selectedCityArray.removeLast() }
        }

        selectedCityArray.insert(cityModel.name, atIndex: 0)

        NSUserDefaults.standardUserDefaults().setObject(selectedCityArray, forKey: SelectedCityKey)
        selectedCityModel?(cityModel: cityModel)
        delegate?.selectedCityModel(self, cityModel: cityModel)
        dismiss()
    }
}

extension CFCityPickerVC {
    /** 处理索引 */
    func indexHandle() -> [String] {
        var indexArr: [String] = []

        for (index, cityModel) in sortedCityModles.enumerate() {
            let indexString = cityModel.getFirstUpperLetter

            if indexArr.contains(indexString) { continue }

            indexArr.append(indexString)

            indexTitleIndexArray.append(index)
        }

        return indexArr
    }

    override func didRotateFromInterfaceOrientation(fromInterfaceOrientation _: UIInterfaceOrientation) {
        indexTitleLabel.center = view.center
    }
}
