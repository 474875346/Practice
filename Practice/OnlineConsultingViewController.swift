//
//  OnlineConsultingViewController.swift
//  Practice
//
//  Created by 新龙科技 on 2017/2/4.
//  Copyright © 2017年 新龙科技. All rights reserved.
//

import UIKit
import MJRefresh
class OnlineConsultingViewController: BaseViewController,UITableViewDelegate,UITableViewDataSource {
    var pageNumber = 1
    var OnlineConsultingArray:[OnlineConsultingModel] = [OnlineConsultingModel]()
    lazy var OnlineConsultingtableView: UITableView = {
        let tableview = UITableView(frame: CGRect(x: 0, y: 64, width: SCREEN_WIDTH, height: SCREEN_HEIGHT-64), style: .plain)
        tableview.delegate = self
        tableview.dataSource = self
        tableview.separatorStyle = .none
        tableview.rowHeight = 150
        tableview.mj_header = MJRefreshNormalHeader(refreshingBlock: {
            self.pageNumber = 1
            self.questionlistData()
        })
        tableview.mj_footer = MJRefreshAutoNormalFooter(refreshingBlock: {
            self.pageNumber += 1
            self.questionlistData()
        })
        self.view.addSubview(tableview)
        return tableview
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addNavBackImg()
        self.addBackButton()
        self.addNavTitle(Title: "在线咨询列表")
        self.questionlistData()
        self.OnlineConsultingButton()
    }
}
extension OnlineConsultingViewController {
    override func BackButton() {
        self.dismiss(animated: true, completion: nil)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return OnlineConsultingArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let  cell = Bundle.main.loadNibNamed("OnlineConsultingTableViewCell", owner: nil, options: nil)?.first as! OnlineConsultingTableViewCell?
        let model = OnlineConsultingArray[indexPath.row]
        cell?.title?.text = model.title
        cell?.content.text = model.content
        cell?.selectionStyle = .none
        return cell!
    }
    //MARK:返回行高
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let model = self.OnlineConsultingArray[indexPath.row]
        let size = getAttributeSize(text: model.content! as NSString, fontSize: 17, With: SCREEN_WIDTH-40)
        return size.height+38
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.navigationController?.pushViewController(QuestionHistoryViewController(), animated: true)
    }
}
private extension OnlineConsultingViewController {
    //MARK:提交咨询按钮
    func OnlineConsultingButton() -> Void {
        let btn = UIButton(type: .custom)
        btn.frame = CGRect(x: SCREEN_WIDTH-100, y: 20, width: 80, height: 44)
        btn.setTitle("提交问题", for: .normal)
        btn.addTarget(self, action: #selector((self.questions)), for: .touchUpInside)
        self.view.addSubview(btn)
    }
    @objc func questions() -> Void {
        let Questions = QuestionsViewController()
        Questions.Block = {
         self.questionlistData()
        }
        self.navigationController?.pushViewController(Questions, animated: true)
    }
    //MARK:在线咨询列表
    func questionlistData() -> Void {
        HttpRequestTool.sharedInstance.HttpRequestJSONDataWithUrl(url: Student_questionlist, type: .POST, parameters: ["app_token":UserDefauTake(ZToken)!,"client":deviceUUID!,"pageNumber":"\(pageNumber)"], SafetyCertification: true, successed: { (success) in
            let status = success?["status"] as! Int
            if status == 200 {
                let reportqueryData = success?["data"] as! NSDictionary
                let dataArray = reportqueryData["data"] as! NSArray
                let hasNextPage = reportqueryData["hasNextPage"] as! Bool
                if hasNextPage {
                    self.OnlineConsultingtableView.mj_footer.endRefreshing()
                } else {
                    self.OnlineConsultingtableView.mj_footer.endRefreshingWithNoMoreData()
                }
                if self.pageNumber == 1 {
                    self.OnlineConsultingArray.removeAll()
                }
                for p in dataArray {
                    let dic = p as! [String:Any]
                    self.OnlineConsultingArray.append(OnlineConsultingModel.init(dic: dic))
                }
            } else {
                let msg = success?["msg"] as! String
                self.WaringTost(Title: "", Body: msg)
                self.OnlineConsultingtableView.mj_footer.endRefreshingWithNoMoreData()
            }
            self.OnlineConsultingtableView.reloadData()
            self.OnlineConsultingtableView.mj_header.endRefreshing()
        }) { (error) in
            self.ErrorTost()
            self.OnlineConsultingtableView.mj_header.endRefreshing()
            self.OnlineConsultingtableView.mj_footer.endRefreshingWithNoMoreData()
        }
    }
}
