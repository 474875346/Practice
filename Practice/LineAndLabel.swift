//
//  LineAndLabel.swift
//  Practice
//
//  Created by 新龙科技 on 2017/1/6.
//  Copyright © 2017年 新龙科技. All rights reserved.
//

import UIKit

class LineAndLabel: UIView {
    init(frame: CGRect,title:String) {
        super.init(frame:frame)
        let Topline = CreateUI.Label(UIColor.clear, backgroundColor: UIColor.lightGray, title: "", frame: CGRect(x: 0, y: 1, width: SCREEN_WIDTH, height: 1), font: 0)
        self.addSubview(Topline)
        let Timelabel = CreateUI.Label(UIColor.black, backgroundColor: UIColor.clear, title: "\(title)", frame: CGRect(x: 20, y: YH(Topline)+5, width: SCREEN_WIDTH-40, height: 20), font: 15)
        self.addSubview(Timelabel)
        let Bttomline = CreateUI.Label(UIColor.clear, backgroundColor: UIColor.lightGray, title: "", frame: CGRect(x: 0, y: YH(Timelabel)+5, width: SCREEN_WIDTH, height: 1), font: 0)
        self.addSubview(Bttomline)
    }
    
    required init?(coder aDecoder: NSCoder? = nil) {
        fatalError("init(coder:) has not been implemented")
    }
}
