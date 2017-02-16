//
//  ViewController.swift
//  Practice
//
//  Created by 新龙科技 on 2016/12/27.
//  Copyright © 2016年 新龙科技. All rights reserved.
//

import UIKit

class ViewController: BaseViewController,CAAnimationDelegate {
    var phoneTF = UITextField()
    var pswTF = UITextField()
    var backBlcok:(()->Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.CreatUI()
    }
}
//MARK:-登录界面
private extension ViewController {
    //MARK:-登录布局
    func CreatUI() -> Void {
        //MARK:手机号和密码
        let view  = LabelAndTFView(frame: CGRect(x: 0.05*SCREEN_WIDTH, y: 200, width: 0.9*SCREEN_WIDTH, height: 80), titlyArray: ["手机号","密码"], PlaceholderArray: ["请输入手机号","请输入密码"])
        phoneTF = view.TFArray[0] as! UITextField
        pswTF = view.TFArray[1] as! UITextField
//        view.heroID = "res"
        self.view.addSubview(view)
        //MARK:登录
        let LoginButton = CreateUI.Button("登录", action: #selector((LogInBtn(_:))), sender: self, frame: CGRect(x: 0.05*SCREEN_WIDTH, y: YH(view)+30, width: 0.9*SCREEN_WIDTH, height: 40), backgroundColor:RGBA(76, g: 171, b: 253, a: 1.0) , textColor: UIColor.white)
        LoginButton.tag = 100
//        LoginButton.heroID = "resbtn"
        self.view.addSubview(LoginButton)
        //MARK:忘记密码
        let ForGetButton = CreateUI.Button("忘记密码", action: #selector((forgetButton(_:))), sender: self, frame: CGRect(x: 0.95*SCREEN_WIDTH-80, y: YH(LoginButton)+30, width: 80, height: 40), backgroundColor: UIColor.clear, textColor: RGBA(76, g: 171, b: 253, a: 1.0))
        self.view.addSubview(ForGetButton)
        //MARK:注册
        let RegisterButton = CreateUI.Button("新用户注册", action: #selector((registerButton(_:))), sender: self, frame: CGRect(x: 0.05*SCREEN_WIDTH, y: YH(LoginButton)+30, width: 80, height: 40), backgroundColor: UIColor.clear, textColor:  RGBA(76, g: 171, b: 253, a: 1.0))
        self.view.addSubview(RegisterButton)
    }
    //MARK:注册点击方法
    @objc func registerButton(_ btn : UIButton ) -> Void {
        let registered = Registered_ViewController()
        registered.titleCode = "注册"
        self.navigationController?.pushViewController(registered, animated: true)
    }
    //MARK:忘记密码点击方法
    @objc func forgetButton(_ btn : UIButton) -> Void {
        let registered = Registered_ViewController()
        registered.titleCode = "忘记密码"
        self.navigationController?.pushViewController(registered, animated: true)
    }
    //MARK:登录点击方法
    @objc func LogInBtn(_ btn : UIButton) -> Void {
        self.LogInData()
    }
    //MARK:按钮动画
    func btnAnimate() -> Void {
        let btn = view.viewWithTag(100)
        //1.选定角色
        let layer = btn?.layer
        layer?.cornerRadius = 5.0
        //2.写剧本
        let keyAnimate = CAKeyframeAnimation(keyPath: "position")
        //3.设定关键帧
        let value0 = NSValue(cgPoint: (layer?.position)!)
        let value1 = NSValue(cgPoint: CGPoint(x: (layer?.position.x)!+10, y:  (layer?.position.y)! ))
        let value2 = NSValue(cgPoint: CGPoint(x: (layer?.position.x)!-10, y:  (layer?.position.y)!))
        let value3 = NSValue(cgPoint: CGPoint(x: (layer?.position.x)!+10, y:  (layer?.position.y)!))
        let value4 = NSValue(cgPoint: (layer?.position)!)
        keyAnimate.values = [value0, value1, value2, value3, value4]
        keyAnimate.autoreverses = false
        keyAnimate.repeatCount = 1
        keyAnimate.duration = 0.2
        layer?.add(keyAnimate, forKey: "keyAnimate")
    }
    //MARK:登录请求
    func LogInData() -> Void {
        if (self.phoneTF.text?.isEmpty)! {
            self.WaringTost(Title: "", Body: "手机号不能为空")
            self.btnAnimate()
            return
        }
        if (self.pswTF.text?.isEmpty)! {
            self.WaringTost(Title: "", Body: "密码不能为空")
            self.btnAnimate()
            return
        }
        var registrationId = ""
        if UserDefauTake(ZregistID) != nil {
            registrationId = UserDefauTake(ZregistID)!
        }

        HttpRequestTool.sharedInstance.HttpRequestJSONDataWithUrl(url: Student_Login, type: .POST, parameters: ["client":deviceUUID!,"phone":self.phoneTF.text!,"password":pswTF.text!,"registrationId":registrationId], SafetyCertification: true,successed: { (success) in
            let status = success?["status"] as! Int
            if status == 200 {
                let data = success?["data"] as! NSDictionary
                let token = data["access_token"]  as! String
                let college = data["collegeName"] as! String?
                let refresh_token = data["refresh_token"] as! String?
                UserDefaultSave("access_token", Value: token)
                UserDefaultSave("CollegeName", Value: college)
                UserDefaultSave(Zrefresh_token, Value: refresh_token)
                if (UserDefaults().objectIsForced(forKey: ZLogInOut) == true ) {
                    self.dismiss(animated: true, completion: nil)
                    UserDefaults().set(false, forKey: ZLogInOut)
                    self.backBlcok!()
                } else {
                    let delegate = UIApplication.shared.delegate as! AppDelegate
                    delegate.CreatTabbar()
                }
                self.SuccessTost(Title: "", Body: "登录成功")
            } else {
                let msg = success?["msg"] as! String
                self.WaringTost(Title: "", Body: msg)
                self.btnAnimate()
            }
        }) { (error) in
            self.ErrorTost()
        }
    }
}
