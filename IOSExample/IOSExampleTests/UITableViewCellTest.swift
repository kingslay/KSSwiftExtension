//
//  UITableViewCellTest.swift
//  IOSExample
//
//  Created by king on 16/4/17.
//  Copyright © 2016年 king. All rights reserved.
//

import XCTest
import UIKit
import KSSwiftExtension
import RxSwift
class UITableViewCellTest: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testPrepareForReusedisposableBag() {
        let tableViewCell = UITableViewCell()
//        let disposableBag = cell.ks.prepareForReusedisposableBag
        let subject = PublishSubject<String>()
        subject.subscribe {
            XCTAssertTrue($0.element == "1")
        }.addDisposableTo(tableViewCell.ks.prepareForReusedisposableBag)
        subject.onNext("1")
        tableViewCell.prepareForReuse()
        subject.onNext("2")
        let collectionReusableView = UICollectionReusableView()
        subject.subscribe {
            XCTAssertTrue($0.element == "1")
        }.addDisposableTo(collectionReusableView.ks.prepareForReusedisposableBag)
        subject.onNext("1")
        collectionReusableView.prepareForReuse()
        subject.onNext("2")

        

//        XCTAssertTrue(disposableBag !== cell.ks.prepareForReusedisposableBag)
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }

}
