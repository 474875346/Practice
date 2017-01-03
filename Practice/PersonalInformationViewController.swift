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
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        if !(cell != nil) {
            cell = UITableViewCell.init(style: .default, reuseIdentifier: "cell")
        }
        if indexPath.section == 0 {
            cell?.textLabel?.text = "个人信息"
        } else if indexPath.section == 1{
            cell?.textLabel?.text = "设置"
        }
        cell?.selectionStyle = .none
        return cell!
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.SlideHiend()
    }
}
private extension PersonalInformationViewController {
    func CreatUI() -> Void {
        let PersonalInformationTableView = CreateUI.TableView(self as UITableViewDelegate, dataSource: self as UITableViewDataSource, frame: CGRect(x: 0, y: 0, width: 200, height: SCREEN_HEIGHT), style: .grouped)
        PersonalInformationTableView.sectionHeaderHeight = 20;
        PersonalInformationTableView.separatorStyle = .none;
        self.view.addSubview(PersonalInformationTableView)
    }
}
