//
//  MonthlyRecordViewController.swift
//  Practice
//
//  Created by 新龙科技 on 2017/1/6.
//  Copyright © 2017年 新龙科技. All rights reserved.
//

import UIKit
import MJRefresh
class MonthlyRecordViewController: BaseViewController,UITableViewDelegate,UITableViewDataSource{
    var pageNumber = 1
    var reportqueryArray = [MonthlyRecordModel]()
    var Lastcell = MonthlyRecordTableViewCell()
    
    lazy var MonthlyRecordtableView:UITableView = {
        let tableview = UITableView(frame: CGRect(x: 0, y: 64, width: SCREEN_WIDTH, height: SCREEN_HEIGHT-64), style: .plain)
        tableview.delegate = self
        tableview.dataSource = self
        tableview.separatorStyle = .none
        tableview.mj_header = MJRefreshNormalHeader(refreshingBlock: {
            self.pageNumber = 1
            self.reportquery()
        })
        tableview.mj_footer = MJRefreshAutoNormalFooter(refreshingBlock: {
            self.pageNumber += 1
            self.reportquery()
        })
        self.view.addSubview(tableview)
        return tableview
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addNavBackImg()
        self.addNavTitle(Title: "月报记录")
        self.addBackButton()
        self.reportquery()
    }
}
extension MonthlyRecordViewController {
    //MARK:重写返回方法
    override func BackButton() {
        self.dismiss(animated: true, completion: nil)
    }
    //MARK:返回行数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reportqueryArray.count
    }
    //MARK:表格布局
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("MonthlyRecordTableViewCell", owner: nil, options: nil)?.first as! MonthlyRecordTableViewCell?
        let model = reportqueryArray[indexPath.row]
        cell?.timeLabel.text = model.createTime
        cell?.contentLabel.text = model.plan
        cell?.selectionStyle = .none
        return cell!
    }
    //MARK:返回行高
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let model = reportqueryArray[indexPath.row]
        let size = getAttributeSize(text: model.plan as NSString, fontSize: 21)
        return size.height+50
    }
    //MARK:表格点击方法
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = reportqueryArray[indexPath.row]
        let  MonthlyReportDetails =  MonthlyReportDetailsViewController()
        MonthlyReportDetails.modelArray = [model]
        self.present( MonthlyReportDetails, animated: true, completion: nil)
    }
}
private extension MonthlyRecordViewController {
    //MARK:月报记录列表
    func reportquery() -> Void {
        HttpRequestTool.sharedInstance.HttpRequestJSONDataWithUrl(url: Student_reportquery, type: .POST, parameters: ["app_token":UserDefauTake(ZToken)!,"pageNumber":"\(pageNumber)","client":deviceUUID!], SafetyCertification: true, successed: { (success) in
            let status = success?["status"] as! Int
            if status == 200 {
                let reportqueryData = success?["data"] as! NSDictionary
                let dataArray = reportqueryData["data"] as! NSArray
                let hasNextPage = reportqueryData["hasNextPage"] as! Bool
                if hasNextPage {
                    self.MonthlyRecordtableView.mj_footer.endRefreshing()
                } else {
                    self.MonthlyRecordtableView.mj_footer.endRefreshingWithNoMoreData()
                }
                if self.pageNumber == 1 {
                    self.reportqueryArray.removeAll()
                }
                for p in dataArray {
                    let dic = p as! [String:Any]
                    self.reportqueryArray.append(MonthlyRecordModel.init(dic: dic))
                }
            } else {
                let msg = success?["msg"] as! String
                self.WaringTost(Title:"", Body: msg)
                self.MonthlyRecordtableView.mj_footer.endRefreshingWithNoMoreData()
            }
            self.MonthlyRecordtableView.reloadData()
            self.MonthlyRecordtableView.mj_header.endRefreshing()
        }) { (error) in
            self.ErrorTost()
            self.MonthlyRecordtableView.mj_header.endRefreshing()
            self.MonthlyRecordtableView.mj_footer.endRefreshingWithNoMoreData()
        }
    }
}
