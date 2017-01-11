//
//  ViewController.swift
//  Practice
//
//  Created by 新龙科技 on 2016/12/27.
//  Copyright © 2016年 新龙科技. All rights reserved.
//

import UIKit

class ViewController: BaseViewController {
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
        view.heroID = "res"
        self.view.addSubview(view)
        //MARK:登录
        let LoginButton = CreateUI.Button("登录", action: #selector((LogInBtn(_:))), sender: self, frame: CGRect(x: 0.05*SCREEN_WIDTH, y: YH(view)+30, width: 0.9*SCREEN_WIDTH, height: 40), backgroundColor:RGBA(76, g: 171, b: 253, a: 1.0) , textColor: UIColor.white)
        LoginButton.heroID = "resbtn"
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
    //MARK:登录请求
    func LogInData() -> Void {
        HttpRequestTool.sharedInstance.HttpRequestJSONDataWithUrl(url: Student_Login, type: .POST, parameters: ["client":deviceUUID!,"phone":self.phoneTF.text!,"password":pswTF.text!], SafetyCertification: true,successed: { (success) in
            let status = success?["status"] as! Int
            if status == 200 {
                let data = success?["data"] as! NSDictionary
                let token = data["access_token"]  as! String
                let college = data["collegeName"] as! String?
                UserDefaultSave("access_token", Value: token)
                UserDefaultSave("CollegeName", Value: college)
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
            }
        }) { (error) in
            self.ErrorTost()
        }
    }
}




