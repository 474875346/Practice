//
//  AppDelegate.swift
//  Practice
//
//  Created by 新龙科技 on 2016/12/27.
//  Copyright © 2016年 新龙科技. All rights reserved.
//

import UIKit
import SwiftMessages
//import Hero
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,BMKGeneralDelegate,JPUSHRegisterDelegate,BMKLocationServiceDelegate {
    @available(iOS 10.0, *)
    public func jpushNotificationCenter(_ center: UNUserNotificationCenter!, didReceive response: UNNotificationResponse!, withCompletionHandler completionHandler: (() -> Void)!) {
    }
    @available(iOS 10.0, *)
    func jpushNotificationCenter(_ center: UNUserNotificationCenter!, willPresent notification: UNNotification!, withCompletionHandler completionHandler: ((Int) -> Void)!) {
    }
    //定位
    var locService : BMKLocationService?
    //纬度
    var latitude = ""
    //经度
    var longitude = ""
    
    var ocSlide = SwiftSlideRootViewController.init(nil)
    var window: UIWindow?
    let tabbar = UITabBarController()
    var _mapManager : BMKMapManager?
    let isProduction = false
    let channel = "Publish channel"
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        if (UserDefauTake(ZToken) != nil) {
            self.CreatTabbar()
        } else {
            let nav = UINavigationController(rootViewController: ViewController())
            self.window?.rootViewController = nav
        }
        self.BaiDuAPI()
        /// 极光自定义信息
        let defaultCenter = NotificationCenter.default
        defaultCenter.addObserver(self, selector: #selector((self.networkDidReceiveMessage(notification:))), name: NSNotification.Name.jpfNetworkDidReceiveMessage, object: nil)
        //MARK:-极光推送注册
        let entity = JPUSHRegisterEntity()
        entity.types = Int(JPAuthorizationOptions.alert.rawValue) | Int(JPAuthorizationOptions.badge.rawValue) | Int(JPAuthorizationOptions.sound.rawValue);
        JPUSHService.register(forRemoteNotificationConfig: entity, delegate: self)
        JPUSHService.setup(withOption: launchOptions, appKey: "023b08c13c84e501e0165ac2", channel: channel, apsForProduction: isProduction, advertisingIdentifier: nil)
        self.AuroraPushSuccess()
        self.Unread()
        self.LocService()
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
        
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        self.RefreshToken()
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        self.Unread()
        self.RefreshToken()
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        JPUSHService.registerDeviceToken(deviceToken)
    }
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        print("iOS7及以上系统，收到通知:\(userInfo)")
        JPUSHService.handleRemoteNotification(userInfo)
        completionHandler(UIBackgroundFetchResult.newData)
        if UIApplication.shared.applicationState == UIApplicationState.active {
            self.Unread()
        }
    }
    
}
//MARK:-极光推送
extension AppDelegate {
    //MARK:极光自定义消息
    func networkDidReceiveMessage(notification:NSNotification) ->Void  {
        let userInfo = notification.userInfo
        let title = userInfo?["title"] as! String
        let content = userInfo?["content"] as! String
        let type = userInfo?["content_type"] as! String
        let extras = userInfo?["extras"] as! [String:Any]
        self.message(title: title, body: content, extras: extras, type: type)
    }
    //MARK:监听极光登录成功
    func AuroraPushSuccess() -> Void {
        NotificationCenter.default.addObserver(self, selector: #selector((self.networkDidLogin)), name: NSNotification.Name.jpfNetworkDidLogin, object: nil)
    }
    //MARK:极光登录成功
    func networkDidLogin() -> Void {
        print("极光登录成功")
        let registID = JPUSHService.registrationID()
        UserDefaultSave(ZregistID, Value: registID)
        UserDefaults.standard.synchronize()
        if (UserDefauTake(ZToken) != nil) {
            if (UserDefauTake(ZCollegeName) != nil ){
                JPUSHService.setTags(nil, alias: UserDefauTake(ZCollegeName)!, fetchCompletionHandle: { (iResCode, iTags, iAlias) in
                    if (iResCode == 0) {//存在别名，设置成功
                        print("存在别名")
                    }else{
                        print("设置成功")
                    }
                })
            }
        }
    }
    //MARK:消息通知
    func sendNoti() -> Void {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "newMessage"), object: self, userInfo: nil)
    }
}
//MARK: -百度地图定位存储
extension AppDelegate {
    //MARK: 百度地图
    func BaiDuAPI() -> Void {
        _mapManager = BMKMapManager()
        let ret = _mapManager?.start("UNypGZdhGwwZnUbqSYCuCD7N9DS97gAh", generalDelegate: self)
        if ret == false {
            NSLog("manager start failed!")
        }
    }
    //MARK:定位
    func LocService() -> Void {
        locService = BMKLocationService()
        locService?.delegate = self
        locService?.startUserLocationService()
    }
    //MARK:位置更新
    func didUpdate(_ userLocation: BMKUserLocation!) {
        if  UserDefaults().object(forKey: Zlatitude) == nil {
            UserDefaults().set(userLocation.location.coordinate.latitude, forKey: Zlatitude)
        }
        if UserDefaults().object(forKey: Zlongitude) == nil {
            UserDefaults().set(userLocation.location.coordinate.longitude, forKey: Zlongitude)
        }
        let point1 = BMKMapPointForCoordinate(CLLocationCoordinate2DMake(UserDefaults().object(forKey: Zlatitude)! as! CLLocationDegrees,UserDefaults().object(forKey: Zlongitude)! as! CLLocationDegrees));
        let point2 = BMKMapPointForCoordinate(CLLocationCoordinate2DMake(userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude));
        let distance = BMKMetersBetweenMapPoints(point1,point2);
        print(distance)
        if distance > 2000 {
            UserDefaults().set(userLocation.location.coordinate.latitude, forKey: Zlatitude)
            UserDefaults().set(userLocation.location.coordinate.longitude, forKey: Zlongitude)
            longitude = "\(userLocation.location.coordinate.longitude)"
            latitude = "\(userLocation.location.coordinate.latitude)"
            self.save()
        }
    }
    //MARK:存储坐标
    func save() -> Void {
        if (UserDefauTake(ZToken) != nil) && (UserDefauTake(ZregistID) != nil) {
            HttpRequestTool.sharedInstance.HttpRequestJSONDataWithUrl(url: Student_positionsave, type: .POST, parameters: ["app_token":UserDefauTake(ZToken)!,"client":deviceUUID!,"longitude":longitude,"latitude":latitude,"registerId":UserDefauTake(ZregistID)!], SafetyCertification: true, successed: { (success) in
            }) { (error) in
            }
        }
    }
}
extension AppDelegate {
    
