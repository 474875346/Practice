//
//  SignInViewController.swift
//  Practice
//
//  Created by 新龙科技 on 2017/1/6.
//  Copyright © 2017年 新龙科技. All rights reserved.
//

import UIKit

class SignInViewController: BaseViewController,BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate,BMKMapViewDelegate,UITextViewDelegate {
    var Positioning = "     正在定位中..."
    lazy var SignInScrollView:UIScrollView = {
        let scrollview = UIScrollView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT-64))
        scrollview.bounces = false
        scrollview.showsVerticalScrollIndicator = false
        self.view.addSubview(scrollview)
        return scrollview
    }()
    lazy var placeHolderLabel:UILabel? = {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH-40, height: 30))
        label.text = " 请输入备注信息"
        label.textColor = UIColor.lightGray
        return label
    }()
    
    let textview = UITextView()
    let SignInbutton = UIButton(type: .custom)
    //定位
    var locService : BMKLocationService?
    //反地理编码
    var searcher = BMKGeoCodeSearch()
    //地图
    var mapView = BMKMapView()
    //纬度
    var latitude = ""
    //经度
    var longitude = ""
    //是否签到
    var isvalidSign : Bool?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.CreatUI()
        self.LocService()
        self.validSign()
    }
}
//MARK:地图代理
extension SignInViewController {
    //MARK:位置更新
    func didUpdate(_ userLocation: BMKUserLocation!) {
        mapView.updateLocationData(userLocation)
        longitude = "\(userLocation.location.coordinate.longitude)"
        latitude = "\(userLocation.location.coordinate.latitude)"
        searcher.delegate = self
        let pt = CLLocationCoordinate2D(latitude: userLocation.location.coordinate.latitude, longitude: userLocation.location.coordinate.longitude)
        let reverseGeoCodeSearchOption = BMKReverseGeoCodeOption()
        reverseGeoCodeSearchOption.reverseGeoPoint = pt
        let flag = searcher.reverseGeoCode(reverseGeoCodeSearchOption)
        if flag {
            print("反geo检索发送成功")
        } else {
            print("反geo检索发送失败")
        }
    }
    //MARK:反地理编码
    func onGetReverseGeoCodeResult(_ searcher: BMKGeoCodeSearch!, result: BMKReverseGeoCodeResult!, errorCode error: BMKSearchErrorCode) {
        if (error == BMK_SEARCH_NO_ERROR) {
            locService?.stopUserLocationService()
            Positioning = result.address
            mapView.userTrackingMode = BMKUserTrackingModeNone
            let label = self.SignInScrollView.viewWithTag(100) as! UILabel
            label.text = "     \(Positioning)"
        } else {
            print("抱歉，未找到结果")
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        mapView.viewWillAppear()
        mapView.delegate = self // 此处记得不用的时候需要置nil，否则影响内存的释放
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        mapView.viewWillDisappear()
        mapView.delegate = nil // 不用时，置nil
    }
}
//MARK:文本的代理
extension SignInViewController {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let Text = text as NSString
        if !Text.isEqual(to: "") {
            if textView.isEqual(textview) {
                self.placeHolderLabel?.isHidden = true
            }
        }
        if Text.isEqual(to: "") && range.length == 1 && range.location == 0 {
            if textView.isEqual(textview) {
                self.placeHolderLabel?.isHidden = false
            }
        }
        return true
    }
    func textViewDidChange(_ textView: UITextView) {
        let text  = textView.text as NSString
        if !text.isEqual(to: "") {
            if textView.isEqual(textview) {
                self.placeHolderLabel?.isHidden = true
            }
        }
    }
}
private extension SignInViewController {
    //MARK:布局
    func CreatUI() -> Void {
        let Timeview = LineAndLabel.init(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 35), title:CurrentDate())
        self.SignInScrollView.addSubview(Timeview)
        let Positioninglabel = UILabel(frame: CGRect(x: 0, y: YH(Timeview)+5, width: SCREEN_WIDTH, height: 35))
        Positioninglabel.text = Positioning
        Positioninglabel.tag = 100
        self.SignInScrollView.addSubview(Positioninglabel)
        //MARK:地图
        mapView.frame = CGRect(x: 20, y: YH(Positioninglabel)+5, width: SCREEN_WIDTH-40, height: 200)
        mapView.showsUserLocation = true
        mapView.userTrackingMode = BMKUserTrackingModeFollow
        mapView.zoomLevel = 18
        mapView.gesturesEnabled = false
        self.SignInScrollView.addSubview(mapView)
        //备注
        let note = CreateUI.Label(UIColor.lightGray, backgroundColor: UIColor.clear, title: "备注", frame: CGRect(x: 20, y: YH(mapView)+20, width: 120, height: 20), font: 17)
        note.tag = 200
        self.SignInScrollView.addSubview(note)
        let noteSwitch = UISwitch(frame: CGRect(x: SCREEN_WIDTH-80, y: YH(mapView)+20, width: 60, height: 30))
        noteSwitch.addTarget(self, action: #selector((self.noteswitch(_:))), for: .valueChanged)
        self.SignInScrollView.addSubview(noteSwitch)
        //备注文本框
        textview.delegate = self
        textview.addSubview(self.placeHolderLabel!)
        LRViewBorderRadius(textview, Radius: 10, Width: 0.5, Color: UIColor.lightGray)
        self.SignInScrollView.addSubview(textview)
        SignInbutton.backgroundColor = RGBA(76, g: 171, b: 253, a: 1.0)
        SignInbutton.frame = CGRect(x: SCREEN_WIDTH/2-60, y: YH(note)+20, width: 120, height: 120)
        SignInbutton.setTitle("签到", for: .normal)
        SignInbutton.addTarget(self, action: #selector((self.signin)), for: .touchUpInside)
        LRViewBorderRadius(SignInbutton, Radius: 60, Width: 0, Color: UIColor.clear)
        self.SignInScrollView.addSubview(SignInbutton)
    }
    //MARK:签到方法
    @objc func signin() -> Void {
        if longitude.isEmpty || latitude.isEmpty {
            self.WaringTost(Title: "", Body: "请打开定位")
            return
        }
        HttpRequestTool.sharedInstance.HttpRequestJSONDataWithUrl(url: Student_signIn, type: .POST, parameters: ["app_token":UserDefauTake(ZToken)!,"client":deviceUUID!,"longitude":longitude,"latitude":latitude,"descn":textview.text,"positionDescn":Positioning], SafetyCertification: true, successed: { (success) in
            let status = success?["status"] as! Int
            if status == 200 {
                self.SuccessTost(Title: "", Body: "签到成功")
                self.dismiss(animated: true, completion: nil)
            } else {
                let msg = success?["msg"] as! String
                self.WaringTost(Title:"", Body: msg)
            }
        }) { (error) in
            self.ErrorTost()
        }
    }
    //MARK:选择开关方法
    @objc func noteswitch(_ view : UISwitch ) -> Void {
        let note = self.SignInScrollView.viewWithTag(200)! as! UILabel
        if view.isOn {
            textview.frame = CGRect(x: 20, y: YH(note)+20, width: SCREEN_WIDTH-40, height: SCREEN_WIDTH/3)
            textview.isHidden = false
            SignInbutton.frame = CGRect(x: SCREEN_WIDTH/2-60, y: YH(textview)+20, width: 120, height: 120)
        } else {
            textview.isHidden = true
            SignInbutton.frame = CGRect(x: SCREEN_WIDTH/2-60, y: YH(note)+20, width: 120, height: 120)
        }
        self.SignInScrollView.contentSize = CGSize(width: 0, height: YH(SignInbutton)+50)
    }
    //MARK:定位
    func LocService() -> Void {
        locService = BMKLocationService()
        locService?.delegate = self
        locService?.startUserLocationService()
    }
    //MARK:是否签过到
    func validSign() -> Void {
        HttpRequestTool.sharedInstance.HttpRequestJSONDataWithUrl(url: Student_validSign, type: .POST, parameters: ["app_token":UserDefauTake(ZToken)!,"client":deviceUUID!], SafetyCertification: true, successed: { (success) in
            let status = success?["status"] as! Int
            if status == 200 {
                self.isvalidSign = success?["data"] as? Bool
                if self.isvalidSign! {
                    self.SignInbutton.setTitle("已签到", for: .normal)
                    self.SignInbutton.isUserInteractionEnabled = false
                } else {
                    self.SignInbutton.setTitle("签到", for: .normal)
                }
            } else {
                let msg = success?["msg"] as! String
                self.WaringTost(Title:"", Body: msg)
            }
        }) { (error) in
            self.ErrorTost()
        }
    }
}
