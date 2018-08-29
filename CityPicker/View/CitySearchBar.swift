//
//  CitySearchBar.swift
//  CFCityPickerVC
//
//  Created by 冯成林 on 15/8/6.
//  Copyright (c) 2015年 冯成林. All rights reserved.
//

import UIKit

class CitySearchBar: UISearchBar, UISearchBarDelegate {
    var searchBarShouldBeginEditing: (() -> Void)?
    var searchBarDidEndditing: (() -> Void)?

    var searchAction: ((searchText: String) -> Void)?
    var searchTextDidChangedAction: ((searchText: String) -> Void)?
    var searchBarCancelAction: (() -> Void)?

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        /** 视图准备 */
        viewPrepare()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        /** 视图准备 */
        viewPrepare()
    }

    /** 视图准备 */
    func viewPrepare() {
        backgroundColor = UIColor.clearColor()
        backgroundImage = UIImage()
        layer.borderColor = CFCityPickerVC.cityPVCTintColor.CGColor
        layer.borderWidth = 0.5
        layer.cornerRadius = 4
        layer.masksToBounds = true
        translatesAutoresizingMaskIntoConstraints = false
        placeholder = "输出城市名、拼音或者首字母查询"
        tintColor = CFCityPickerVC.cityPVCTintColor

        delegate = self
    }
}

extension CitySearchBar {
    func searchBarShouldBeginEditing(searchBar: UISearchBar) -> Bool {
        searchBar.setShowsCancelButton(true, animated: true)
        searchBarShouldBeginEditing?()
        return true
    }

    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        searchBarDidEndditing?()
        searchBar.setShowsCancelButton(false, animated: true)
    }

    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchBar.endEditing(true)
        searchBarCancelAction?()
    }

    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchAction?(searchText: searchBar.text!)
        searchBar.endEditing(true)
    }

    func searchBar(searchBar _: UISearchBar, textDidChange searchText: String) {
        searchTextDidChangedAction?(searchText: searchText)
    }
}
