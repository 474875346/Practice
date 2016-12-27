//
//  ViewController.swift
//  Practice
//
//  Created by 新龙科技 on 2016/12/27.
//  Copyright © 2016年 新龙科技. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        //手机号和密码
        let view  = LabelAndTFView(frame: CGRect(x: 0.05*SCREEN_WIDTH, y: 200, width: 0.9*SCREEN_WIDTH, height: 80), titlyArray: ["手机号","密码"], PlaceholderArray: ["请输入手机号","请输入密码"])
        self.view.addSubview(view)
        //登录
        let LoginButton = CreateUI.Button("登录", action: #selector((LogInBtn(_:))), sender: self, frame: CGRect(x: 0.05*SCREEN_WIDTH, y: YH(view)+30, width: 0.9*SCREEN_WIDTH, height: 40), backgroundColor:RGBA(76, g: 171, b: 253, a: 1.0) , textColor: UIColor.white)
        self.view.addSubview(LoginButton)
        //忘记密码
        let ForGetButton = CreateUI.Button("忘记密码", action: #selector((forgetButton(_:))), sender: self, frame: CGRect(x: 0.95*SCREEN_WIDTH-80, y: YH(LoginButton)+30, width: 80, height: 40), backgroundColor: UIColor.clear, textColor: RGBA(76, g: 171, b: 253, a: 1.0))
        self.view.addSubview(ForGetButton)
        //注册
        let RegisterButton = CreateUI.Button("新用户注册", action: #selector((registerButton(_:))), sender: self, frame: CGRect(x: 0.05*SCREEN_WIDTH, y: YH(LoginButton)+30, width: 80, height: 40), backgroundColor: UIColor.clear, textColor:  RGBA(76, g: 171, b: 253, a: 1.0))
        self.view.addSubview(RegisterButton)
    }
    //MARK:注册
    func registerButton(_ btn : UIButton ) -> Void {
        
    }
    //MARK:忘记密码
    func forgetButton(_ btn : UIButton) -> Void {
        
    }
    //MARK:登录
    func LogInBtn(_ btn : UIButton) -> Void {
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

