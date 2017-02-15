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
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addNavBackImg()
        self.addBackButton()
        self.addNavTitle(Title: "调查问卷详情")
        self.CreatUI()
    }
}
extension QuestionnairepagedetailsViewController {
    func webViewDidFinishLoad(_ webView: UIWebView) {
        activityIndi​​catorView?.stopAnimating()
    }
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        let requestURL:NSString = "\(request)" as NSString
        if requestURL.isEqual(to: urlString!) {
        }
        else {
          _ = self.navigationController?.popViewController(animated: true)
        }
        return true
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
        //        web.heroID = MessageURL
        self.view.addSubview(web)
//        web.addSubview(View)
//        View.startAnimating()
    }


    
}
