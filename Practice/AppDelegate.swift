//
//  AppDelegate.swift
//  Practice
//
//  Created by 新龙科技 on 2016/12/27.
//  Copyright © 2016年 新龙科技. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        if (UserDefauTake(ZToken) != nil) {
            self.CreatTabbar()
        } else {
            let nav = UINavigationController(rootViewController: ViewController())
            self.window?.rootViewController = nav
        }

        return true
    }
    func CreatTabbar() -> Void {
        let home = UINavigationController.init(rootViewController: HomePageViewController())
        home.title = "主页"
        let Message = UINavigationController.init(rootViewController: MessageViewController())
        Message.title = "消息"
        let tabbar = UITabBarController()
        tabbar.viewControllers = [home,Message]
        let TestLeft = PersonalInformationViewController()
        TestLeft.view.backgroundColor = UIColor.red
        let ocSlide = SwiftSlideRootViewController.init(leftVc: TestLeft, mainVc: tabbar, slideTranlationX: 200.0)
        let Slidenav = UINavigationController.init(rootViewController: ocSlide)
        self.window?.rootViewController = Slidenav
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

