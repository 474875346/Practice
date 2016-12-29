//
//  Registered ViewController.swift
//  Practice
//
//  Created by 新龙科技 on 2016/12/27.
//  Copyright © 2016年 新龙科技. All rights reserved.
//

import UIKit
import SwiftMessages
class Registered_ViewController: BaseViewController {
    var nextBtn = UIButton()
    var phoneTF = UITextField()
    var titleCode = NSString()
    var flag = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addNavBackImg()
        self.addNavTitle(Title: "输入手机号")
        self.addBackButton()
        self.CreatUI()
    }
}
//MARK:-输入手机号
private extension Registered_ViewController {
    //MARK:界面布局
    func CreatUI() -> Void {
        //手机号
        let view = LabelAndTFView(frame: CGRect(x: 0.05*SCREEN_WIDTH, y: 160, width: 0.9*SCREEN_WIDTH, height: 40), titlyArray: ["手机号:"], PlaceholderArray: ["请输入手机号"])
        phoneTF = view.TFArray[0] as! UITextField
        phoneTF.becomeFirstResponder()
        phoneTF.addTarget(self, action: #selector((PhoneTF)), for: .editingChanged)
        self.view.addSubview(view)
        //下一步按钮
        nextBtn = CreateUI.Button("下一步", action: #selector((NextBtn(_:))), sender: self, frame: CGRect(x: 0.05*SCREEN_WIDTH, y: YH(view)+30, width: 0.9*SCREEN_WIDTH, height: 40), backgroundColor: RGBA(76, g: 171, b: 253, a: 1.0), textColor: UIColor.white)
        nextBtn.alpha = 0.3
        nextBtn.isUserInteractionEnabled = false
        self.view.addSubview(nextBtn)
        
        if titleCode.isEqual(to: "注册") {
            flag = "0"
        } else {
            flag = "1"
        }
    }
    //MARK:手机号监听
    @objc func PhoneTF() -> Void {
        let PhoneString = phoneTF.text!
        let regular = RegularExpressions()
        let isPhone = regular.ValidateText(validatedType: .PhoneNumber, validateString: PhoneString)
        
        if isPhone {
            nextBtn.alpha = 1.0
            nextBtn.isUserInteractionEnabled = true
        } else {
            nextBtn.alpha = 0.3
            nextBtn.isUserInteractionEnabled = false
        }
    }
    //MARK:下一步
    @objc func NextBtn(_ btn : UIButton ) -> Void {
        self.SendCodeData()
    }
    //MARK:发送验证码
    func SendCodeData() -> Void {
        HttpRequestTool.sharedInstance.HttpRequestJSONDataWithUrl(url: SendCode, type: .POST, parameters: ["phone":phoneTF.text!,"flag":flag], successed: { (success) in
            let status = success?["status"] as! Int
            if status == 200 {
                let MessageIdentify = MessageIdentifyViewController()
                MessageIdentify.PhoneString = self.phoneTF.text!
                MessageIdentify.titleCode = self.titleCode
                self.navigationController?.pushViewController(MessageIdentify, animated: true)
            } else {
                let msg = success?["msg"] as! String
                SwiftMessageManager.showMessage(layoutType: .MessageView, themeType:.Info, iconImageType:.light, presentationStyleType:.top, title: "", body: msg, isHiddenBtn: true, seconds: 5)
            }
        }) { (error) in
            print("网络问题，请休息一下")
        }
    }
}
