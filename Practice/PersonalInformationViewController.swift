//
//  PersonalInformationViewController.swift
//  Practice
//
//  Created by 新龙科技 on 2017/1/3.
//  Copyright © 2017年 新龙科技. All rights reserved.
//

import UIKit

class PersonalInformationViewController: BaseViewController,UITableViewDelegate,UITableViewDataSource{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.CreatUI()
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
            cell?.Personalimg?.backgroundColor = UIColor.red
            LRViewBorderRadius((cell?.Personalimg)!, Radius: 30, Width: 0, Color: UIColor.clear)
            cell?.Personaltitle.text = "sss"
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
    func CreatUI() -> Void {
        let PersonalInformationTableView = CreateUI.TableView(self as UITableViewDelegate, dataSource: self as UITableViewDataSource, frame: CGRect(x: 0, y: 0, width: 200, height: SCREEN_HEIGHT), style: .plain)
        PersonalInformationTableView.backgroundColor = RGBA(247, g: 247, b: 247, a: 1.0)
        PersonalInformationTableView.separatorStyle = .none;
        self.view.addSubview(PersonalInformationTableView)
    }
}
