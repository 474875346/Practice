//
//  QuestionsViewController.swift
//  Practice
//
//  Created by 新龙科技 on 2017/2/4.
//  Copyright © 2017年 新龙科技. All rights reserved.
//

import UIKit

class QuestionsViewController: BaseViewController,UIPickerViewDelegate,UIPickerViewDataSource {
    var titleTextView : UITextView?
    var contentTextView : UITextView?
    lazy var picker: UIPickerView = {
        let picker = UIPickerView(frame: CGRect(x: 0, y: SCREEN_HEIGHT-200, width: SCREEN_WIDTH, height: 200))
        picker.delegate = self
        picker.dataSource = self
        picker.isHidden = true
        self.view.addSubview(picker)
        return picker
    }()
    var TeacherArray:[TeacherModel] = [TeacherModel]()
    var TeacherButton = UIButton()
    var Teacherid = ""
    var  Block:(()->Void)?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addNavBackImg()
        self.addNavTitle(Title: "咨询问题")
        self.addBackButton()
        self.createUI()
        self.getTeacher()
    }
}
extension QuestionsViewController {
    //MARK:Picker行数
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return TeacherArray.count
    }
    //MARK:Picker列数
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    //MARK:Picker标题
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let teacher = TeacherArray[row]
        return teacher.realName!
    }
    //MARK:picker选中标题
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let teacher = TeacherArray[row]
        TeacherButton.setTitle(teacher.realName!, for: .normal)
        Teacherid = teacher.id!
        self.picker.isHidden = true
    }
}
private extension QuestionsViewController {
    func createUI() -> Void {
        let myscrollview = UIScrollView(frame: CGRect(x: 0, y: 64, width: SCREEN_WIDTH, height: SCREEN_HEIGHT-104))
        myscrollview.bounces = false
        self.view.addSubview(myscrollview)
        let plan = TextViewAndLine.init(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 101), title: "问题标题:", planceholder: "请输入问题标题")
        titleTextView = plan.contTextView
        myscrollview.addSubview(plan)
        let summary = TextViewAndLine.init(frame: CGRect(x: 0, y: YH(plan), width: SCREEN_WIDTH, height: 101), title: "问题内容:", planceholder: "请输入问题内容")
        contentTextView = summary.contTextView
        myscrollview.addSubview(summary)
        
        TeacherButton = CreateUI.Button("选择老师", action: #selector((self.TeacherBtn)), sender: self, frame: CGRect(x: 0, y: YH(summary)+10, width: SCREEN_WIDTH, height: 40), backgroundColor: UIColor.clear, textColor:RGBA(76, g: 176, b: 253, a: 1.0))
        TeacherButton.titleLabel!.font = UIFont.systemFont(ofSize: 20)
        myscrollview.addSubview(TeacherButton)
        
        let submitButton = CreateUI.Button("提交", action: #selector((self.submit)), sender: self, frame: CGRect(x: 0, y: SCREEN_HEIGHT-40, width: SCREEN_WIDTH, height: 40), backgroundColor: RGBA(76, g: 176, b: 253, a: 1.0), textColor: UIColor.white)
        self.view.addSubview(submitButton)
    }
    @objc func TeacherBtn() ->Void {
        self.picker.isHidden = false
    }
    @objc func submit() ->Void {
        self.questionconsult()
    }
    //MARK:提交咨询问题
    func questionconsult() -> Void {
        if (titleTextView?.text.isEmpty)! {
            self.WaringTost(Title: "", Body: "问题标题不能为空")
            return
        }
        if (contentTextView?.text.isEmpty)! {
            self.WaringTost(Title: "", Body: "问题内容不能为空")
            return
        }
        if Teacherid.isEmpty {
            self.WaringTost(Title: "", Body: "老师不能不选择")
            return
        }
        if UserDefauTake(ZregistID) == nil {
            UserDefaultSave(ZregistID, Value: "")
        }
        HttpRequestTool.sharedInstance.HttpRequestJSONDataWithUrl(url: Student_questionconsult, type: .POST, parameters: ["app_token":UserDefauTake(ZToken)!,"client":deviceUUID!,"title":(titleTextView?.text)!,"content":(contentTextView?.text)!,"userId":Teacherid], SafetyCertification: true, successed: { (success) in
            let status = success?["status"] as! Int
            if status == 200 {
                self.Block!()
                self.SuccessTost(Title: "", Body: "提交成功")
                _ = self.navigationController?.popViewController(animated: true)
            } else {
                let msg = success?["msg"] as! String
                self.WaringTost(Title: "", Body: msg)
            }
        }) { (error) in
            self.ErrorTost()
        }
    }
    //MARK:老师列表
    func getTeacher() -> Void {
        HttpRequestTool.sharedInstance.HttpRequestJSONDataWithUrl(url: Student_questiongetTeacher, type: .POST, parameters: ["app_token":UserDefauTake(ZToken)!,"client":deviceUUID!], SafetyCertification: true, successed: { (success) in
            let status = success?["status"] as! Int
            if status == 200 {
                let dataArray = success?["data"] as! NSArray
                for p in dataArray {
                    let dic = p as! [String:Any]
                    self.TeacherArray.append(TeacherModel.init(dic: dic))
                }
            }
            self.picker.reloadAllComponents()
        }) { (error) in
        }
    }
}
