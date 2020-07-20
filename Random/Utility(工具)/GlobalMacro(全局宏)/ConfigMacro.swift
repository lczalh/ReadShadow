//
//  ConfigMacro.swift
//  Random
//
//  Created by yu mingming on 2019/10/18.
//  Copyright © 2019 刘超正. All rights reserved.
//

import Foundation

/// 取消所有网络请求
func cancelAllRequest() {
    Alamofire.Session.default.session.getTasksWithCompletionHandler { (sessionDataTask, uploadData, downloadData) in
        sessionDataTask.forEach { $0.cancel() }
        uploadData.forEach { $0.cancel() }
        downloadData.forEach { $0.cancel() }
    }
}

/// 过滤的视频分类
var filterVideoCategorys: Array<String> = {
    return [
        "高跟赤足视频",
        "街拍系列",
        "嫩妹写真",
        "美女写真",
        "伦理",
        "伦理片",
        "福利",
        "福利片",
        "美女视频秀",
        "VIP视频秀",
        "情色",
        "情色片",
        "美女",
        "00",
        "短视频",
        "连续剧",
        "电影片",
        "动漫片",
        "倫理",
        "倫理片",
        "解说",
        "海外剧",
        "理论片"
    ]
}()


/// 判断是否获取了去广告特权
/// - Returns: true：是   false：否
func isGetAdvertisingPrivilege() -> Bool {
    let existingExpirationTime = CZObjectStore.standard.cz_readObjectInUserDefault(key: "expirationTime")
    if existingExpirationTime == nil || (existingExpirationTime as! Date) < Date() { // 本地时间小于当前时间 / 本地时间不存在
        return false
    } else { // 本地时间有效
        return true
    }
}


// MARK: - 阅读相关
/// 阅读内容范围
let bookReadCententFrame: CGRect = CGRect(x: CZCommon.cz_dynamicFitWidth(15),
                                          y: CZCommon.cz_statusBarHeight + CZCommon.cz_dynamicFitHeight(30),
                                          width: CZCommon.cz_screenWidth - CZCommon.cz_dynamicFitWidth(30),
                                          height: CZCommon.cz_screenHeight - CZCommon.cz_dynamicFitHeight(35) - (CZCommon.cz_statusBarHeight + CZCommon.cz_dynamicFitHeight(30)) - CZCommon.cz_safeAreaHeight
)

/// 阅读字体颜色
var bookReadFontColor: UIColor {
    (CZObjectStore.standard.cz_readObjectInUserDefault(key: "bookReadFontColor") ?? UIColor.black) as! UIColor
}

/// 阅读字体名称
var bookReadFamilyName: String {
    (CZObjectStore.standard.cz_readObjectInUserDefault(key: "bookReadFamilyName") ?? "EuphemiaUCAS-Italic") as! String
}

/// 阅读字体大小
var bookReadFontSize: Float {
    (CZObjectStore.standard.cz_readObjectInUserDefault(key: "bookReadFontSize") ?? Float(16)) as! Float
}

/// 阅读主题颜色
var bookReadThemeColor: UIColor {
    (CZObjectStore.standard.cz_readObjectInUserDefault(key: "bookReadThemeColor") ?? UIColor.white) as! UIColor
}

/// 阅读风格名称
var bookReadStyleName: String {
    (CZObjectStore.standard.cz_readObjectInUserDefault(key: "bookReadStyleName") ?? "仿真") as! String
}

/// 极光推送Key
func getJPushKey() -> String {
    return "4e26c56061a737b9d0517066"
}

/// 应用id
let appId: String = "1513275323"

/// 视频资源文件夹路径
let videoResourceFolderPath = CZCommon.cz_documentPath + "/videoResourceFolder"

/// 视频浏览记录文件夹路径
let videoBrowsingRecordFolderPath = CZCommon.cz_documentPath + "/videoBrowsingRecordFolder"

/// 书架文件夹路径
let bookcaseFolderPath = CZCommon.cz_documentPath + "/bookcaseFolder"

/// 书浏览记录文件夹路径
let bookBrowsingRecordFolderPath = CZCommon.cz_documentPath + "/bookBrowsingRecordFolder"

/// 书源规则文件夹路径
let bookSourceRuleFolderPath = CZCommon.cz_documentPath + "/bookSourceRuleFolder"

