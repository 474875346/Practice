//
//  MessageViewController.swift
//  Practice
//
//  Created by 新龙科技 on 2017/1/3.
//  Copyright © 2017年 新龙科技. All rights reserved.
//

import UIKit
import MJRefresh
class MessageViewController: BaseViewController,UITableViewDataSource,UITableViewDelegate {
    var pageNum = 1
    lazy var MessageTableView:UITableView = {
      let  MessageTableView = CreateUI.TableView(self as UITableViewDelegate, dataSource: self as UITableViewDataSource, frame: CGRect(x: 0, y: 64, width: SCREEN_WIDTH, height: SCREEN_HEIGHT-108), style: .plain)
        MessageTableView.separatorStyle = .none;
        MessageTableView.mj_header = MJRefreshNormalHeader(refreshingBlock: {
            self.pageNum = 1
            self.MessageData()
        })
        MessageTableView.mj_footer = MJRefreshAutoNormalFooter(refreshingBlock: {
            self.pageNum += 1
            self.MessageData()
        })
        self.view.addSubview(MessageTableView)
        return MessageTableView
    }()
    var MessageDataArray:[MessageModel] = [MessageModel]()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addNavBackImg()
        self.addNavTitle(Title: "消息")
        self.MessageData()
        self.MessageTableView.mj_header.beginRefreshing()
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.MessageDataArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        if !(cell != nil) {
          cell = UITableViewCell.init(style:.subtitle, reuseIdentifier: "cell")
        }
        let messagemodel = self.MessageDataArray[indexPath.row]
        cell?.detailTextLabel?.text = messagemodel.createTime
        cell?.textLabel?.text = messagemodel.notice["title"]
        cell?.textLabel?.font = UIFont.systemFont(ofSize: 15)
        return cell!
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let messagemodel = self.MessageDataArray[indexPath.row]
        let Details = MessageForDetailsViewController()
        Details.MessageURL = messagemodel.notice["url"]!
        self.navigationController?.pushViewController(Details, animated: true)
    }
}
private extension MessageViewController {
    //MARK:消息请求
    func MessageData() -> Void {
        HttpRequestTool.sharedInstance.HttpRequestJSONDataWithUrl(url: Student_pageQuery, type: .POST, parameters: ["app_token":UserDefauTake(ZToken)!,"client":deviceUUID!,"pageNumber": "\(pageNum)","pageSize":"5"],SafetyCertification: true, successed: { (success) in
            let status = success?["status"] as! Int
            if status == 200 {
                let DataDic = success?["data"] as! NSDictionary
                let Datadic = DataDic["data"] as! NSDictionary
                let hasNextPage = Datadic["hasNextPage"] as! Bool
                if hasNextPage == false {
                    self.MessageTableView.mj_footer.endRefreshingWithNoMoreData()
                }
                let DataArray = Datadic["data"] as! NSArray
                if self.pageNum == 1 {
                    self.MessageDataArray.removeAll()
                }
                for dic in DataArray {
                    self.MessageDataArray.append(MessageModel(dic: dic as! [String : Any]))
                }
                self.MessageTableView.reloadData()
                 self.MessageTableView.mj_header.endRefreshing()
            } else {
                let msg = success?["msg"] as! String
                self.WaringTost(Title: "", Body: msg)
            }
        }) { (error) in
            self.ErrorTost()
        }
        self.MessageTableView.mj_footer.endRefreshing()
    }
}
