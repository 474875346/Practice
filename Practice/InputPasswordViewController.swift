//
//  InputPasswordViewController.swift
//  Practice
//
//  Created by 新龙科技 on 2016/12/28.
//  Copyright © 2016年 新龙科技. All rights reserved.
//

import UIKit

class InputPasswordViewController: BaseViewController {
    var nameTF = UITextField()
    var passwordTF = UITextField()
    var collegeTF = UITextField()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addNavBackImg()
        self.addNavTitle(Title: "设置昵称密码")
        self.addBackButton()
        self.CreatUI()
    }
}
//MARK:-设置昵称密码学院
private extension InputPasswordViewController {
    func CreatUI() -> Void {
        //昵称、密码、学院
        let view = LabelAndTFView(frame: CGRect(x: 0.05*SCREEN_WIDTH, y: 160, width: 0.9*SCREEN_WIDTH, height: 120), titlyArray: ["昵称", "密码", "学校"], PlaceholderArray: ["输入昵称","输入密码(最大长度32)","选择学校",])
        nameTF = view.TFArray[0] as! UITextField
        passwordTF = view.TFArray[1] as! UITextField
        collegeTF = view.TFArray[2] as! UITextField
        nameTF.addTarget(self, action: #selector(self.textFieldDidChange), for: .editingChanged)
        passwordTF.addTarget(self, action: #selector(self.textFieldDidChange), for: .editingChanged)
        self.view.addSubview(view)
        //学院文本框取消交互
        collegeTF.isUserInteractionEnabled = false
        collegeTF.clearButtonMode = .never
        //学院按钮
        let collegeBtn = CreateUI.Button("", action: #selector((self.collegePicker)), sender: self, frame: collegeTF.frame, backgroundColor: UIColor.clear, textColor: UIColor.clear)
        self.view.addSubview(collegeBtn)
        self.collegeData()
    }
    //MARK:学院请求
    func collegeData() -> Void {
        HttpRequestTool.sharedInstance.HttpRequestJSONDataWithUrl(url: collegelist, type: .POST, parameters: ["":""], successed: {
            success in
            print(success as Any)
        }, failed: {
            error in
            print(error as Any)
        })
    }
    //MARK:选择学院
    @objc func collegePicker() {
        
    }
    //MARK:昵称密码监听
    @objc func textFieldDidChange() {
        
    }
}
