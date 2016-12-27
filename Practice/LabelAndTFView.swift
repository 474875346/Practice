//
//  LabelAndTFView.swift
//  学院实践
//
//  Created by 新龙科技 on 2016/12/27.
//  Copyright © 2016年 新龙科技. All rights reserved.
//

import UIKit

class LabelAndTFView: UIView {
     init(frame:CGRect,titlyArray:[String],PlaceholderArray : [String] ) {
        super.init(frame: frame)
        let TFArray = NSMutableArray()
        self.clipsToBounds = true
        let height = H(self)/ConversionCGFloat(titlyArray.count)
        let width = W(self)
        for i in 0..<titlyArray.count {
            let label = CreateUI.Label(UIColor.black, backgroundColor: UIColor.clear, title: titlyArray[i], frame: CGRect(x: 0, y: ConversionCGFloat(i)*height, width: 0.25*width, height: height), font: 15)
            self.addSubview(label)
            let textfiled = UITextField(frame: CGRect(x: 0.25*width, y: ConversionCGFloat(i)*height, width: 0.75*width, height: height))
            textfiled.placeholder = PlaceholderArray[i]
            textfiled.clearButtonMode = .always
            textfiled.autocapitalizationType = .none
            textfiled.backgroundColor = UIColor.clear
            self.addSubview(textfiled)
            TFArray.add(textfiled)
            let line  = UIView(frame: CGRect(x: 0, y: ConversionCGFloat(i+1)*H(textfiled)-1, width: width, height: 1))
            line.backgroundColor = UIColor.lightGray
            self.addSubview(line)
            let titly  = titlyArray[i]
            if (titly .range(of: "密码") != nil) {
                textfiled.isSecureTextEntry = true
            }
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