    //MARK:获取个数
    func Unread() -> Void {
        if (UserDefauTake(ZToken) != nil ) {
            HttpRequestTool.sharedInstance.HttpRequestJSONDataWithUrl(url: Student_unread, type: .POST, parameters: ["app_token":UserDefauTake(ZToken)!,"client":deviceUUID!], SafetyCertification: true, successed: { (success) in
                let status = success?["status"] as! Int
                if status == 200 {
                    let badgeValue = success?["data"] as! Int
                    let items = self.tabbar.tabBar.items?[1]
                    if badgeValue == 0 {
                        items?.badgeValue = nil
                    } else {
                        items?.badgeValue = "\(badgeValue)"
                        UIApplication.shared.applicationIconBadgeNumber = badgeValue
                    }
                }
            }) { (error) in
            }
        } else {
            UIApplication.shared.applicationIconBadgeNumber = 0
        }
    }
    
    //MARK:初始化tabbar
    func CreatTabbar() -> Void {
        let home = HomePageViewController()
        home.title = "主页"
        home.tabBarItem.image = UIImage(named: "tab_home_gray")
        home.tabBarItem.selectedImage = UIImage(named: "tab_home_blue")
        let Message =  MessageViewController()
        Message.title = "消息"
        Message.tabBarItem.image = UIImage(named: "tab_message_gray")?.withRenderingMode(.alwaysOriginal)
        Message.tabBarItem.selectedImage = UIImage(named: "tab_message_blue")?.withRenderingMode(.alwaysOriginal)
        tabbar.viewControllers = [home,Message]
        let TestLeft =  PersonalInformationViewController()
        
        ocSlide = SwiftSlideRootViewController.init(leftVc: TestLeft, mainVc: tabbar, slideTranlationX: 200.0)
        let SlideNav = UINavigationController(rootViewController: ocSlide)
        self.window?.rootViewController = SlideNav
    }
    //MARK:刷新token
    func RefreshToken() -> Void {
        if (UserDefauTake(Zrefresh_token) == nil) {
            return
        }
        HttpRequestTool.sharedInstance.HttpRequestJSONDataWithUrl(url: Student_refresh, type: .POST, parameters: ["app_token":UserDefauTake(ZToken)!,"client_id":deviceUUID!,"refresh_token":UserDefauTake(Zrefresh_token)!], SafetyCertification: true, successed: { (success) in
            let status = success?["status"] as! Int
            if status == 200 {
                let data = success?["data"] as! NSDictionary
                let token = data["access_token"]  as! String
                let refresh_token = data["refresh_token"] as! String?
                UserDefaultSave("access_token", Value: token)
                UserDefaultSave(Zrefresh_token, Value: refresh_token)
            }
        }) { (error) in
        }
    }
    
    // MARK:自定义消息Tost
    /// - Parameters:
    ///   - title: 标题
    ///   - body: 内容
    ///   - extras: 详情
    ///   - type: 类型
    func message(title:String,body:String,extras:[String:Any],type:String) -> Void {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: type), object: self, userInfo: nil)
        let nav = self.window?.rootViewController as! UINavigationController
        
        let warning = MessageView.viewFromNib(layout: .CardView)
        warning.configureTheme(.warning)
        warning.configureDropShadow()
        warning.configureContent(title: title, body: body, iconText: "")
        warning.button?.setTitle("进入", for: .normal)
        warning.buttonTapHandler = {
            (btn) in
            switch type {
            case "help":
                
                break
            case "notice":
                self.tabbar.selectedIndex = 1
                nav.popToRootViewController(animated: false)
                break
            case "question":
                let QH = QuestionHistoryViewController()
                let model = OnlineConsultingModel()
                model.id = extras["questionId"] as! String?
                model.content = body
                model.title = title
                QH.Model = model
                nav.pushViewController(QH, animated: true)
                break
            default:
                break
            }
        }
        SwiftMessages.show(view: warning)
    }
}
