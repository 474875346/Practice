//
//  BaseViewController.swift
//  Practice
//
//  Created by 新龙科技 on 2016/12/27.
//  Copyright © 2016年 新龙科技. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    func addNavBackImg() -> Void {
        let NavImg = UIImageView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 64))
        NavImg.backgroundColor = RGBA(76, g: 171, b: 253, a: 1.0)
        self.view.addSubview(NavImg)
    }
    func addNavTitle(Title:String) -> Void {
        let NavTitle = UILabel(frame: CGRect(x: 80, y: 20, width: SCREEN_WIDTH-160, height: 44))
        NavTitle.text = Title
        NavTitle.textColor = UIColor.white
        NavTitle.font = UIFont.systemFont(ofSize: 21)
        NavTitle.textAlignment = .center
        self.view.addSubview(NavTitle)
    }
    func addBackButton() -> Void {
        let BackBtn = UIButton(type: .custom)
        BackBtn.frame = CGRect(x: 10, y: 20, width: 54, height: 44)
        let Backimg = UIImage(named: "back")
        BackBtn.setImage(Backimg, for: .normal)
        BackBtn.imageEdgeInsets = UIEdgeInsets(top: 12, left: 10, bottom: 12, right: 35)
        BackBtn.addTarget(self, action: #selector(BackButton), for: .touchUpInside)
        self.view.addSubview(BackBtn)
    }
    func BackButton() -> Void {
        print("返回上一界面")
      _ =  self.navigationController?.popViewController(animated: true)
    }
}
