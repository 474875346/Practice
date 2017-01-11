//
//  MessageForDetailsViewController.swift
//  Practice
//
//  Created by 新龙科技 on 2017/1/3.
//  Copyright © 2017年 新龙科技. All rights reserved.
//

import UIKit

class MessageForDetailsViewController: BaseViewController {
    var MessageURL = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addNavBackImg()
        self.addNavTitle(Title: "消息详情")
        self.addBackButton()
        self.CreatUI()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarHidden()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarShow()
    }
}
private extension MessageForDetailsViewController {
    func CreatUI() -> Void {
        let web = UIWebView(frame: CGRect(x: 0, y: 64, width: SCREEN_WIDTH, height: SCREEN_HEIGHT-64))
        web.scrollView.bounces = false
        let urlString = "\(MessageURL)?app_token=\(UserDefauTake(ZToken)!)"
        web.loadRequest(URLRequest(url: NSURL(string: urlString) as! URL))
        web.heroID = "message"
        self.view.addSubview(web)
    }
}
