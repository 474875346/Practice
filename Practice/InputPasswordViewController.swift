//
//  InputPasswordViewController.swift
//  Practice
//
//  Created by 新龙科技 on 2016/12/28.
//  Copyright © 2016年 新龙科技. All rights reserved.
//

import UIKit

class InputPasswordViewController: BaseViewController,UIPickerViewDelegate,UIPickerViewDataSource {
    var nameTF = UITextField()
    var passwordTF = UITextField()
    var collegeTF = UITextField()
    var picker = UIPickerView()
    lazy var collegeArray : [InputPasswordCollege] = [InputPasswordCollege]()
    var collegeId = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addNavBackImg()
        self.addNavTitle(Title: "设置昵称密码")
        self.addBackButton()
        self.CreatUI()
    }
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.collegeArray.count
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let college = collegeArray[row]
        return college.name
    }
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
        self.collegeData()
        self.picker.frame = CGRect(x: 0, y: SCREEN_HEIGHT-200, width: SCREEN_WIDTH, height: 200)
        self.picker.delegate = self
        self.picker.dataSource = self
        self.picker.isHidden = true
        self.view.addSubview(self.picker)
    }
    //MARK:学院请求
    func collegeData() -> Void {
        HttpRequestTool.sharedInstance.HttpRequestJSONDataWithUrl(url: collegelist, type: .POST, parameters: ["":""], successed: {
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
        
    }
}
