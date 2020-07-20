//
//  JPush.swift
//  csomanage
//
//  Created by yu mingming on 2019/10/14.
//  Copyright © 2019 glgs. All rights reserved.
//

import Foundation
import UserNotifications

extension AppDelegate {

    /// 极光推送配置
    public func jPushConfig(launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
        let entity = JPUSHRegisterEntity()
        if #available(iOS 12.0, *) {
            entity.types = Int(JPAuthorizationOptions.alert.rawValue) | Int(JPAuthorizationOptions.providesAppNotificationSettings.rawValue) | Int(JPAuthorizationOptions.sound.rawValue)
        } else {
            entity.types = Int(JPAuthorizationOptions.alert.rawValue) | Int(JPAuthorizationOptions.sound.rawValue)
        }
        JPUSHService.register(forRemoteNotificationConfig: entity, delegate: self)
        let advertisingId = ASIdentifierManager.shared().advertisingIdentifier.uuidString
        #if DEBUG
            JPUSHService.setup(withOption: launchOptions, appKey: getJPushKey(), channel: "AppStore", apsForProduction: false, advertisingIdentifier: advertisingId)
        #else
            JPUSHService.setup(withOption: launchOptions, appKey: getJPushKey(), channel: "AppStore", apsForProduction: true, advertisingIdentifier: advertisingId)
        #endif
        // 注册极光推送
        JPUSHService.validTag(UIDevice.vkKeychainIDFV(), completion: { (_, _, _, isSet) in
            if isSet == false { JPUSHService.setAlias(UIDevice.vkKeychainIDFV(), completion: nil, seq: 0) }
        }, seq: 0)
    }

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        /// Required - 注册 DeviceToken
        JPUSHService.registerDeviceToken(deviceToken)
    }


}

extension AppDelegate: JPUSHRegisterDelegate {
    func jpushNotificationAuthorization(_ status: JPAuthorizationStatus, withInfo info: [AnyHashable : Any]!) {
        cz_print(status)
    }
    

    // iOS 10 Support 接收到推送
    func jpushNotificationCenter(_ center: UNUserNotificationCenter!, willPresent notification: UNNotification!, withCompletionHandler completionHandler: ((Int) -> Void)!) {
        let userInfo = notification.request.content.userInfo
        if (notification.request.trigger?.isKind(of: UNPushNotificationTrigger.self))! {
            JPUSHService.handleRemoteNotification(userInfo)
        } else { // 本地通知

        }
        cz_print(userInfo)
        completionHandler(Int(UNNotificationPresentationOptions.alert.rawValue)) // 需要执行这个方法，选择是否提醒用户，有 Badge、Sound、Alert 三种类型可以选择设置
    }

    // iOS 10 Support 点击推送
    func jpushNotificationCenter(_ center: UNUserNotificationCenter!, didReceive response: UNNotificationResponse!, withCompletionHandler completionHandler: (() -> Void)!) {
        let userInfo = response.notification.request.content.userInfo as! Dictionary<String, Any>
        if (response.notification.request.trigger?.isKind(of: UNPushNotificationTrigger.self))! {
            JPUSHService.handleRemoteNotification(userInfo)


        } else { // 本地通知

        }
        cz_print(userInfo)
        completionHandler()  // 系统要求执行这个方法
    }


    // iOS 12 Support
    func jpushNotificationCenter(_ center: UNUserNotificationCenter!, openSettingsFor notification: UNNotification!) {
        let userInfo = notification.request.content.userInfo
        if (notification != nil) && (notification.request.trigger?.isKind(of: UNPushNotificationTrigger.self))! { //从通知界面直接进入应用

        } else { //从通知设置界面进入应用

        }
        cz_print(userInfo)
    }

    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        // Required, iOS 7 Support
        JPUSHService.handleRemoteNotification(userInfo)
        completionHandler(UIBackgroundFetchResult.newData)
    }


}
