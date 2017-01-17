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
        MessageTableView.separatorStyle = .none
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
        self.addSlide()
    }
}
extension MessageViewController {
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.MessageData()
        self.Unread()
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
            let label = CreateUI.Label(UIColor.clear, backgroundColor: UIColor.red, title: "", frame: CGRect(x: SCREEN_WIDTH-20, y: 22, width: 10, height: 10), font: 0)
            LRViewBorderRadius(label, Radius: 5, Width: 0, Color: UIColor.clear)
            label.isHidden = true
            label.tag = indexPath.row+1
            cell?.addSubview(label)
            let line = CreateUI.Label(UIColor.clear, backgroundColor: UIColor.lightGray, title: "", frame: CGRect(x: 0, y: 43, width: SCREEN_WIDTH, height: 1), font: 0)
            cell?.addSubview(line)
        }
        let messagemodel = self.MessageDataArray[indexPath.row]
        if messagemodel.status.isEqual(to: "N") {
            let label = cell?.viewWithTag(indexPath.row+1)
            label?.isHidden = false
        } else if messagemodel.status.isEqual(to: "Y") {
            let label = cell?.viewWithTag(indexPath.row+1)
            label?.isHidden = true
        }
        cell?.detailTextLabel?.text = messagemodel.createTime
        cell?.textLabel?.text = messagemodel.notice["title"]
        cell?.textLabel?.font = UIFont.systemFont(ofSize: 15)
        return cell!
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell  = tableView.cellForRow(at: indexPath)
        let messagemodel = self.MessageDataArray[indexPath.row]
        let Details = MessageForDetailsViewController()
        cell?.heroID = messagemodel.notice["url"]!
        Details.MessageURL = messagemodel.notice["url"]!
        self.navigationController?.pushViewController(Details, animated: true)
    }
    
}
private extension MessageViewController {
    //MARK:消息请求
    func MessageData() -> Void {
        HttpRequestTool.sharedInstance.HttpRequestJSONDataWithUrl(url: Student_pageQuery, type: .POST, parameters: ["app_token":UserDefauTake(ZToken)!,"client":deviceUUID!,"pageNumber": "\(pageNum)"],SafetyCertification: true, successed: { (success) in
            let status = success?["status"] as! Int
            if status == 200 {
                let DataDic = success?["data"] as! NSDictionary
                let rows = DataDic["rows"] as! Int
                if rows == 0 {
                    UIApplication.shared.applicationIconBadgeNumber = 0
                }
                let Datadic = DataDic["data"] as! NSDictionary
                let hasNextPage = Datadic["hasNextPage"] as! Bool
                if hasNextPage == false {
                    self.MessageTableView.mj_footer.endRefreshingWithNoMoreData()
                } else {
                    self.MessageTableView.mj_footer.endRefreshing()
                }
                let DataArray = Datadic["data"] as! NSArray
                if self.pageNum == 1 {
                    self.MessageDataArray.removeAll()
                }
                for dic in DataArray {
                    self.MessageDataArray.append(MessageModel(dic: dic as! [String : Any]))
                }
                self.MessageTableView.reloadData()
            } else {
                let msg = success?["msg"] as! String
                self.WaringTost(Title: "", Body: msg)
                self.MessageTableView.mj_footer.endRefreshingWithNoMoreData()
            }
            self.MessageTableView.mj_header.endRefreshing()
        }) { (error) in
            self.ErrorTost()
            self.MessageTableView.mj_header.endRefreshing()
            self.MessageTableView.mj_footer.endRefreshingWithNoMoreData()
        }
    }
    //MARK:获取个数
    func Unread() -> Void {
        HttpRequestTool.sharedInstance.HttpRequestJSONDataWithUrl(url: Student_unread, type: .POST, parameters: ["app_token":UserDefauTake(ZToken)!,"client":deviceUUID!], SafetyCertification: true, successed: { (success) in
            let status = success?["status"] as! Int
            if status == 200 {
                let delegate = UIApplication.shared.delegate as! AppDelegate
                let badgeValue = success?["data"] as! Int
                let items = delegate.tabbar.tabBar.items?[1]
                if badgeValue == 0 {
                    items?.badgeValue = nil
                } else {
                    items?.badgeValue = "\(badgeValue)"
                    UIApplication.shared.applicationIconBadgeNumber = badgeValue
                }
            }
        }) { (error) in
        }
    }
}
