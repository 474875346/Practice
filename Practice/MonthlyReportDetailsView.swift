//
//  MonthlyReportDetailsView.swift
//  Practice
//
//  Created by 新龙科技 on 2017/1/10.
//  Copyright © 2017年 新龙科技. All rights reserved.
//

import UIKit

class MonthlyReportDetailsView: UIView {
    init(frame:CGRect,title:String,content:String) {
        super.init(frame: frame)
        let titleLabel = CreateUI.Label(UIColor.black, backgroundColor: UIColor.clear, title: title, frame: CGRect(x: 10, y: 5, width: SCREEN_WIDTH, height: 20), font: 17)
        self.addSubview(titleLabel)
        let size = getAttributeSize(text: content as NSString, fontSize: 21)
        
        let contentLabel = CreateUI.Label(UIColor.black, backgroundColor: UIColor.clear, title: content, frame: CGRect(x: 10, y: YH(titleLabel)+5, width: SCREEN_WIDTH-20, height: size.height+50), font: 17)
        contentLabel.numberOfLines = 0
        self.addSubview(contentLabel)
        
        let line = CreateUI.Label(UIColor.clear, backgroundColor: UIColor.lightGray, title: "", frame: CGRect(x: 0, y: YH(contentLabel)+5, width: SCREEN_WIDTH, height: 1), font: 0)
        self.addSubview(line)
        
        self.frame = CGRect(x: X(self), y: Y(self), width: SCREEN_WIDTH, height: YH(line)+5)
    }
    
    required init?(coder aDecoder: NSCoder? = nil) {
        fatalError("init(coder:) has not been implemented")
    }
}
