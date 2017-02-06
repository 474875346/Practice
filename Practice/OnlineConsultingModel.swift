//
//  OnlineConsultingModel.swift
//  Practice
//
//  Created by 新龙科技 on 2017/2/4.
//  Copyright © 2017年 新龙科技. All rights reserved.
//

import UIKit

class OnlineConsultingModel: NSObject {
    let title:String?
    let content:String?
    let createTime:String?
    
    init(dic:[String:Any]) {
        title = dic["title"] as! String?
        content = dic["content"] as! String?
        createTime = dic["createTime"] as! String?
    }
}
