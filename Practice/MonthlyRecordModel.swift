//
//  MonthlyRecordModel.swift
//  Practice
//
//  Created by 新龙科技 on 2017/1/9.
//  Copyright © 2017年 新龙科技. All rights reserved.
//

import UIKit

class MonthlyRecordModel: NSObject {
    var summary = ""
    
    var modifyTime = ""
    
    var id = ""
    
    var descn = ""
    
    var plan = ""
    
    var Files = [MonthlyRecordFiles]()
    
    var createTime = ""
    init(dic:[String:Any]) {
        super.init()
        id = dic["id"] as! String
        summary = dic["summary"] as! String
        modifyTime = dic["modifyTime"] as! String
        descn = dic["descn"] as! String
        plan = dic["plan"] as! String
        createTime = dic["createTime"] as! String
        let files = dic["files"] as! NSArray
        for p in files {
            let dic = p as! [String:Any]
            Files.append(MonthlyRecordFiles.init(dic: dic))
        }
        
    }
}
class  MonthlyRecordFiles : NSObject {
    var totalBytes = NSInteger()
    
    var ext = NSString()
    
    var path = ""
    
    var name = ""
    
    var type = NSString()
    
    init(dic:[String:Any]) {
        super.init()
        totalBytes = dic["totalBytes"] as! NSInteger
        ext = dic["ext"] as! NSString
        path = dic["path"] as! String
        name = dic["name"] as! String
        type = dic["name"] as! NSString
    }
}
