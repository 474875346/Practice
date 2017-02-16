//
//  SignWithFootprintViewController.swift
//  Practice
//
//  Created by 新龙科技 on 2017/1/13.
//  Copyright © 2017年 新龙科技. All rights reserved.
//

import UIKit

class SignWithFootprintViewController: BaseViewController,UITabBarDelegate,UIScrollViewDelegate {
    //添加Tab Bar控件
    var tabBar:UITabBar!
    //Tab Bar Item的名称数组
    var tabs = ["签到","足迹"]
    let scrollview = UIScrollView(frame: CGRect(x: 0, y: 64, width: SCREEN_WIDTH, height: SCREEN_HEIGHT-108))
    var items:[UITabBarItem] = []
    lazy var label:UILabel? = {
        let NavTitle = UILabel(frame: CGRect(x: 80, y: 20, width: SCREEN_WIDTH-160, height: 44))
        NavTitle.textColor = UIColor.white
        NavTitle.font = UIFont.systemFont(ofSize: 21)
        NavTitle.textAlignment = .center
        self.view.addSubview(NavTitle)
        return NavTitle
    }()
    let signinrec = SignInRecordViewController()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addNavBackImg()
        self.addBackButton()
        self.CreatUI()
        self.tabBarHidden()
    }
}
extension SignWithFootprintViewController {
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        scrollview.contentOffset = CGPoint(x: SCREEN_WIDTH*ConversionCGFloat(item.tag), y: 0)
        if item.tag == 0 {
            self.label?.text = "签到"
            activityIndi​​catorView?.stopAnimating()
        } else {
            self.label?.text = "足迹"
        }
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let idx = Int(scrollView.contentOffset.x / SCREEN_WIDTH)
        tabBar.selectedItem = items[idx]
        if idx == 0 {
            self.label?.text = "签到"
            activityIndi​​catorView?.stopAnimating()
        } else {
            self.label?.text = "足迹"
            signinrec.signRecordData()
        }
    }
}
private extension SignWithFootprintViewController {
    func CreatUI() -> Void {
        self.label?.text = "签到"
        //在底部创建Tab Bar
        tabBar = UITabBar(frame: CGRect(x: 0, y: SCREEN_HEIGHT-48, width: SCREEN_WIDTH, height: 44))
        for (idx,obj) in self.tabs.enumerated() {
            let tabItem = UITabBarItem.init(title: obj, image:UIImage(named: obj) , tag: idx)
            items.append(tabItem)
        }
        //设置Tab Bar的标签页
        tabBar.setItems(items, animated: true)
        tabBar.selectedItem = items[0]
        //本类实现UITabBarDelegate代理，切换标签页时能响应事件
        tabBar.delegate = self
        //代码添加到界面上来
        self.view.addSubview(tabBar);
        scrollview.delegate = self
        scrollview.contentSize = CGSize(width: SCREEN_WIDTH*2, height: 0)
        scrollview.showsHorizontalScrollIndicator = false
        scrollview.bounces = false
        scrollview.isPagingEnabled = true
        self.view.addSubview(scrollview)
        let signin = SignInViewController()
        signin.view.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: H(scrollview))
        addChildViewController(signin)
        scrollview.addSubview(signin.view)
        
        signinrec.view.frame = CGRect(x: SCREEN_WIDTH, y: 0, width: SCREEN_WIDTH, height: H(scrollview))
        addChildViewController(signinrec)
        scrollview.addSubview(signinrec.view)

    }
}
