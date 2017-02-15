//
//  QuestionnairepageQueryModel.swift
//  Practice
//
//  Created by 新龙科技 on 2017/2/14.
//  Copyright © 2017年 新龙科技. All rights reserved.
//

import UIKit

class QuestionnairepageQueryModel: NSObject {
    let title:String?
    let url:String?
    let createTime:String?
    let id:String?
    
    init(dic:[String:Any]) {
        title = dic["title"] as! String?
        url = dic["url"] as! String?
        createTime = dic["createTime"] as! String?
        id = dic["id"] as! String?
    }
}
