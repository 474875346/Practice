//
//  PlayTheVideo.swift
//  Practice
//
//  Created by 新龙科技 on 2017/1/10.
//  Copyright © 2017年 新龙科技. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
class PlayTheVideo: BaseViewController,UIWebViewDelegate {
    var URLString = ""
    let View = NVActivityIndicatorView(frame: CGRect(x: SCREEN_WIDTH/2-25, y: SCREEN_HEIGHT/2-64, width: 50, height: 50), type:NVActivityIndicatorType(rawValue: Int(arc4random())%27), color: UIColor.red, padding: 1.0)
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addNavBackImg()
        self.addNavTitle(Title: "播放视频")
        self.addBackButton()
        self.CreatUI()
        self.tabBarHidden()
    }
}
extension PlayTheVideo {
    func webViewDidFinishLoad(_ webView: UIWebView) {
        View.stopAnimating()
    }
}
private extension PlayTheVideo {
    func CreatUI() -> Void {
        View.startAnimating()
        let web  = UIWebView(frame: CGRect(x: 0, y: 64, width: SCREEN_WIDTH, height: SCREEN_HEIGHT-64))
        web.loadRequest(URLRequest(url: URL(string: URLString)!))
        web.mediaPlaybackRequiresUserAction = false
        web.scrollView.bounces = false
        web.delegate = self
//        web.heroID = "PlayVideo"
        self.view.addSubview(web)
        web.addSubview(View)
    }

}
