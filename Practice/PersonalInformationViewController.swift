//
//  PersonalInformationViewController.swift
//  Practice
//
//  Created by 新龙科技 on 2017/1/3.
//  Copyright © 2017年 新龙科技. All rights reserved.
//

import UIKit
import Kingfisher
import SDWebImage
class PersonalInformationViewController: BaseViewController,UITableViewDelegate,UITableViewDataSource{
    lazy var PersonalInformationTableView:UITableView = {
        let PersonalInformationTableView = CreateUI.TableView(self as UITableViewDelegate, dataSource: self as UITableViewDataSource, frame: CGRect(x: 0, y: 0, width: 200, height: SCREEN_HEIGHT), style: .plain)
        PersonalInformationTableView.backgroundColor = RGBA(255, g: 255, b: 255, a: 1.0)
        PersonalInformationTableView.separatorStyle = .none;
        return PersonalInformationTableView
    }()
    var StudentInfoModel:[PersonalModel] = [PersonalModel]()
    let titleArray = ["15732157899","清除缓存","修改密码","退出登录"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.StudentInfoData()
        self.view.addSubview(self.PersonalInformationTableView)
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return titleArray.count
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = Bundle.main.loadNibNamed("PersonalInformationTableViewCell", owner: nil, options: nil)?[0] as! PersonalInformationTableViewCell?
            if self.StudentInfoModel.count > 0 {
                let infoModel = self.StudentInfoModel[0]
                cell?.Personaltitle.text = infoModel.name
                if infoModel.studentHeads.count == 0 {
                    cell?.Personalimg.image = UIImage(named: "tab_home_blue")
                }
                for header in infoModel.studentHeads {
                    let head = header as! [String:Any]
                    let headmodel = PersonalHeader.init(dic: head)
                    let url = URL(string: headmodel.large)!
                    cell?.Personalimg.sd_setImage(with: url, placeholderImage: UIImage(named: "tab_home_blue"))
                }
                LRViewBorderRadius((cell?.Personalimg)!, Radius: 30, Width: 0, Color: UIColor.clear)
            }
            cell?.selectionStyle = .none
            return cell!
        } else {
            var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
            if !(cell != nil) {
                cell = UITableViewCell.init(style: .default, reuseIdentifier: "cell")
            }
            if indexPath.row == 0 {
                if self.StudentInfoModel.count > 0 {
                    let infoModel = self.StudentInfoModel[0]
                    cell?.textLabel?.text = infoModel.phone
                }
            } else {
                cell?.textLabel?.text = titleArray[indexPath.row]
            }
            cell?.selectionStyle = .none
            return cell!
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 80
        }
        return 44
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            let personal = PersonalViewController()
            personal.modalTransitionStyle = UIModalTransitionStyle(rawValue: 2)!
            personal.StudentInfoModel = self.StudentInfoModel
            self.present(personal, animated: true, completion: nil)
            break
        default:
            switch indexPath.row {
            case 1:
                self.Cache()
                break
            case 2:
                let ChangePsw = ChangePswViewController()
                ChangePsw.modalTransitionStyle = UIModalTransitionStyle(rawValue: 2)!
                self.present(ChangePswViewController(), animated: true, completion: nil)
                break
            case 3:
                self.LogInOut()
                break
            default:
                break
            }
            break
        }
        self.SlideHiend()
    }
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0
        }
        return 20
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 20))
        header.backgroundColor = RGBA(247, g: 247, b: 247, a: 1.0)
        return header
    }
}
private extension PersonalInformationViewController {
    //MARK:学员信息请求
    func StudentInfoData() -> Void {
        HttpRequestTool.sharedInstance.HttpRequestJSONDataWithUrl(url: Student_info, type: .POST, parameters: ["app_token":UserDefauTake(ZToken)!,"client":deviceUUID!], SafetyCertification: true, successed: { (success) in
            let status = success?["status"] as! Int
            if status == 200 {
                let data = success?["data"] as! [String:Any]
                self.StudentInfoModel.append(PersonalModel.init(dic: data))
            } else {
                let msg = success?["msg"] as! String
                self.WaringTost(Title: "", Body: msg)
            }
            self.PersonalInformationTableView.reloadData()
        }) { (error) in
            self.ErrorTost()
        }
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
