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
        isHeroEnabled = true
        self.view.backgroundColor = UIColor.white
        self.navigationController?.isHeroEnabled = true
        self.navigationController?.navigationBar.isHidden = true
        self.activityView()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarShow()
        activityIndi​​catorView?.stopAnimating()
    }
}
//MARK:- 共有方法
extension  BaseViewController {
    //MARK:指示器
    func activityView() -> Void {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        delegate.window?.addSubview(activityIndi​​catorView!)
    }
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
    //MARK:导航栏返回按钮
    func addSlide() -> Void {
        let BackBtn = UIButton(type: .custom)
        BackBtn.frame = CGRect(x: 10, y: 20, width: 54, height: 44)
        let Backimg = UIImage(named: "drawer")
        BackBtn.setImage(Backimg, for: .normal)
        BackBtn.addTarget(self, action: #selector(Slide), for: .touchUpInside)
        self.view.addSubview(BackBtn)
    }
    func Slide() -> Void {
        self.SlideShow()
    }
    //MARK:隐藏侧滑
    func SlideHiend() -> Void {
        let swiftSlideRoot = UIApplication.shared.delegate as! AppDelegate
        swiftSlideRoot.ocSlide.slideBack()
    }
    //MARK:侧滑显示
    func SlideShow() -> Void {
        let swiftSlideRoot = UIApplication.shared.delegate as! AppDelegate
        swiftSlideRoot.ocSlide.slideToLeft()
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
