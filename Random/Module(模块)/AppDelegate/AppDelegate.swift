//
//  AppDelegate.swift
//  Random
//
//  Created by 刘超正 on 2019/9/20.
//  Copyright © 2019 刘超正. All rights reserved.
//

import UIKit
import Tiercel
import IQKeyboardManagerSwift

let appDelegate = UIApplication.shared.delegate as! AppDelegate

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    /// 是否允许屏幕旋转
    var isAllowOrentitaionRotation: Bool = false
    
    /// 后台任务标识
    var backgroundTask: UIBackgroundTaskIdentifier = .invalid

    var sessionManager: SessionManager = {
        var configuration = SessionConfiguration()
        configuration.allowsCellularAccess = true
        let manager = SessionManager("videoDownload", configuration: configuration, operationQueue: DispatchQueue(label: "com.random.videoDownload"))
        return manager
    }()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        UIScrollView.appearance().contentInsetAdjustmentBehavior = .never
        UITableView.appearance().estimatedRowHeight = 0
        UITableView.appearance().estimatedSectionFooterHeight = 0
        UITableView.appearance().estimatedSectionHeaderHeight = 0
//        UICollectionViewFlowLayout.appearance()
        
        // 允许获取电量信息
        UIDevice.current.isBatteryMonitoringEnabled = true
        
        // 初始化谷歌广告sdk
        GADMobileAds.sharedInstance().start { (status) in }
        
        // 极光配置
        self.jPushConfig(launchOptions: launchOptions)
        
        // 控制整个功能是否启用
        IQKeyboardManager.shared.enable = true
        
        // 控制点击背景是否收起键盘
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        
        // 将右边Done改成完成
        IQKeyboardManager.shared.toolbarDoneBarButtonItemText = "完成"
        
        let expirationTime = Date() + 1.days
        CZObjectStore.standard.cz_objectWriteUserDefault(object: expirationTime, key: "expirationTime")
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.backgroundColor = UIColor.white
        // 应用是否是第一次启动
//        if CZCommon.cz_isFirstLaunch() == true {
//            self.window?.rootViewController = MainTabBarController()
//        } else {
//            self.window?.rootViewController = MainTabBarController()
//        }
        self.window?.rootViewController = StartupPageController()
        self.window?.makeKeyAndVisible()
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    // MARK: - 进入后台
    func applicationDidEnterBackground(_ application: UIApplication) {
        //注册后台任务
        self.backgroundTask = application.beginBackgroundTask(expirationHandler: {
            () -> Void in
            //如果没有调用endBackgroundTask，时间耗尽时应用程序将被终止
            application.endBackgroundTask(self.backgroundTask)
            self.backgroundTask = UIBackgroundTaskIdentifier.invalid
        })
    }
    
    // MARK: - 进入前台
    func applicationWillEnterForeground(_ application: UIApplication) {
        
    }
    
    // MARK: - 程序重新激活
    func applicationDidBecomeActive(_ application: UIApplication) {
        application.endBackgroundTask(backgroundTask)
        backgroundTask = UIBackgroundTaskIdentifier.invalid
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    // 必须实现此方法，并且把identifier对应的completionHandler保存起来
    func application(_ application: UIApplication, handleEventsForBackgroundURLSession identifier: String, completionHandler: @escaping () -> Void) {
        if sessionManager.identifier == identifier {
            sessionManager.completionHandler = completionHandler
        }
    }
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return .all
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        // 视频解析
        let url = url.absoluteString.components(separatedBy: "ReadShadow://").last ?? ""
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
        let directBroadcastAction = UIAlertAction(title: "直接播放", style: .default) { (action) in
            DispatchQueue.main.async {
                let fullscreenPlayController = FullscreenPlayController()
                fullscreenPlayController.videoURL = url
                fullscreenPlayController.hidesBottomBarWhenPushed = true
                CZCommon.cz_topmostController().navigationController?.pushViewController(fullscreenPlayController, animated: true)
            }
        }
        let parsingPlayAction = UIAlertAction(title: "解析播放", style: .default) { (action) in
            DispatchQueue.main.async {
                UIApplication.shared.open(URL(string: "https://www.ckmov.com/?url=\(url)")!, options: [:], completionHandler: nil)
            }
        }
        let cancelAction = UIAlertAction(title: "取消", style: .cancel) { (action) in
        }
        if url.contains(".m3u8") || url.contains(".mp4") {
            alertController.addAction(directBroadcastAction)
        }
        alertController.addAction(parsingPlayAction)
        alertController.addAction(cancelAction)
        DispatchQueue.main.async {
            CZCommon.cz_topmostController().present(alertController, animated: true, completion: nil)
        }
        return true
    }
}
