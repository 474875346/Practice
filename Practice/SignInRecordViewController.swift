//
//  SignInRecordViewController.swift
//  Practice
//
//  Created by 新龙科技 on 2017/1/6.
//  Copyright © 2017年 新龙科技. All rights reserved.
//

import UIKit
import MJRefresh
class SignInRecordViewController: BaseViewController,UITableViewDelegate,UITableViewDataSource {
    var pageNumber = 1
    var SignInRecordArray:[SignInRecordModel] = [SignInRecordModel]()
    
    lazy var SignInRecordtableView:UITableView = {
        let tableview = UITableView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT-108), style: .plain)
        tableview.delegate = self
        tableview.dataSource = self
        tableview.rowHeight = 60
        tableview.separatorStyle = .none
        tableview.backgroundColor = UIColor.lightGray
        tableview.mj_header = MJRefreshNormalHeader(refreshingBlock: {
            self.pageNumber = 1
            self.signRecordData()
        })
        tableview.mj_footer = MJRefreshAutoNormalFooter(refreshingBlock: {
            self.pageNumber += 1
            self.signRecordData()
        })
        self.view.addSubview(tableview)
        return tableview
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.signRecordData()
    }
}
extension SignInRecordViewController {
    //MARK:返回行数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SignInRecordArray.count
    }
    //MARK:表格布局
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("SignInRecordTableViewCell", owner: nil, options: nil)?.first as! SignInRecordTableViewCell?
        let model = SignInRecordArray[indexPath.row]
        cell?.date.text = model.createTime
        cell?.address.text = model.location?.positionDescn
        return cell!
    }
}
private extension SignInRecordViewController {
    //MARK:签到记录
    func signRecordData() -> Void {
        HttpRequestTool.sharedInstance.HttpRequestJSONDataWithUrl(url: Student_signRecord, type: .POST, parameters: ["app_token":UserDefauTake(ZToken)!,"client":deviceUUID!,"pageNumber":"\(pageNumber)"], SafetyCertification: true, successed: { (success) in
            let status = success?["status"] as! Int
            if status == 200 {
                let SignInRecordData = success?["data"] as! NSDictionary
                let hasNextPage = SignInRecordData["hasNextPage"] as! Bool
                if hasNextPage {
                    self.SignInRecordtableView.mj_footer.endRefreshing()
                } else {
                    self.SignInRecordtableView.mj_footer.endRefreshingWithNoMoreData()
                }
                let dataArray = SignInRecordData["data"] as! NSArray
                if (self.pageNumber == 1) {
                    self.SignInRecordArray.removeAll()
                }
                for p in dataArray {
                    let dic = p as! [String:Any]
                    self.SignInRecordArray.append(SignInRecordModel.init(dic: dic))
                }
                self.SignInRecordtableView.reloadData()
            } else {
                let msg = success?["msg"] as! String
                self.WaringTost(Title:"", Body: msg)
            }
        }) { (error) in
            self.ErrorTost()
        }
        self.SignInRecordtableView.mj_header.endRefreshing()
        
    }
}
