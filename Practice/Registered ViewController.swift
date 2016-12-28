//
//  Registered ViewController.swift
//  Practice
//
//  Created by 新龙科技 on 2016/12/27.
//  Copyright © 2016年 新龙科技. All rights reserved.
//

import UIKit

class Registered_ViewController: BaseViewController {
    var nextBtn = UIButton()
    var phoneTF = UITextField()
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
        phoneTF.addTarget(self, action: #selector((PhoneTF)), for: .editingChanged)
        self.view.addSubview(view)
        //下一步按钮
        nextBtn = CreateUI.Button("下一步", action: #selector((NextBtn(_:))), sender: self, frame: CGRect(x: 0.05*SCREEN_WIDTH, y: YH(view)+30, width: 0.9*SCREEN_WIDTH, height: 40), backgroundColor: RGBA(76, g: 171, b: 253, a: 1.0), textColor: UIColor.white)
        nextBtn.alpha = 0.3
        nextBtn.isUserInteractionEnabled = false
        self.view.addSubview(nextBtn)
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
        let MessageIdentify = MessageIdentifyViewController()
        MessageIdentify.PhoneString = phoneTF.text!
        self.navigationController?.pushViewController(MessageIdentify, animated: true)
    }
}
