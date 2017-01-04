//
//  PersonalViewController.swift
//  Practice
//
//  Created by 新龙科技 on 2017/1/4.
//  Copyright © 2017年 新龙科技. All rights reserved.
//

import UIKit

class PersonalViewController: BaseViewController,UITableViewDelegate,UITableViewDataSource {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.addNavBackImg()
        self.addNavTitle(Title: "个人信息")
        self.addBackButton()
        self.CreatUI()
    }
    //MARK:重写返回方法
    override func BackButton() {
        self.dismiss(animated: true, completion: nil)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        if !(cell != nil) {
            cell = UITableViewCell.init(style: .default, reuseIdentifier: "cell")
        }
        cell?.textLabel?.text = "设置"
        cell?.selectionStyle = .none
        return cell!
    }
}
private extension PersonalViewController {
    //MARK:布局
    func CreatUI() -> Void {
        let PersonalInformationTableView = CreateUI.TableView(self as UITableViewDelegate, dataSource: self as UITableViewDataSource, frame: CGRect(x: 0, y: 64, width: SCREEN_WIDTH, height: SCREEN_HEIGHT-64), style: .plain)
        PersonalInformationTableView.separatorStyle = .none;
        self.view.addSubview(PersonalInformationTableView)
    }

}
