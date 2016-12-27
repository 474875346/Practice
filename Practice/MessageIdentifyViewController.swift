//
//  MessageIdentifyViewController.swift
//  Practice
//
//  Created by 新龙科技 on 2016/12/27.
//  Copyright © 2016年 新龙科技. All rights reserved.
//

import UIKit

class MessageIdentifyViewController: BaseViewController {
    var PhoneString = String()
    let buttonArray = NSMutableArray()
    let hiddenTF = UITextField()
    var inputButton = UIButton()
    var codeButton = UIButton()
    var value = 59
    var cycyleTimer : Timer?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addNavBackImg()
        self.addNavTitle(Title: "填写验证码")
        self.addBackButton()
        self.CreatUI()
    }
    func CreatUI() -> Void {
        hiddenTF.frame  = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 1)
        hiddenTF.backgroundColor = UIColor.clear
        hiddenTF.textColor = UIColor.clear
        hiddenTF.addTarget(self, action: #selector((HiddenTF)), for: .editingChanged)
        hiddenTF.becomeFirstResponder()
        self.view.addSubview(hiddenTF)
        //已发送
        let titleLabel = UILabel(frame: CGRect(x: 0.15*SCREEN_WIDTH, y: 100, width: 0.7*SCREEN_WIDTH, height: 30))
        titleLabel.text = "验证码已发送到手机: \(PhoneString)"
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.systemFont(ofSize: 13)
        self.view.addSubview(titleLabel)
        //创建6个按钮
        for i in 0..<6 {
            let space = 0.1*SCREEN_WIDTH/5
            let button = UIButton(type: .custom)
            button.frame = CGRect(x: 0.15 * SCREEN_WIDTH + (space + 0.1 * SCREEN_WIDTH) * ConversionCGFloat(i), y: YH(titleLabel)+50, width:  0.1 * SCREEN_WIDTH, height:  0.1 * SCREEN_WIDTH)
            button.addTarget(self, action: #selector((messageButton(_:))), for: .touchUpInside)
            button.setTitleColor(UIColor.black, for: .normal)
            button.setBackgroundImage(UIImage(named: "border_gray"), for: .normal)
            button.setBackgroundImage(UIImage(named: "border_blue"), for: .selected)
            if i == 0 {
                button.isSelected = true
                inputButton = button
            }
            self.view.addSubview(button)
            buttonArray.add(button)
        }
        let nextBtn = CreateUI.Button("下一步", action: #selector((NextBtn(_:))), sender: self, frame: CGRect(x: 0.05*SCREEN_WIDTH, y: YH(titleLabel)+70+0.1*SCREEN_WIDTH, width: 0.9*SCREEN_WIDTH, height: 40), backgroundColor: RGBA(76, g: 171, b: 253, a: 1.0), textColor: UIColor.white)
        nextBtn.alpha = 0.3
        self.view.addSubview(nextBtn)
        codeButton = CreateUI.Button("获取验证码", action: #selector((CodeButton(_:))), sender: self, frame: CGRect(x: SCREEN_WIDTH / 2-50, y: YH(nextBtn)+30, width: 100, height: 30), backgroundColor: UIColor.clear, textColor: UIColor.lightGray)
        self.view.addSubview(codeButton)
        self.Countdown()
    }
    //MARK:发送验证码
    func CodeButton(_ btn : UIButton ) -> Void {
        value = 59
        self.Countdown()
    }
    func CycyleTimer() -> Void {
        value -= 1;
        if value == 0 {
             codeButton.setTitle("重新发送", for: .normal)
            codeButton.setTitleColor(UIColor.black, for: .normal)
            codeButton.isUserInteractionEnabled = true
            self.removeCycleTimer()
        } else {
             codeButton.setTitle("\(value)秒后重发", for: .normal)
            codeButton.setTitleColor(UIColor.lightGray, for: .normal)
            codeButton.isUserInteractionEnabled = false
        }
    }
    fileprivate func removeCycleTimer() {
        // 从运行循环中移除
        cycyleTimer?.invalidate()
        cycyleTimer = nil
    }
    func Countdown() -> Void {
        DispatchQueue.global().async {
            self.cycyleTimer = Timer(timeInterval: 1.0, target: self, selector: #selector(self.CycyleTimer), userInfo: nil, repeats: true)
            RunLoop.main.add(self.cycyleTimer!, forMode:RunLoopMode.commonModes)
        }
    }
    //MARK:下一步
    func NextBtn(_ btn : UIButton ) -> Void {
        
    }
    //MARK:输入验证码
    func messageButton(_ btn : UIButton ) -> Void {
        hiddenTF.becomeFirstResponder()
    }
    //MARK:隐藏的文本框
    func HiddenTF() -> Void {
        let NumString = hiddenTF.text! as NSString
        let regular = RegularExpressions()
        let isNum = regular.ValidateText(validatedType: .Number, validateString: NumString as String)
        
        if isNum == false {
            print("验证码只能输入数字")
            hiddenTF.text = NumString.substring(to: NumString.length)
        }
        for oldbtn in buttonArray {
            let btn = oldbtn as! UIButton
            btn.setTitle("", for: .normal)
        }
        for i in 0..<NumString.length {
            let button = buttonArray[i] as! UIButton
            button.setTitle(NumString.substring(with: NSMakeRange(i, 1)), for: .normal)
        }
        if NumString.length == 6 {
            for i in 0..<NumString.length {
                let button = buttonArray[i] as! UIButton
                button.setTitle("", for: .normal)
                hiddenTF.text = ""
              let firstButton = buttonArray[0] as! UIButton
                inputButton.isSelected = false
                firstButton.isSelected = true
                inputButton = firstButton
            }
        }else {
            let button = self.buttonArray[NumString.length] as! UIButton
            self.inputButton.isSelected = false
            button.isSelected = true
            self.inputButton = button
        }
    }
}
