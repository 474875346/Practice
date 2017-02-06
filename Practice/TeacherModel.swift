//
//  TeacherModel.swift
//  Practice
//
//  Created by 新龙科技 on 2017/2/4.
//  Copyright © 2017年 新龙科技. All rights reserved.
//

import UIKit

class TeacherModel: NSObject {
    let realName:String?
    let id:String?
    
    init(dic:[String:Any]) {
        id = dic["id"] as! String?
        realName = dic["realName"] as! String?
    }
    
}
