//
//  MessageModel.swift
//  Practice
//
//  Created by 新龙科技 on 2017/1/3.
//  Copyright © 2017年 新龙科技. All rights reserved.
//

import UIKit

class MessageModel: NSObject {
    var createTime:String = ""
    var id:String = ""
    var notice = [String:String]()
    
    init(dic:[String:Any]) {
        super.init()
        createTime = dic["createTime"] as! String
        id = dic["id"] as! String
        notice = dic["notice"] as! [String : String]
    }
}
