//
//  BaseViewController.swift
//  Practice
//
//  Created by 新龙科技 on 2016/12/27.
//  Copyright © 2016年 新龙科技. All rights reserved.
//

import UIKit
import MJRefresh
class BaseViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
}
//MARK:- 共有方法
extension  BaseViewController {
    //MARK:导航栏背景
    func addNavBackImg() -> Void {
        let NavImg = UIImageView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 64))
        NavImg.backgroundColor = RGBA(76, g: 171, b: 253, a: 1.0)
        self.view.addSubview(NavImg)
    }
    //MARK:导航栏标题
    func addNavTitle(Title:String) -> Void {
        let NavTitle = UILabel(frame: CGRect(x: 80, y: 20, width: SCREEN_WIDTH-160, height: 44))
        NavTitle.text = Title
        NavTitle.textColor = UIColor.white
        NavTitle.font = UIFont.systemFont(ofSize: 21)
        NavTitle.textAlignment = .center
        self.view.addSubview(NavTitle)
    }
    //MARK:导航栏返回按钮
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
        _ = self.navigationController?.popViewController(animated: true)
    }
    //MARK:隐藏侧滑
    func SlideHiend() -> Void {
        let swiftSlideRoot = UIApplication.shared.delegate as! AppDelegate
        swiftSlideRoot.ocSlide.slideBack()
    }
    //MARK:成功弹框
    func SuccessTost(Title:String , Body:String) -> Void {
          SwiftMessageManager.showMessage(layoutType: .MessageView, themeType: .Success, iconImageType: .light, presentationStyleType: .top, title: Title, body: Body, isHiddenBtn: true, seconds: 1)
    }
    //MARK:警告弹框
    func WaringTost(Title:String , Body:String) -> Void {
        SwiftMessageManager.showMessage(layoutType: .MessageView, themeType:.Warning, iconImageType:.light, presentationStyleType:.top, title: Title, body: Body, isHiddenBtn: true, seconds: 1)
    }
    //MARK:错误弹框
    func ErrorTost() -> Void {
         SwiftMessageManager.showMessage(layoutType: .MessageView, themeType: .Error, iconImageType: .light, presentationStyleType: .top, title: "", body: "网络问题，请休息一下", isHiddenBtn: true, seconds: 1)
    }
    //MARK:tabbar隐藏
    func tabBarHidden() -> Void {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        delegate.tabbar.tabBar.isHidden = true
        delegate.tabbar.tabBar.isTranslucent = true
    }
    //MARK:tabbar显示
    func tabBarShow() -> Void {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        delegate.tabbar.tabBar.isHidden = false
        delegate.tabbar.tabBar.isTranslucent = false
    }

}
