//
//  QuestionnairepagedetailsViewController.swift
//  Practice
//
//  Created by 新龙科技 on 2017/2/14.
//  Copyright © 2017年 新龙科技. All rights reserved.
//

import UIKit

class QuestionnairepagedetailsViewController: BaseViewController,UIWebViewDelegate {
    var id:String?
    var urlString:String?
    var titleSting:String? 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addNavBackImg()
        self.addBackButton()
        self.addNavTitle(Title: titleSting!)
        self.CreatUI()
    }
}
extension QuestionnairepagedetailsViewController {
    func webViewDidFinishLoad(_ webView: UIWebView) {
        activityIndi​​catorView?.stopAnimating()
    }
}
private extension QuestionnairepagedetailsViewController {
    func CreatUI() -> Void {
        activityIndi​​catorView?.startAnimating()
        let web = UIWebView(frame: CGRect(x: 0, y: 64, width: SCREEN_WIDTH, height: SCREEN_HEIGHT-64))
        web.scrollView.bounces = false
        web.delegate = self
         urlString = "\(BaseURL)\(Student_questionnairepindex)?app_token=\(UserDefauTake(ZToken)!)&surveyId=\(id!)&client=\(deviceUUID!)"
        web.loadRequest(URLRequest(url: NSURL(string: urlString!) as! URL))
        self.view.addSubview(web)
    }


    
}
