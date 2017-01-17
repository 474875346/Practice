//
//  AppDelegate.swift
//  Practice
//
//  Created by 新龙科技 on 2016/12/27.
//  Copyright © 2016年 新龙科技. All rights reserved.
//

import UIKit
import Hero
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
        //MARK:-极光推送
        let entity = JPUSHRegisterEntity()
        entity.types = Int(JPAuthorizationOptions.alert.rawValue) | Int(JPAuthorizationOptions.badge.rawValue) | Int(JPAuthorizationOptions.sound.rawValue);
        JPUSHService.register(forRemoteNotificationConfig: entity, delegate: self)
        JPUSHService.setup(withOption: launchOptions, appKey: "023b08c13c84e501e0165ac2", channel: channel, apsForProduction: isProduction, advertisingIdentifier: nil)
        self.AuroraPushSuccess()
        self.Unread()
        self.LocService()
        return true
    }
    //MARK:监听极光登录成功
    func AuroraPushSuccess() -> Void {
        NotificationCenter.default.addObserver(self, selector: #selector((self.networkDidLogin)), name: NSNotification.Name.jpfNetworkDidLogin, object: nil)
    }
    //MARK:极光登录成功
    func networkDidLogin() -> Void {
        let registID = JPUSHService.registrationID()
        UserDefaultSave(ZregistID, Value: registID)
        UserDefaults.standard.synchronize()
        if (UserDefauTake(ZToken) != nil) {
            if (UserDefauTake(ZhaveBieMing) != nil) {
                let beiming = UserDefauTake(ZhaveBieMing)! as NSString
                if  beiming.isEqual(to: "Y") {
                    print("已经存在别名了,不需要设置了")
                } else {
                    if (UserDefauTake(ZCollegeName) != nil ){
                        JPUSHService.setTags(nil, alias: UserDefauTake(ZCollegeName)!, fetchCompletionHandle: { (iResCode, iTags, iAlias) in
                            if (iResCode == 0) {//存在别名，设置成功
                                UserDefaultSave(ZhaveBieMing, Value: "Y")
                                UserDefaults.standard.synchronize()
                            }else{
                                UserDefaultSave(ZhaveBieMing, Value: "N")
                                UserDefaults.standard.synchronize()
                            }
                        })
                    }
                }
            }
        }
    }
    //MARK: 百度地图
    func BaiDuAPI() -> Void {
        _mapManager = BMKMapManager()
        let ret = _mapManager?.start("UNypGZdhGwwZnUbqSYCuCD7N9DS97gAh", generalDelegate: self)
        if ret == false {
            NSLog("manager start failed!")
        }
    }
    func CreatTabbar() -> Void {
        let home = UINavigationController.init(rootViewController: HomePageViewController())
        home.title = "主页"
        home.tabBarItem.image = UIImage(named: "tab_home_gray")
        home.tabBarItem.selectedImage = UIImage(named: "tab_home_blue")
        let Message = UINavigationController.init(rootViewController: MessageViewController())
        Message.title = "消息"
        Message.tabBarItem.image = UIImage(named: "tab_message_gray")?.withRenderingMode(.alwaysOriginal)
        Message.tabBarItem.selectedImage = UIImage(named: "tab_message_blue")?.withRenderingMode(.alwaysOriginal)
        tabbar.viewControllers = [home,Message]
        let TestLeft =  PersonalInformationViewController()
        
        ocSlide = SwiftSlideRootViewController.init(leftVc: TestLeft, mainVc: tabbar, slideTranlationX: 200.0)
        let SlideNav = UINavigationController(rootViewController: ocSlide)
        self.window?.rootViewController = SlideNav
    }
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        self.Unread()
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
    //MARK:消息通知
    func sendNoti() -> Void {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "newMessage"), object: self, userInfo: nil)
    }
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
}
extension AppDelegate {
    
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
            UserDefaults().set(userLocation.location.coordinate.latitude, forKey: Zlongitude)
        }
        let point1 = BMKMapPointForCoordinate(CLLocationCoordinate2DMake(UserDefaults().object(forKey: Zlatitude)! as! CLLocationDegrees,UserDefaults().object(forKey: Zlongitude)! as! CLLocationDegrees));
        let point2 = BMKMapPointForCoordinate(CLLocationCoordinate2DMake(userLocation.location.coordinate.latitude,userLocation.location.coordinate.latitude));
        let distance = BMKMetersBetweenMapPoints(point1,point2);
        print(distance)
        if distance > 2000 {
            UserDefaults().set(userLocation.location.coordinate.latitude, forKey: Zlatitude)
            UserDefaults().set(userLocation.location.coordinate.latitude, forKey: Zlongitude)
            longitude = "\(userLocation.location.coordinate.longitude)"
            latitude = "\(userLocation.location.coordinate.latitude)"
            self.save()
        }
    }
    func save() -> Void {
        HttpRequestTool.sharedInstance.HttpRequestJSONDataWithUrl(url: Student_positionsave, type: .POST, parameters: ["app_token":UserDefauTake(ZToken)!,"client":deviceUUID!,"longitude":longitude,"latitude":latitude,"registerId":UserDefauTake(ZregistID)!], SafetyCertification: true, successed: { (success) in
        }) { (error) in
        }
    }
}
