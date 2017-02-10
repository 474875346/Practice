//
//  QuestionHistoryViewController.swift
//  Practice
//
//  Created by 新龙科技 on 2017/2/6.
//  Copyright © 2017年 新龙科技. All rights reserved.
//

import UIKit

class QuestionHistoryViewController: BaseViewController,UITableViewDataSource,UITableViewDelegate,UITextViewDelegate {
    var Model:OnlineConsultingModel?
    var send:UIButton?
    var textview:UITextView?
    lazy var QuestionHistorytableView: UITableView = {
        let tableview = UITableView(frame: CGRect(x: 0, y: 64, width: SCREEN_WIDTH, height: SCREEN_HEIGHT-108), style: .plain)
        tableview.delegate = self
        tableview.dataSource = self
        tableview.separatorStyle = .none
        tableview.rowHeight = 150
        return tableview
    }()
    var InputBox = UIView()
    var QuestionHistoryArray = [QuestionHistoryModel]()
    var mHeightTextView:CGFloat = 44
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addNavBackImg()
        self.addNavTitle(Title: "问题回复")
        self.addBackButton()
        self.getQuestionHistoryData()
        self.view.addSubview(QuestionHistorytableView)
        let input = InputboxView(frame: CGRect(x: 0, y: SCREEN_HEIGHT-44, width: SCREEN_WIDTH, height: 44), VC: self)
        input.InputBlock = {
            self.questionreplayData()
        }
        send = input.send
        InputBox = input
        textview = input.textview
        textview?.delegate = self
        self.view.addSubview(input)
    }
}
extension QuestionHistoryViewController {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return QuestionHistoryArray.count
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let  cell = Bundle.main.loadNibNamed("QuestionHistoryTableViewCell", owner: nil, options: nil)?.first as! QuestionHistoryTableViewCell?
            cell?.title?.text = Model?.title
            cell?.Hcontent.text = Model?.content
            cell?.selectionStyle = .none
            return cell!
        } else {
            var cell = tableView.dequeueReusableCell(withIdentifier: "history2") as! QuestionHistoryTableViewCell?
            if cell == nil {
                cell = Bundle.main.loadNibNamed("QuestionHistoryTableViewCell", owner: nil, options: nil)?.last as! QuestionHistoryTableViewCell?
            }
            let model = QuestionHistoryArray[indexPath.row]
            cell?.name.text = model.replayPerson!
            cell?.time?.text = model.createTime!
            cell?.Content.text = model.content!
                        cell?.selectionStyle = .none
            return cell!
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section != 0 {
            let model = QuestionHistoryArray[indexPath.row]
            let size = getAttributeSize(text: model.content! as NSString, fontSize: 20, With: SCREEN_WIDTH)
            return size.height+40
        } else {
            let string = "\(Model?.content!)" as NSString
            let size = getAttributeSize(text:string, fontSize: 20, With: SCREEN_WIDTH)
            return size.height+40
        }
    }
    func textViewDidChange(_ textView: UITextView) {
        let size = textView.sizeThatFits(CGSize(width: SCREEN_WIDTH-105, height: 110))
        print(size.height)
        var content:CGFloat = 44
        if size.height > 110 {
            content = 110
            textView.isScrollEnabled = true
        } else {
            content = size.height
            textView.isScrollEnabled = false
        }
        if mHeightTextView != content  {
            self.textview?.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH-100, height:content)
            self.InputBox.frame = CGRect(x: 0, y: SCREEN_HEIGHT-content, width: SCREEN_WIDTH, height: content)
            self.QuestionHistorytableView.frame = CGRect(x: 0, y: 64, width: SCREEN_WIDTH, height: SCREEN_HEIGHT-64-content)
        }
        send?.frame = CGRect(x: SCREEN_WIDTH-100, y: H(InputBox)-44, width: 100, height: 44)
        self.scrollsToBottomAnimated()
    }
}
private extension QuestionHistoryViewController {
    //MARK:问题回复
    func questionreplayData() -> Void {
        if (self.textview?.text.isEmpty)! {
            return
        }
        HttpRequestTool.sharedInstance.HttpRequestJSONDataWithUrl(url: Student_questionreplay, type: .POST, parameters: ["app_token":UserDefauTake(ZToken)!,"client":deviceUUID!,"questionId":(Model?.id)!,"replay":(self.textview?.text)!], SafetyCertification: true, successed: { (success) in
            let status = success?["status"] as! Int
            if status == 200 {
                self.textview?.text = ""
                self.textview?.resignFirstResponder()
                self.send?.frame = CGRect(x: SCREEN_WIDTH-100, y: 0, width: 100, height: 44)
                self.textview?.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH-100, height:44)
                self.InputBox.frame = CGRect(x: 0, y: SCREEN_HEIGHT-44, width: SCREEN_WIDTH-100, height:44)
                self.QuestionHistorytableView.frame = CGRect(x: 0, y: 64, width: SCREEN_WIDTH, height: SCREEN_HEIGHT-108)
                self.getQuestionHistoryData()
            } else {
                let msg = success?["msg"] as! String
                self.WaringTost(Title: "", Body: msg)
            }
        }) { (error) in
            self.ErrorTost()
        }
    }
    //MARK:获取问题回复列表
    func getQuestionHistoryData() -> Void {
        HttpRequestTool.sharedInstance.HttpRequestJSONDataWithUrl(url: Student_getQuestionHistory, type: .POST, parameters: ["app_token":UserDefauTake(ZToken)!,"client":deviceUUID!,"questionId":(Model?.id)!], SafetyCertification: true, successed: { (success) in
            let status = success?["status"] as! Int
            if status == 200 {
                self.QuestionHistoryArray.removeAll()
                let dataArray = success?["data"] as! NSArray
                for p in dataArray {
                    let dic = p as! [String:Any]
                    self.QuestionHistoryArray.append(QuestionHistoryModel.init(dic: dic))
                }
            } else {
                let msg = success?["msg"] as! String
                self.WaringTost(Title: "", Body: msg)
            }
            self.QuestionHistorytableView.reloadData()
            //            self.scrollsToBottomAnimated()
        }) { (error) in
            self.ErrorTost()
        }
    }
    //MARK:滑动到最底部
    func scrollsToBottomAnimated() -> Void {
        let index = IndexPath(row: self.QuestionHistoryArray.count-1, section: 1)
        self.QuestionHistorytableView.scrollToRow(at: index , at: .bottom, animated: false)
    }
}
