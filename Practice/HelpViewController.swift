//
//  HelpViewController.swift
//  Practice
//
//  Created by 新龙科技 on 2017/2/16.
//  Copyright © 2017年 新龙科技. All rights reserved.
//

import UIKit

class HelpViewController: BaseViewController,BMKMapViewDelegate,BMKGeoCodeSearchDelegate {
    var name:String?
    var phone:String?
    var longitude:String?
    var latitude:String?
    //反地理编码
     var searcher = BMKGeoCodeSearch()
    //标注中心
      let annotation = BMKPointAnnotation()
    //地图
    var mapView = BMKMapView()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addNavBackImg()
        self.addBackButton()
        self.addNavTitle(Title: "呼救人员详情")
        self.createUI()
    }
}
extension HelpViewController {
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
    func mapView(_ mapView: BMKMapView!, viewFor annotation: BMKAnnotation!) -> BMKAnnotationView! {
        if annotation.isKind(of: BMKPointAnnotation.self as AnyClass) {
            let newAnnotationView = BMKPinAnnotationView(annotation: annotation, reuseIdentifier: "myAnnotation")
            newAnnotationView?.pinColor = UInt(BMKPinAnnotationColorPurple)
            newAnnotationView?.animatesDrop = true// 设置该标注点动画显示
            return newAnnotationView
        }
        return nil
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        var coor = CLLocationCoordinate2D()
        coor.latitude = Double(latitude!)!
        coor.longitude = Double(longitude!)!
        annotation.coordinate = coor
        mapView.addAnnotation(annotation)
        let center = CLLocationCoordinate2DMake(Double(latitude!)!, Double(longitude!)!);
        let span = BMKCoordinateSpanMake(0.038325, 0.028045);
        mapView.limitMapRegion = BMKCoordinateRegionMake(center, span)
        mapView.isRotateEnabled = false
        let reverseGeoCodeSearchOption = BMKReverseGeoCodeOption()
        reverseGeoCodeSearchOption.reverseGeoPoint = coor
        searcher.delegate = self
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
            let Positioning = result.address
            annotation.title = Positioning
        } else {
            print("抱歉，未找到结果")
        }
    }
}
private extension HelpViewController {
    func createUI() -> Void {
        let title = UILabel(frame: CGRect(x: 20, y: 66, width: 55, height: 35))
        title.text = "姓名："
        self.view.addSubview(title)
        let namelabel = UILabel(frame: CGRect(x: XW(title)+5, y: 66, width: SCREEN_WIDTH-XW(title)-5, height: 35))
        namelabel.text = name
        self.view.addSubview(namelabel)
        let line = UILabel(frame: CGRect(x: 0, y: YH(namelabel), width: SCREEN_WIDTH, height: 1))
        line.backgroundColor = UIColor.lightGray
        self.view.addSubview(line)
        let phoneLabel = UILabel(frame: CGRect(x: 20, y: YH(namelabel), width: 55, height: 35))
        phoneLabel.text = "电话："
        self.view.addSubview(phoneLabel)
        let button = CreateUI.Button(phone!, action: #selector((self.ClickBtn)), sender: self, frame: CGRect(x: XW(phoneLabel), y: YH(namelabel), width: 100, height: 35), backgroundColor: UIColor.clear, textColor: UIColor.blue)
        self.view.addSubview(button)
        let line1 = UILabel(frame: CGRect(x: 0, y: YH(button), width: SCREEN_WIDTH, height: 1))
        line1.backgroundColor = UIColor.lightGray
        self.view.addSubview(line1)
        //MARK:地图
        mapView.frame = CGRect(x: 20, y: YH(button)+50, width: SCREEN_WIDTH-40, height: SCREEN_WIDTH/2)
        self.view.addSubview(mapView)

    }
    @objc func ClickBtn() -> Void {
        UIApplication.shared.openURL(URL(string: "telprompt://\(phone!)")!)
    }
}
