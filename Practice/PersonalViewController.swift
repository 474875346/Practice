//
//  PersonalViewController.swift
//  Practice
//
//  Created by 新龙科技 on 2017/1/4.
//  Copyright © 2017年 新龙科技. All rights reserved.
//

import UIKit
import SDWebImage
class PersonalViewController: BaseViewController,UITableViewDelegate,UITableViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    var StudentInfoModel:[PersonalModel] = [PersonalModel]()
    //id
    var id = ""
    //学生电话
    var phone = ""
    //昵称
    var name = ""
    //性别
    var sex = ""
    //校外住址
    var address = ""
    //紧急联系方式
    var emergencyContact = ""
    //实习单位
    var unit = ""
    //实习岗位
    var post = ""
    //岗位老师姓名
    var teacherName = ""
    //岗位老师电话
    var teacherContact = ""
    //头像地址
    var headerURL = ""
    var headerImg = UIImage()
    var isHeader = false
    
    var contentArray = [String]()
    lazy var PersonalInformationTableView:UITableView={
        let PersonalInformationTableView = CreateUI.TableView(self as UITableViewDelegate, dataSource: self as UITableViewDataSource, frame: CGRect(x: 0, y: 64, width: SCREEN_WIDTH, height: SCREEN_HEIGHT-64), style: .plain)
        PersonalInformationTableView.separatorStyle = .none
        PersonalInformationTableView.bounces = false
        return PersonalInformationTableView
    }()
    let titleArray = ["昵称", "性别", "校外住址","紧急联系方式", "实习单位", "实习岗位","岗位老师姓名", "岗位老师电话"]
    var  Personalcallback:(()->Void)?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addNavBackImg()
        self.addNavTitle(Title: "个人信息")
        self.addBackButton()
        self.TheAssignment()
        self.CreatUI()
    }
    //MARK:重写返回方法
    override func BackButton() {
        self.dismiss(animated: true, completion: nil)
        Personalcallback!()
    }
    //MARK:表格区
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    //MARK:表格行
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        return titleArray.count
    }
    //MARK:表格行高
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 80
        }
        return 44
    }
    //MARK:表格布局
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = Bundle.main.loadNibNamed("PersonalTableViewCell", owner: nil, options: nil)?.first as! PersonalTableViewCell?
            if isHeader {
                cell?.HeaderImg.image = headerImg
            } else {
                let url = URL(string: headerURL)
                cell?.HeaderImg?.sd_setImage(with: url, placeholderImage: UIImage(named: "tab_home_blue"))
            }
            LRViewBorderRadius((cell?.HeaderImg)!, Radius: 30, Width: 0, Color: UIColor.clear)
            cell?.selectionStyle = .none
            return cell!
        }
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        if !(cell != nil) {
            cell = UITableViewCell.init(style: .subtitle, reuseIdentifier: "cell")
        }
        cell?.textLabel?.text = titleArray[indexPath.row]
        cell?.detailTextLabel?.text = contentArray[indexPath.row]
        cell?.detailTextLabel?.textColor = UIColor.lightGray
        cell?.selectionStyle = .none
        return cell!
    }
    //MARK:表格点击
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            let  actionSheet = UIAlertController(title: "请选择相机还是相册", message: "", preferredStyle:.actionSheet)
            let cancelAction = UIAlertAction(title: "取消", style: UIAlertActionStyle.cancel, handler: nil)
            let AlbumAction = UIAlertAction(title: "相册", style: UIAlertActionStyle.default) {
                (UIAlertAction) in
                self.openAlbum()
            }
            let CameraAction = UIAlertAction(title: "相机", style: UIAlertActionStyle.default) {
                (UIAlertAction) in
                self.openCamera()
            }
            actionSheet.addAction(cancelAction)
            actionSheet.addAction(AlbumAction)
            actionSheet.addAction(CameraAction)
            // 弹出
            self.present(actionSheet, animated: true, completion: nil)
            break
        default:
            if indexPath.row == 1 {
                let sexAlert = UIAlertController(title: self.titleArray[indexPath.row], message: "", preferredStyle: .alert)
                let action1 = UIAlertAction(title: "男", style: .default, handler: { (action) in
                    self.contentArray[indexPath.row] = "男"
                    self.PersonalInformationTableView.reloadData()
                })
                let action2 = UIAlertAction(title: "女", style: .default, handler: { (action) in
                    self.contentArray[indexPath.row] = "女"
                    self.PersonalInformationTableView.reloadData()
                })
                sexAlert.addAction(action1)
                sexAlert.addAction(action2)
                self.present(sexAlert, animated: true, completion: nil)
            } else {
                let alertController = UIAlertController(title: self.titleArray[indexPath.row], message: "", preferredStyle: UIAlertControllerStyle.alert)
                
                alertController.addTextField { (textField:UITextField) in
                    textField.placeholder = "请输入\(self.titleArray[indexPath.row])"
                }
                let cancelAction = UIAlertAction(title: "取消", style: UIAlertActionStyle.cancel, handler: nil)
                let okAction = UIAlertAction(title: "确定", style: UIAlertActionStyle.default) { (UIAlertAction) in
                    let TF = alertController.textFields![0]
                    self.contentArray[indexPath.row] = TF.text!
                    self.PersonalInformationTableView.reloadData()
                }
                alertController.addAction(cancelAction)
                alertController.addAction(okAction)
                // 弹出
                self.present(alertController, animated: true, completion: nil)
            }
            break
        }
    }
    //MARK:选择图片成功后代理
    func imagePickerController(_ picker:UIImagePickerController, didFinishPickingMediaWithInfo info: [String :Any]) {
        //查看info对象
        print(info)
        //获取选择的原图
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        headerImg = image
        isHeader = true
        self.PersonalInformationTableView.reloadData()
        //上传头像
        self.upLoadHead()
        //图片控制器退出
        picker.dismiss(animated: true, completion: {
            () -> Void in
        })
    }
}
private extension PersonalViewController {
    //MARK:布局
    func CreatUI() -> Void {
        let save = CreateUI.Button("保存", action: #selector((self.SaveButton)), sender: self, frame: CGRect(x: SCREEN_WIDTH-64, y: 20, width: 54, height: 44), backgroundColor: UIColor.clear, textColor: UIColor.white)
        self.view.addSubview(save)
        self.view.addSubview(self.PersonalInformationTableView)
    }
    //MARK:保存修改信息
    @objc func SaveButton() -> Void {
        Personalcallback!()
        self.StudentSaveData()
    }
    //MARK:字符串赋值
    func TheAssignment() -> Void {
        if self.StudentInfoModel.count > 0 {
            let infoModel = self.StudentInfoModel[0]
            id = infoModel.id
            phone = infoModel.phone
            name = infoModel.name
            if infoModel.sex.isEqual(to: "M") {
                sex = "男"
            } else if infoModel.sex.isEqual(to: "F") {
                sex = "女"
            } else {
                sex = ""
            }
            address = infoModel.address;
            emergencyContact = infoModel.emergencyContact;
            unit = infoModel.unit;
            post = infoModel.post;
            teacherName = infoModel.teacherName;
            teacherContact = infoModel.teacherContact;
            for header in infoModel.studentHeads {
                let head = header as! [String:Any]
                let headmodel = PersonalHeader.init(dic: head)
                headerURL = headmodel.large
            }
            let content = [name,sex,address,emergencyContact,unit,post,teacherName,teacherContact]
            contentArray = content
        } else {
            let content = [name,sex,address,emergencyContact,unit,post,teacherName,teacherContact]
            contentArray = content
        }
        self.PersonalInformationTableView.reloadData()
    }
    //MARK:打开相册
    func openAlbum(){
        //判断设置是否支持图片库
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            //初始化图片控制器
            let picker = UIImagePickerController()
            //设置代理
            picker.delegate = self
            //指定图片控制器类型
            picker.sourceType = UIImagePickerControllerSourceType.photoLibrary
            //设置是否允许编辑
            //            picker.allowsEditing = editSwitch.on
            //弹出控制器，显示界面
            self.present(picker, animated: true, completion: {
                () -> Void in
            })
        }else{
            print("读取相册错误")
        }
    }
    //MARK:打开相机
    func openCamera(){
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            
            //创建图片控制器
            let picker = UIImagePickerController()
            //设置代理
            picker.delegate = self
            //设置来源
            picker.sourceType = UIImagePickerControllerSourceType.camera
            //允许编辑
            picker.allowsEditing = true
            //打开相机
            self.present(picker, animated: true, completion: { () -> Void in
                
            })
        }else{
            debugPrint("找不到相机")
        }
    }
    //MARK:上传头像
    func upLoadHead() -> Void {
        HttpRequestTool.sharedInstance.HttpRequestUpload(url:Student_ChangHead , parameters: ["app_token":UserDefauTake(ZToken)!,"client":deviceUUID!], image:headerImg , successed: { (success) in
            let status = success?["status"] as! Int
            if status == 200 {
                self.SuccessTost(Title: "", Body: "上传头像成功")
            } else {
                let msg = success?["msg"] as! String
                self.WaringTost(Title: "", Body: msg)
            }
        }) { (error) in
            self.ErrorTost()
        }
    }
    //MARK:修改学员信息
    func StudentSaveData() -> Void {
        name = contentArray[0]
       let Sex = contentArray[1] as NSString
        if Sex.isEqual(to: "男") {
            sex = "M"
        } else {
            sex = "F"
        }
        address = contentArray[2];
        emergencyContact = contentArray[3];
        unit = contentArray[4];
        post = contentArray[5];
        teacherName = contentArray[6];
        teacherContact = contentArray[7];
        HttpRequestTool.sharedInstance.HttpRequestJSONDataWithUrl(url: Student_save, type: .POST, parameters: ["app_token":UserDefauTake(ZToken)!,"id":id,"name":name,"sex":sex,"address":address,"emergencyContact":emergencyContact,"unit":unit,"post":post,"teacherName":teacherName,"teacherContact":teacherContact,"phone":phone,"client":deviceUUID!], SafetyCertification: true, successed: { (success) in
            let status = success?["status"] as! Int
            if status == 200 {
                self.SuccessTost(Title: "", Body: "修改信息成功")
                self.Personalcallback!()
                self.dismiss(animated: true, completion: nil)
            } else {
                let msg = success?["msg"] as! String
                self.WaringTost(Title: "", Body: msg)
            }
        }) { (error) in
            self.ErrorTost()
        }
    }
}
