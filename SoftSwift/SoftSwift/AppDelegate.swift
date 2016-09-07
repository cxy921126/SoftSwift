//
//  AppDelegate.swift
//  SoftSwift
//
//  Created by Mac mini on 16/3/1.
//  Copyright © 2016年 XMU. All rights reserved.
//

import UIKit

let userHasLoginNote = "userHasLoginNote"
///账号登录标识
var isLogin : Bool = false

@UIApplicationMain

class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func isLoginOrNot(){
        if UserAccount.readAccount() != nil {
            isLogin = true
        }else{
            isLogin = false
        }
    }
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        isLoginOrNot()
        //注册通知的监听事件
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(AppDelegate.switchController(_:)), name: userHasLoginNote, object: nil)
        
        // Override point for customization after application launch.
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        window?.backgroundColor = UIColor.whiteColor()
        window?.rootViewController = MainTabBarController()
        window?.makeKeyAndVisible()
        
        ///设置全局navibar和tabbar的渲染颜色为orange
        UINavigationBar.appearance().tintColor = UIColor.orangeColor()
        UITabBar.appearance().tintColor = UIColor.orangeColor()
        UITabBar.appearance().alpha = 0.97
        
        return true
    }
    
    func switchController(notify:NSNotification){
        isLogin = true
        //新建一个uiwindow以代替未登录window
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        if notify.object!.isEqual("toWeibo"){
            self.window?.rootViewController = MainTabBarController()
            self.window?.rootViewController?.view.alpha = 0.0
            UIView.animateWithDuration(1.0, animations: {
                self.window?.rootViewController?.view.alpha = 1.0
                }, completion: nil)
        }
        if notify.object!.isEqual("toNewfeature"){
            window?.rootViewController = NewfeatureCollectionViewController()
        }
        window?.makeKeyAndVisible()
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

