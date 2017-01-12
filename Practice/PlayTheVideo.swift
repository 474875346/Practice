//
//  PlayTheVideo.swift
//  Practice
//
//  Created by 新龙科技 on 2017/1/10.
//  Copyright © 2017年 新龙科技. All rights reserved.
//

import UIKit

class PlayTheVideo: BaseViewController,UIWebViewDelegate {
    var URLString = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.CreatUI()
    }
    func webViewDidFinishLoad(_ webView: UIWebView) {
        activityIndi​​catorView?.stopAnimating()
    }
}
private extension PlayTheVideo {
    func CreatUI() -> Void {
        activityIndi​​catorView?.startAnimating()
        let web  = UIWebView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT))
        web.loadRequest(URLRequest(url: URL(string: URLString)!))
        web.mediaPlaybackRequiresUserAction = false
        web.scrollView.bounces = false
        web.delegate = self
        self.view.addSubview(web)
        let BackBtn = UIButton(type: .custom)
        BackBtn.frame = CGRect(x: 10, y: 20, width: 44, height: 44)
                let Backimg = UIImage(named: "back")
                BackBtn.setImage(Backimg, for: .normal)
        BackBtn.backgroundColor = RGBA(76, g: 171, b: 253, a: 1.0)
        BackBtn.addTarget(self, action: #selector(self.Back), for: .touchUpInside)
        LRViewBorderRadius(BackBtn, Radius: 22, Width: 0, Color: UIColor.clear)
        web.addSubview(BackBtn)
    }
    @objc func Back() -> Void {
        self.dismiss(animated: true, completion: nil)
    }
}
