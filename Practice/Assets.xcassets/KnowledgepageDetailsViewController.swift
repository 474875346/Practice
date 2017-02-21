//
//  KnowledgepageDetailsViewController.swift
//  Practice
//
//  Created by 新龙科技 on 2017/2/14.
//  Copyright © 2017年 新龙科技. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
class KnowledgepageDetailsViewController: BaseViewController,UIWebViewDelegate {
    var URL:String?
    var Name:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addNavBackImg()
        self.addNavTitle(Title:Name!)
        self.addBackButton()
        self.CreatUI()
    }
}
extension KnowledgepageDetailsViewController {
    func webViewDidFinishLoad(_ webView: UIWebView) {
        activityIndi​​catorView?.stopAnimating()
    }
}
private extension KnowledgepageDetailsViewController {
    func CreatUI() -> Void {
        activityIndi​​catorView?.startAnimating()
        let web = UIWebView(frame: CGRect(x: 0, y: 64, width: SCREEN_WIDTH, height: SCREEN_HEIGHT-64))
        web.scrollView.bounces = false
        web.delegate = self
        let urlString = "\(URL!)?app_token=\(UserDefauTake(ZToken)!)&client=\(deviceUUID!)"
        web.loadRequest(URLRequest(url: NSURL(string: urlString) as! URL))
        self.view.addSubview(web)
    }
}
