//
//  KnowledgepageQueryViewController.swift
//  Practice
//
//  Created by 新龙科技 on 2017/2/14.
//  Copyright © 2017年 新龙科技. All rights reserved.
//

import UIKit
import MJRefresh
class KnowledgepageQueryViewController: BaseViewController,UITableViewDelegate,UITableViewDataSource {
    var pageNumber = 1
    var KnowledgepageQueryArray:[KnowledgepageQueryModel] = [KnowledgepageQueryModel]()
    lazy var KnowledgepageQueryView: UITableView = {
        let tableview = UITableView(frame: CGRect(x: 0, y: 64, width: SCREEN_WIDTH, height: SCREEN_HEIGHT-64), style: .plain)
        tableview.delegate = self
        tableview.dataSource = self
//        tableview.separatorStyle = .none
        tableview.mj_header = MJRefreshNormalHeader(refreshingBlock: {
            self.pageNumber = 1
            self.KnowledgepageQueryData()
        })
        tableview.mj_footer = MJRefreshAutoNormalFooter(refreshingBlock: {
            self.pageNumber += 1
            self.KnowledgepageQueryData()
        })
        self.view.addSubview(tableview)
        return tableview
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.addNavBackImg()
        self.addBackButton()
        self.addNavTitle(Title: "知识课堂列表")
        self.KnowledgepageQueryView.mj_header.beginRefreshing()
    }
}
extension KnowledgepageQueryViewController {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return KnowledgepageQueryArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let  cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        let Model = self.KnowledgepageQueryArray[indexPath.row]
        cell.textLabel?.text = Model.name
        cell.selectionStyle = .none
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = self.KnowledgepageQueryArray[indexPath.row]
        let Knowledgepage = KnowledgepageDetailsViewController()
        Knowledgepage.URL = model.url
        Knowledgepage.Name = model.name
        self.navigationController?.pushViewController(Knowledgepage, animated: true)
    }
}

private extension KnowledgepageQueryViewController {
    //MARK:知识课堂列表
    func KnowledgepageQueryData() -> Void {
        HttpRequestTool.sharedInstance.HttpRequestJSONDataWithUrl(url: Student_knowledgepageQuery, type: .POST, parameters: ["app_token":UserDefauTake(ZToken)!,"client":deviceUUID!,"pageNumber":"\(pageNumber)"], SafetyCertification: true, successed: { (success) in
            let status = success?["status"] as! Int
            if status == 200 {
                let reportqueryData = success?["data"] as! NSDictionary
                let dataArray = reportqueryData["data"] as! NSArray
                let hasNextPage = reportqueryData["hasNextPage"] as! Bool
                if hasNextPage {
                    self.KnowledgepageQueryView.mj_footer.endRefreshing()
                } else {
                    self.KnowledgepageQueryView.mj_footer.endRefreshingWithNoMoreData()
                }
                if self.pageNumber == 1 {
                    self.KnowledgepageQueryArray.removeAll()
                }
                for p in dataArray {
                    let dic = p as! [String:Any]
                    self.KnowledgepageQueryArray.append(KnowledgepageQueryModel.init(dic: dic))
                }
            } else {
                let msg = success?["msg"] as! String
                self.WaringTost(Title: "", Body: msg)
                self.KnowledgepageQueryView.mj_footer.endRefreshingWithNoMoreData()
            }
            self.KnowledgepageQueryView.reloadData()
            self.KnowledgepageQueryView.mj_header.endRefreshing()
        }) { (error) in
            self.ErrorTost()
            self.KnowledgepageQueryView.mj_header.endRefreshing()
            self.KnowledgepageQueryView.mj_footer.endRefreshingWithNoMoreData()
        }
    }
}
