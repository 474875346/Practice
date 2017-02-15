//
//  KnowledgepageQueryModel.swift
//  Practice
//
//  Created by 新龙科技 on 2017/2/14.
//  Copyright © 2017年 新龙科技. All rights reserved.
//

import UIKit

class KnowledgepageQueryModel: NSObject {
    let name:String?
    let url:String?
    let createTime:String?
    let id:String?
    
    init(dic:[String:Any]) {
        name = dic["name"] as! String?
        url = dic["url"] as! String?
        createTime = dic["createTime"] as! String?
        id = dic["id"] as! String?
    }
}
