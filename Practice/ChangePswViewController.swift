//
//  ChangePswViewController.swift
//  Practice
//
//  Created by 新龙科技 on 2017/1/4.
//  Copyright © 2017年 新龙科技. All rights reserved.
//

import UIKit

class ChangePswViewController: BaseViewController {
    var oldpswTF = UITextField()
    var newpswTF = UITextField()
    var confirmnewpswTF = UITextField()
    var ChangePswButton = UIButton()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addNavBackImg()
        self.addNavTitle(Title: "修改密码")
        self.addBackButton()
        self.CreatUI()
    }
    override func BackButton() {
        self.dismiss(animated: true, completion: nil)
    }
}
private extension ChangePswViewController {
    func CreatUI() -> Void {
        //MARK:旧密码和新密码
        let view  = LabelAndTFView(frame: CGRect(x: 0.05*SCREEN_WIDTH, y: 200, width: 0.9*SCREEN_WIDTH, height: 80), titlyArray: ["原密码:","新密码:","新密码:"], PlaceholderArray: ["请输入原密码","请输入新密码","请确认新密码"])
        oldpswTF = view.TFArray[0] as! UITextField
        oldpswTF.addTarget(self, action: #selector((self.ChangPsw)), for: .editingChanged)
        newpswTF = view.TFArray[1] as! UITextField
        newpswTF.addTarget(self, action: #selector((self.ChangPsw)), for: .editingChanged)
        confirmnewpswTF = view.TFArray[2] as! UITextField
        confirmnewpswTF.addTarget(self, action: #selector((self.ChangPsw)), for: .editingChanged)
        self.view.addSubview(view)
        //MARK:修改密码
        ChangePswButton = CreateUI.Button("修改密码", action: #selector((self.ChangePswBtn)), sender: self, frame: CGRect(x: 0.05*SCREEN_WIDTH, y: YH(view)+30, width: 0.9*SCREEN_WIDTH, height: 40), backgroundColor:RGBA(76, g: 171, b: 253, a: 1.0) , textColor: UIColor.white)
        ChangePswButton.alpha = 0.3
        ChangePswButton.isUserInteractionEnabled = false
        self.view.addSubview(ChangePswButton)
    }
    @objc func ChangePswBtn() -> Void {
        self.ChangePswData()
    }
    //MARK:密码监听
    @objc func ChangPsw() -> Void {
        let oldpswString = oldpswTF.text! as NSString
        let newpswString = newpswTF.text! as NSString
        let confirmnewpswString = confirmnewpswTF.text! as NSString
        if newpswString.length > 20 {
            newpswTF.text = newpswString.substring(to: 20)
        }
        if confirmnewpswString.length > 20 {
            confirmnewpswTF.text = newpswString.substring(to: 20)
        }
        if !oldpswString.isEqual(to: "") {
            if !newpswString.isEqual(to: "") {
                if !confirmnewpswString.isEqual(to: "") {
                    if newpswString.isEqual(to: confirmnewpswTF.text!) {
                        ChangePswButton.alpha = 1
                        ChangePswButton.isUserInteractionEnabled = true
                    } else {
                        ChangePswButton.alpha = 0.3
                        ChangePswButton.isUserInteractionEnabled = false
                    }
                } else {
                    ChangePswButton.alpha = 0.3
                    ChangePswButton.isUserInteractionEnabled = false
                }
            } else {
                ChangePswButton.alpha = 0.3
                ChangePswButton.isUserInteractionEnabled = false
            }
        } else {
            ChangePswButton.alpha = 0.3
            ChangePswButton.isUserInteractionEnabled = false
        }
    }
    //MARK:修改密码请求
    func  ChangePswData() -> Void {
        HttpRequestTool.sharedInstance.HttpRequestJSONDataWithUrl(url: Student_changePass, type: .POST, parameters: ["app_token":UserDefauTake(ZToken)!,"client":deviceUUID!,"old_password":oldpswTF.text!,"password":newpswTF.text!,"re_password":confirmnewpswTF.text!], SafetyCertification: true, successed: { (success) in
            let status = success?["status"] as! Int
            if status == 200 {
                self.SuccessTost(Title: "", Body: "修改密码成功")
                self.dismiss(animated: true, completion: nil)
            } else {
                let msg = success?["msg"] as! String
                self.WaringTost(Title: "", Body: msg)
            }
        }) { (error) in
            self.ErrorTost()
        }
    }
}
