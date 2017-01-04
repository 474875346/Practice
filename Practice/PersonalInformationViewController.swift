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
        PersonalInformationTableView.backgroundColor = RGBA(247, g: 247, b: 247, a: 1.0)
        PersonalInformationTableView.separatorStyle = .none;
        self.view.addSubview(PersonalInformationTableView)
        return PersonalInformationTableView
    }()
    var StudentInfoModel:[PersonalModel] = [PersonalModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.StudentInfoData()
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = Bundle.main.loadNibNamed("PersonalInformationTableViewCell", owner: nil, options: nil)?[0] as! PersonalInformationTableViewCell?
            if self.StudentInfoModel.count > 0 {
                let infoModel = self.StudentInfoModel[0]
                cell?.Personaltitle.text = infoModel.name
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
            cell?.textLabel?.text = "设置"
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
            let Setup = SetUpViewController()
            Setup.modalTransitionStyle = UIModalTransitionStyle(rawValue: 2)!
            self.present(Setup, animated: true, completion: nil)
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
}
