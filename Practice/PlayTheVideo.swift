//
//  PlayTheVideo.swift
//  Practice
//
//  Created by 新龙科技 on 2017/1/10.
//  Copyright © 2017年 新龙科技. All rights reserved.
//

import UIKit

class PlayTheVideo: BaseViewController {
    var URLString = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.CreatUI()
    }
}
private extension PlayTheVideo {
    func CreatUI() -> Void {
        let web  = UIWebView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT))
        web.loadRequest(URLRequest(url: URL(string: URLString)!))
        web.mediaPlaybackRequiresUserAction = false
        self.view.addSubview(web)
        let BackBtn = UIButton(type: .custom)
        BackBtn.frame = CGRect(x: 10, y: 20, width: 54, height: 44)
        let Backimg = UIImage(named: "back")
        BackBtn.setImage(Backimg, for: .normal)
        BackBtn.imageEdgeInsets = UIEdgeInsets(top: 12, left: 10, bottom: 12, right: 35)
        BackBtn.addTarget(self, action: #selector(self.Back), for: .touchUpInside)
       web.addSubview(BackBtn)
    }
    @objc func Back() -> Void {
       self.dismiss(animated: true, completion: nil)
    }
}
