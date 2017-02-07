//
//  QuestionHistoryModel.swift
//  Practice
//
//  Created by 新龙科技 on 2017/2/7.
//  Copyright © 2017年 新龙科技. All rights reserved.
//

import UIKit

class QuestionHistoryModel: NSObject {
    let content:String?
    let createTime:String?
    let id:String?
    
    init(dic:[String:Any]) {
        content = dic["content"] as! String?
        createTime = dic["createTime"] as! String?
        id = dic["id"] as! String?
    }
}
