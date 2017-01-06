//
//  MonthlyRecordViewController.swift
//  Practice
//
//  Created by 新龙科技 on 2017/1/6.
//  Copyright © 2017年 新龙科技. All rights reserved.
//

import UIKit

class MonthlyRecordViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.addNavBackImg()
        self.addNavTitle(Title: "签到")
        self.addBackButton()
    }
    override func BackButton() {
        self.dismiss(animated: true, completion: nil)
    }
}
