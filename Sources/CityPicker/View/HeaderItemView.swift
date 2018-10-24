//
//  HeaderItemView.swift
//  CFCityPickerVC
//
//  Created by 冯成林 on 15/7/30.
//  Copyright (c) 2015年 冯成林. All rights reserved.
//

import UIKit

class HeaderItemView: UIView {
    @IBOutlet var itemLabel: UILabel!

    @IBOutlet var lineView: UIView!
    @IBOutlet var lineViewHC: NSLayoutConstraint!

    @IBOutlet var msgLabel: UILabel!

    @IBOutlet var contentView: CFCPContentView!

    var cityModles: [CityModel]! { didSet { dataCome() } }
}

extension HeaderItemView {
    override func awakeFromNib() {
        super.awakeFromNib()

        lineViewHC.constant = 0.5
    }

    func dataCome() {
        msgLabel.hidden = cityModles.count != 0
        contentView.cityModles = cityModles
    }

    class func getHeaderItemView(title: String) -> HeaderItemView {
        let itemView = NSBundle.mainBundle().loadNibNamed("HeaderItemView", owner: nil, options: nil).first as! HeaderItemView
        itemView.itemLabel.text = title

        return itemView
    }
}

extension CFCPContentView {
    class ItemBtn: UIButton {
        var cityModel: CityModel!

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
            setTitleColor(CFCityPickerVC.rgba(31, g: 31, b: 31, a: 1), forState: UIControlState.Normal)
            setTitleColor(CFCityPickerVC.rgba(141, g: 141, b: 141, a: 1), forState: UIControlState.Highlighted)
            titleLabel?.font = UIFont.systemFontOfSize(15)
            layer.cornerRadius = 4
            layer.masksToBounds = true
            backgroundColor = CFCityPickerVC.rgba(241, g: 241, b: 241, a: 1)
        }
    }
}

class CFCPContentView: UIView {
    var cityModles: [CityModel]! { didSet { btnsPrepare() } }

    let maxRowCount = 4
    var btns: [ItemBtn] = []

    /** 添加按钮 */
    func btnsPrepare() {
        if cityModles == nil { return }
        for cityModel in cityModles {
            let itemBtn = ItemBtn()
            itemBtn.setTitle(cityModel.name, forState: UIControlState.Normal)
            itemBtn.addTarget(self, action: #selector(btnClick(_:)), forControlEvents: UIControlEvents.TouchUpInside)
            btns.append(itemBtn)
            itemBtn.cityModel = cityModel
            addSubview(itemBtn)
        }
    }

    /** 按钮点击事件 */
    func btnClick(btn: ItemBtn) {
        NSNotificationCenter.defaultCenter().postNotificationName(CityChoosedNoti, object: nil, userInfo: ["citiModel": btn.cityModel])
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        if btns.count == 0 { return }
        let marginForRow: CGFloat = 16.0
        let marginForCol: CGFloat = 13
        let width: CGFloat = (bounds.size.width - (CGFloat(maxRowCount - 1)) * marginForRow) / CGFloat(maxRowCount)

        let height: CGFloat = 30
        for (index, btn) in btns.enumerate() {
            let row = index % maxRowCount

            let col = index / maxRowCount

            let x = (width + marginForRow) * CGFloat(row)
            let y = (height + marginForCol) * CGFloat(col)

            btn.frame = CGRectMake(x, y, width, height)
        }
    }
}
