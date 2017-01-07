//
//  SignInRecordModel.swift
//  Practice
//
//  Created by 新龙科技 on 2017/1/7.
//  Copyright © 2017年 新龙科技. All rights reserved.
//

import UIKit

class SignInRecordModel: NSObject {
   var id = String()
    
   var createTime = String()
    
   var descn = String()
    
    var location : Location?
    
    init(dic:[String:Any]) {
        super.init()
        id = dic["id"] as! String
        createTime = dic["createTime"] as! String
        descn = dic["descn"] as! String
        location = Location.init(dic: dic["location"] as! [String : Any])
    }
}
class Location: NSObject {
   var positionDescn = String()
    var longitude = Float()
    var latitude = Float()
    init(dic:[String:Any]) {
        super.init()
        positionDescn = dic["positionDescn"] as! String
        longitude = dic["longitude"] as! Float
        latitude = dic["latitude"] as! Float 
    }
}
