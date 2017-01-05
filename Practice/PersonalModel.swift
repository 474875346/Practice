//
//  PersonalModel.swift
//  Practice
//
//  Created by 新龙科技 on 2017/1/4.
//  Copyright © 2017年 新龙科技. All rights reserved.
//

import UIKit

class PersonalModel: NSObject {
    var id:String = ""
    
    var emergencyContact:String = ""
    
    var unit:String = ""
    
    var phone:String = ""
    
    var accessToken:String = ""
    
    var secret:String = ""
    
    var sex:NSString = ""
    
    var teacherName:String = ""
    
    var password:String = ""
    
    var idCard:String = ""
    
    var address:String = ""
    
    var teacherContact:String = ""
    
    var createTime:String = ""
    
    var modifyTime:String = ""
    
    var studentHeads:NSArray = []
    
    var name:String = ""
    
    var post:String = ""
    init(dic:[String:Any]) {
        super.init()
        setValuesForKeys(dic)
    }
}
class PersonalHeader: NSObject {
    var large:String = ""
    init(dic:[String:Any]) {
        super.init()
        large = dic["large"] as! String
    }
}
