//
//  InputPasswordCollege.swift
//  Practice
//
//  Created by 新龙科技 on 2016/12/29.
//  Copyright © 2016年 新龙科技. All rights reserved.
//

import UIKit
class InputPasswordCollege: NSObject {
    var name:String = ""
    var id:String = ""
    init(dic:[String:Any]) {
        super.init()
        setValuesForKeys(dic)
    }
}
