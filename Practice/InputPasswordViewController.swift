//
//  InputPasswordViewController.swift
//  Practice
//
//  Created by 新龙科技 on 2016/12/28.
//  Copyright © 2016年 新龙科技. All rights reserved.
//

import UIKit

class InputPasswordViewController: BaseViewController,UIPickerViewDelegate,UIPickerViewDataSource {
    lazy var collegeArray : [InputPasswordCollege] = [InputPasswordCollege]()
    var nameTF = UITextField()
    var passwordTF = UITextField()
    var collegeTF = UITextField()
    var picker = UIPickerView()
    var collegeId = ""
    var nextButton : UIButton? = nil
    var titleCode = NSString()
    var verifyCode = String()
    var PhoneString = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addNavBackImg()
        
        self.addBackButton()
        self.CreatUI()
    }
    //MARK:Picker行数
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.collegeArray.count
    }
    //MARK:Picker列数
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    //MARK:Picker标题
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let college = collegeArray[row]
        return college.name
    }
    //MARK:picker选中标题
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let college = collegeArray[row]
        collegeTF.text = college.name
        collegeId = college.id
        picker.isHidden = true
    }
}
//MARK:-设置昵称密码学院
private extension InputPasswordViewController {
    func CreatUI() -> Void {
        if titleCode.isEqual(to: "注册") {
            self.Registration()
        } else {
            self.RetrievePassword()
        }
        //注册或找回密码
        nextButton = UIButton(type: .custom)
        nextButton?.frame = CGRect(x: 0.05 * SCREEN_WIDTH, y: 150, width: 0.9 * SCREEN_WIDTH, height: 40)
        LRViewBorderRadius(nextButton!, Radius: 5, Width: 0, Color: UIColor.clear)
        nextButton?.alpha = 0.3
        nextButton?.isUserInteractionEnabled = false
        nextButton?.backgroundColor = RGBA(76, g: 171, b: 253, a: 1)
        if titleCode.isEqual(to: "注册") {
            self.addNavTitle(Title: "设置昵称密码")
            nextButton?.setTitle("注册", for: .normal)
        } else {
            self.addNavTitle(Title: "找回密码")
            nextButton?.setTitle("找回密码", for: .normal)
        }
        nextButton?.addTarget(self, action: #selector((self.RegistrationOrRetrievePassword)), for: .touchUpInside)
        self.view.addSubview(nextButton!)
    }
    //MARK:注册布局
    func Registration() -> Void {
        //昵称、密码、学院
        let view = LabelAndTFView(frame: CGRect(x: 0.05*SCREEN_WIDTH, y: 160, width: 0.9*SCREEN_WIDTH, height: 120), titlyArray: ["昵称：", "密码：", "学校："], PlaceholderArray: ["输入昵称","输入密码(最大长度32)","选择学校",])
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
        let collegeBtn = CreateUI.Button("", action: #selector((self.collegePicker)), sender: self, frame: CGRect(x: X(collegeTF), y: Y(view)+80, width: W(collegeTF), height: H(collegeTF)), backgroundColor: UIColor.clear, textColor: UIColor.clear)
        self.view.addSubview(collegeBtn)
        //加载学院列表
        self.collegeData()
        //滚轮
        self.picker.frame = CGRect(x: 0, y: SCREEN_HEIGHT-200, width: SCREEN_WIDTH, height: 200)
        self.picker.delegate = self
        self.picker.dataSource = self
        self.picker.isHidden = true
        self.view.addSubview(self.picker)
    }
    //MARK:-找回密码布局
    func RetrievePassword() -> Void {
        //MARK:昵称、密码、学院
        let view = LabelAndTFView(frame: CGRect(x: 0.05*SCREEN_WIDTH, y: 160, width: 0.9*SCREEN_WIDTH, height: 40), titlyArray: ["密码："], PlaceholderArray: ["输入密码(最大长度32)"])
        passwordTF = view.TFArray[0] as! UITextField
        passwordTF.addTarget(self, action: #selector(self.textFieldDidChange), for: .editingChanged)
        self.view.addSubview(view)
        
    }
    //MARK:注册或找回密码
    @objc func RegistrationOrRetrievePassword() -> Void {
        if titleCode.isEqual(to: "注册") {
            self.RegistrationData()
        } else {
            self.ResetPassData()
        }
    }
    //MARK:学院请求
    func collegeData() -> Void {
        HttpRequestTool.sharedInstance.HttpRequestJSONDataWithUrl(url: collegelist, type: .POST, parameters: ["":""],SafetyCertification: true, successed: {
            success in
            let array:NSArray = success?["data"] as! NSArray
            for dic in array {
                self.collegeArray.append(InputPasswordCollege(dic: dic as! [String : Any]))
            }
            self.picker.reloadAllComponents()
        }, failed: {
            error in
        })
    }
    //MARK:选择学院
    @objc func collegePicker() {
        self.picker.isHidden = false
    }
    //MARK:昵称密码监听
    @objc func textFieldDidChange() {
        if titleCode.isEqual(to: "注册") {
            self.RegistrationJudge()
        } else {
            self.RetrievePasswordJudge()
        }
    }
    //MARK:注册判断
    func RegistrationJudge() -> Void {
        let nameString = nameTF.text! as NSString
        let pswString = passwordTF.text! as NSString
        if !nameString.isEqual(to: "") {
            if !pswString.isEqual(to: "") {
                nextButton?.alpha = 1.0
                nextButton?.isUserInteractionEnabled = true
                if pswString.length > 20 {
                    passwordTF.text = pswString.substring(to: 20)
                }
            } else {
                nextButton?.alpha = 0.3
                nextButton?.isUserInteractionEnabled = false
            }
        } else {
            nextButton?.alpha = 0.3
            nextButton?.isUserInteractionEnabled = false
        }
    }
    //MARK:找回密码判断
    func RetrievePasswordJudge() -> Void {
        let pswString = passwordTF.text! as NSString
        if !pswString.isEqual(to: "") {
            nextButton?.alpha = 1.0
            nextButton?.isUserInteractionEnabled = true
            if pswString.length > 20 {
                passwordTF.text = pswString.substring(to: 20)
            }
        } else {
            nextButton?.alpha = 0.3
            nextButton?.isUserInteractionEnabled = false
        }
    }
    //MARK:重置密码
    func ResetPassData() -> Void {
        HttpRequestTool.sharedInstance.HttpRequestJSONDataWithUrl(url: ResetPsw, type:.POST, parameters: ["phone":PhoneString,"verifyCode":verifyCode,"password":passwordTF.text!],SafetyCertification: true, successed: { (success) in
            let status = success?["status"] as! Int
            if status == 200 {
                self.SuccessTost(Title: "", Body: "找回密码成功")
                _ = self.navigationController?.popToRootViewController(animated: true)
            } else {
                let msg = success?["msg"] as! String
                self.WaringTost(Title: "", Body: msg)
            }
        }) { (error) in
            self.ErrorTost()
        }
    }
    //MARK:注册
    func RegistrationData() -> Void {
        HttpRequestTool.sharedInstance.HttpRequestJSONDataWithUrl(url: Student_Register, type: .POST, parameters: ["phone":PhoneString,"name":nameTF.text!,"password":passwordTF.text!,"verifyCode":verifyCode,"collegeId":collegeId],SafetyCertification: true, successed: { (success) in
            let status = success?["status"] as! Int
            if status == 200 {
                self.SuccessTost(Title: "", Body: "注册成功")
                _ = self.navigationController?.popToRootViewController(animated: true)
            } else {
                let msg = success?["msg"] as! String
                self.WaringTost(Title: "", Body: msg)
            }
        }) { (error) in
            self.ErrorTost()
        }
    }
}
