//
//  AppDelegate.swift
//  Practice
//
//  Created by 新龙科技 on 2016/12/27.
//  Copyright © 2016年 新龙科技. All rights reserved.
//

import UIKit
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,BMKGeneralDelegate {
    var ocSlide = SwiftSlideRootViewController.init(nil)
    var window: UIWindow?
    let tabbar = UITabBarController()
    var _mapManager: BMKMapManager?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        if (UserDefauTake(ZToken) != nil) {
            self.CreatTabbar()
        } else {
            let nav = UINavigationController(rootViewController: ViewController())
            self.window?.rootViewController = nav
        }
        let ret = _mapManager?.start("Ux1AngR0ftQ8QSKmPLWcYYumBeA7uch", generalDelegate: self)
        if ret == false {
            NSLog("manager start failed!")
        }
        return true
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
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

