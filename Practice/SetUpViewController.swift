//
//  SetUpViewController.swift
//  Practice
//
//  Created by 新龙科技 on 2017/1/4.
//  Copyright © 2017年 新龙科技. All rights reserved.
//

import UIKit

class SetUpViewController: BaseViewController,UITableViewDelegate,UITableViewDataSource {
    lazy var PersonalInformationTableView = UITableView()
    let titleArray = [["缓存清理","修改密码"],["退出登录"]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addNavBackImg()
        self.addNavTitle(Title: "设置")
        self.addBackButton()
        self.CreatUI()
    }
    override func BackButton() {
        self.dismiss(animated: true, completion: nil)
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titleArray[section].count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        if !(cell != nil) {
            cell = UITableViewCell.init(style: .value1, reuseIdentifier: "cell")
        }
        cell?.textLabel?.text = titleArray[indexPath.section][indexPath.row]
        if indexPath.section == 0 && indexPath.row == 0 {
            cell?.detailTextLabel?.text = self.CacheString()
        }
        cell?.selectionStyle = .none
        return cell!
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0:
                self.Cache()
                break
            default:
                self.present(ChangePswViewController(), animated: true, completion: nil)
                break
            }
        default:
            self.LogInOut()
            break
        }
    }
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0
        }
        return 20
    }
}
private extension SetUpViewController {
    func CreatUI() -> Void {
        self.PersonalInformationTableView = CreateUI.TableView(self as UITableViewDelegate, dataSource: self as UITableViewDataSource, frame: CGRect(x: 0, y: 64, width: SCREEN_WIDTH, height: SCREEN_HEIGHT-64), style: .plain)
        PersonalInformationTableView.separatorStyle = .none;
        self.view.addSubview(PersonalInformationTableView)
    }
    //MARK:缓存字符串
    func CacheString() -> String {
        // 取出cache文件夹路径
        let cachePath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.libraryDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).first
        // 取出文件夹下所有文件数组
        let files = FileManager.default.subpaths(atPath: cachePath!)
        // 用于统计文件夹内所有文件大小
        var big = Int();
        
        // 快速枚举取出所有文件名
        for p in files!{
            // 把文件名拼接到路径中
            let path = cachePath!.appendingFormat("/\(p)")
            // 取出文件属性
            let floder = try! FileManager.default.attributesOfItem(atPath: path)
            // 用元组取出文件大小属性
            for (abc,bcd) in floder {
                // 只去出文件大小进行拼接
                if abc == FileAttributeKey.size{
                    big += (bcd as AnyObject).integerValue
                }
            }
        }
        let message = "\(big/(1024*1024))M"
        return message
    }
    //MARK:缓存清理
    func  Cache() -> Void {
        // 取出cache文件夹路径
        let cachePath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.libraryDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).first
        // 取出文件夹下所有文件数组
        let files = FileManager.default.subpaths(atPath: cachePath!)
        // 用于统计文件夹内所有文件大小
        var big = Int();
        
        // 快速枚举取出所有文件名
        for p in files!{
            // 把文件名拼接到路径中
            let path = cachePath!.appendingFormat("/\(p)")
            // 取出文件属性
            let floder = try! FileManager.default.attributesOfItem(atPath: path)
            // 用元组取出文件大小属性
            for (abc,bcd) in floder {
                // 只去出文件大小进行拼接
                if abc == FileAttributeKey.size{
                    big += (bcd as AnyObject).integerValue
                }
            }
        }
        let message = "\(big/(1024*1024))M"
        let alert = UIAlertController(title: "清除缓存", message: message, preferredStyle: UIAlertControllerStyle.alert)
        let alertConfirm = UIAlertAction(title: "确定", style: UIAlertActionStyle.default) { (alertConfirm) -> Void in
            // 点击确定时开始删除
            for p in files!{
                let pathstring = p as NSString
                if !pathstring.isEqual(to: "Preferences") && !pathstring.isEqual(to: "Preferences/zyx.Practice.plist"){
                    // 拼接路径
                    let path = cachePath!.appendingFormat("/\(p)")
                    // 判断是否可以删除
                    if(FileManager.default.fileExists(atPath: path)){
                        // 删除
                        try! FileManager.default.removeItem(atPath: path)
                    }
                }
            }
            self.PersonalInformationTableView.reloadData()
        }
        alert.addAction(alertConfirm)
        let cancle = UIAlertAction(title: "取消", style: UIAlertActionStyle.cancel) { (cancle) -> Void in
        }
        alert.addAction(cancle)
        // 提示框弹出
        present(alert, animated: true) { () -> Void in
        }
    }
    //MARK:退出登录
    func LogInOut() -> Void {
        HttpRequestTool.sharedInstance.HttpRequestJSONDataWithUrl(url: Student_loginOut, type: .POST, parameters: ["app_token":UserDefauTake(ZToken)!,"client":deviceUUID!], SafetyCertification: true, successed: { (success) in
            let status = success?["status"] as! Int
            if status == 200 {
                self.SuccessTost(Title: "", Body: "退出登录成功")
                UserDefaultRemove(ZToken)
                UserDefaultRemove(ZCollegeName)
                self.present(ViewController(), animated: true, completion: nil)
            } else {
                let msg = success?["msg"] as! String
                self.WaringTost(Title: "", Body: msg)
            }
        }) { (error) in
            self.ErrorTost()
        }
    }
}
