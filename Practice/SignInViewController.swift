//
//  SignInViewController.swift
//  Practice
//
//  Created by 新龙科技 on 2017/1/6.
//  Copyright © 2017年 新龙科技. All rights reserved.
//

import UIKit

class SignInViewController: BaseViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addNavBackImg()
        self.addNavTitle(Title: "签到")
        self.addBackButton()
        self.CreatUI()
    }
    override func BackButton() {
        self.dismiss(animated: true, completion: nil)
    }
}
private extension SignInViewController {
    func CreatUI() -> Void {
        print(CurrentDate())
        let Timeview = LineAndLabel.init(frame: CGRect(x: 0, y: 100, width: SCREEN_WIDTH, height: 35), title:CurrentDate())
        self.view.addSubview(Timeview)
        let Positioningview = LineAndLabel.init(frame: CGRect(x: 0, y: YH(Timeview)+20, width: SCREEN_WIDTH, height: 35), title:CurrentDate())
        self.view.addSubview(Positioningview)
    }
}
