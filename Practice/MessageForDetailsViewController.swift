//
//  MessageForDetailsViewController.swift
//  Practice
//
//  Created by 新龙科技 on 2017/1/3.
//  Copyright © 2017年 新龙科技. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
class MessageForDetailsViewController: BaseViewController,UIWebViewDelegate {
    var MessageURL = String()
        let View = NVActivityIndicatorView(frame: CGRect(x: SCREEN_WIDTH/2-25, y: SCREEN_HEIGHT/2-64, width: 50, height: 50), type:NVActivityIndicatorType(rawValue: 1), color: UIColor.red, padding: 1.0)
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addNavBackImg()
        self.addNavTitle(Title: "消息详情")
        self.addBackButton()
        self.CreatUI()
         self.tabBarHidden()
    }
    func webViewDidFinishLoad(_ webView: UIWebView) {
        View.stopAnimating()
    }
    override func BackButton() {
        self.dismiss(animated: true, completion: nil)
    }
}

private extension MessageForDetailsViewController {
    func CreatUI() -> Void {
        activityIndi​​catorView?.startAnimating()
        let web = UIWebView(frame: CGRect(x: 0, y: 64, width: SCREEN_WIDTH, height: SCREEN_HEIGHT-64))
        web.scrollView.bounces = false
        web.delegate = self
        let urlString = "\(MessageURL)?app_token=\(UserDefauTake(ZToken)!)"
        web.loadRequest(URLRequest(url: NSURL(string: urlString) as! URL))
//        web.heroID = MessageURL
        self.view.addSubview(web)
        web.addSubview(View)
        View.startAnimating()
    }
}
