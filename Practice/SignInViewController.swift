//
//  SignInViewController.swift
//  Practice
//
//  Created by 新龙科技 on 2017/1/6.
//  Copyright © 2017年 新龙科技. All rights reserved.
//

import UIKit

class SignInViewController: BaseViewController,BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate,BMKMapViewDelegate {
    var Positioning = "正在定位中..."
    lazy var SignInScrollView:UIScrollView = {
        let scrollview = UIScrollView(frame: CGRect(x: 0, y: 64, width: SCREEN_WIDTH, height: SCREEN_HEIGHT-64))
        self.view.addSubview(scrollview)
        return scrollview
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
        self.addNavBackImg()
        self.addNavTitle(Title: "签到")
        self.addBackButton()
        self.CreatUI()
        self.LocService()
        self.validSign()
    }
    override func BackButton() {
        self.dismiss(animated: true, completion: nil)
    }
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
            let view = self.SignInScrollView.viewWithTag(100) as! LineAndLabel
            view.label?.text = Positioning
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
private extension SignInViewController {
    func CreatUI() -> Void {
        print(CurrentDate())
        let Timeview = LineAndLabel.init(frame: CGRect(x: 0, y: 20, width: SCREEN_WIDTH, height: 35), title:CurrentDate())
        self.SignInScrollView.addSubview(Timeview)
        let Positioningview = LineAndLabel.init(frame: CGRect(x: 0, y: YH(Timeview)+20, width: SCREEN_WIDTH, height: 35), title:Positioning)
        Positioningview.tag = 100
        self.SignInScrollView.addSubview(Positioningview)
        //MARK:地图
        mapView.frame = CGRect(x: 20, y: YH(Positioningview)+20, width: SCREEN_WIDTH-40, height: 200)
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
        LRViewBorderRadius(textview, Radius: 0, Width: 0.5, Color: UIColor.black)
        self.SignInScrollView.addSubview(textview)
        SignInbutton.backgroundColor = RGBA(76, g: 171, b: 253, a: 1.0)
        SignInbutton.frame = CGRect(x: SCREEN_WIDTH/2-60, y: YH(note)+20, width: 120, height: 120)
        SignInbutton.addTarget(self, action: #selector((self.signin)), for: .touchUpInside)
        LRViewBorderRadius(SignInbutton, Radius: 60, Width: 0, Color: UIColor.clear)
        self.SignInScrollView.addSubview(SignInbutton)
    }
    //MARK:签到方法
    @objc func signin() -> Void {
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
        self.SignInScrollView.contentSize = CGSize(width: 0, height: YH(SignInbutton)+30)
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
