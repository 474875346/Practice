//
//  QuestionnairepageQueryViewController.swift
//  Practice
//
//  Created by 新龙科技 on 2017/2/14.
//  Copyright © 2017年 新龙科技. All rights reserved.
//

import UIKit
import MJRefresh
class QuestionnairepageQueryViewController: BaseViewController,UITableViewDelegate,UITableViewDataSource {
    var pageNumber = 1
    var QuestionnairepageQueryArray:[QuestionnairepageQueryModel] = [QuestionnairepageQueryModel]()
    lazy var QuestionnairepageQueryView: UITableView = {
        let tableview = UITableView(frame: CGRect(x: 0, y: 64, width: SCREEN_WIDTH, height: SCREEN_HEIGHT-64), style: .plain)
        tableview.delegate = self
        tableview.dataSource = self
        //        tableview.separatorStyle = .none
        tableview.mj_header = MJRefreshNormalHeader(refreshingBlock: {
            self.pageNumber = 1
            self.QuestionnairepageQueryData()
        })
        tableview.mj_footer = MJRefreshAutoNormalFooter(refreshingBlock: {
            self.pageNumber += 1
            self.QuestionnairepageQueryData()
        })
        self.view.addSubview(tableview)
        return tableview
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addNavBackImg()
        self.addBackButton()
        self.addNavTitle(Title: "调查问卷列表")
        self.QuestionnairepageQueryView.mj_header.beginRefreshing()
    }
}
extension QuestionnairepageQueryViewController {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return QuestionnairepageQueryArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let  cell = UITableViewCell(style: .value1, reuseIdentifier: "cell")
        let Model = self.QuestionnairepageQueryArray[indexPath.row]
        cell.textLabel?.text = Model.title
        cell.detailTextLabel?.text = Model.createTime
        cell.selectionStyle = .none
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = self.QuestionnairepageQueryArray[indexPath.row]
        let Knowledgepage = QuestionnairepagedetailsViewController()
        Knowledgepage.id = model.id
        self.navigationController?.pushViewController(Knowledgepage, animated: true)
    }

}
private extension QuestionnairepageQueryViewController {
    //MARK:调查问卷列表
    func QuestionnairepageQueryData() -> Void {
        HttpRequestTool.sharedInstance.HttpRequestJSONDataWithUrl(url: Student_questionnaireppageQuery, type: .POST, parameters: ["app_token":UserDefauTake(ZToken)!,"client":deviceUUID!,"pageNumber":"\(pageNumber)"], SafetyCertification: true, successed: { (success) in
            let status = success?["status"] as! Int
            if status == 200 {
                let reportqueryData = success?["data"] as! NSDictionary
                let dataArray = reportqueryData["data"] as! NSArray
                let hasNextPage = reportqueryData["hasNextPage"] as! Bool
                if hasNextPage {
                    self.QuestionnairepageQueryView.mj_footer.endRefreshing()
                } else {
                    self.QuestionnairepageQueryView.mj_footer.endRefreshingWithNoMoreData()
                }
                if self.pageNumber == 1 {
                    self.QuestionnairepageQueryArray.removeAll()
                }
                for p in dataArray {
                    let dic = p as! [String:Any]
                    self.QuestionnairepageQueryArray.append(QuestionnairepageQueryModel.init(dic: dic))
                }
            } else {
                let msg = success?["msg"] as! String
                self.WaringTost(Title: "", Body: msg)
                self.QuestionnairepageQueryView.mj_footer.endRefreshingWithNoMoreData()
            }
            self.QuestionnairepageQueryView.reloadData()
            self.QuestionnairepageQueryView.mj_header.endRefreshing()
        }) { (error) in
            self.ErrorTost()
            self.QuestionnairepageQueryView.mj_header.endRefreshing()
            self.QuestionnairepageQueryView.mj_footer.endRefreshingWithNoMoreData()
        }
    }

}
