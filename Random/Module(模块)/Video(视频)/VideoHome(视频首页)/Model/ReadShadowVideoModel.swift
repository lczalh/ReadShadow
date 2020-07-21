//
//  ReadShadowVideoModel.swift
//  Random
//
//  Created by yu mingming on 2020/7/20.
//  Copyright © 2020 刘超正. All rights reserved.
//

import UIKit

class ReadShadowVideoModel: NSObject, NSCoding, Mappable {
    
    func encode(with coder: NSCoder) {
        coder.encode(browseTime, forKey: "browseTime")
        coder.encode(currentPlayIndex, forKey: "currentPlayIndex")
        coder.encode(currentPlayTime, forKey: "currentPlayTime")
        coder.encode(name, forKey: "name")
        coder.encode(actor, forKey: "actor")
        coder.encode(area, forKey: "area")
        coder.encode(introduction, forKey: "introduction")
        coder.encode(director, forKey: "director")
        coder.encode(language, forKey: "language")
        coder.encode(pic, forKey: "pic")
        coder.encode(type, forKey: "type")
        coder.encode(url, forKey: "url")
        coder.encode(year, forKey: "year")
        coder.encode(category, forKey: "category")
        coder.encode(continu, forKey: "continu")
        coder.encode(seriesNames, forKey: "seriesNames")
        coder.encode(seriesUrls, forKey: "seriesUrls")
        coder.encode(playerSource, forKey: "playerSource")
    }
    
    required init?(coder: NSCoder) {
        browseTime = coder.decodeObject(forKey: "browseTime") as? String
        currentPlayIndex = coder.decodeObject(forKey: "currentPlayIndex") as? Int
        currentPlayTime = coder.decodeObject(forKey: "currentPlayTime") as? CGFloat ?? 0.0
        name = coder.decodeObject(forKey: "name") as? String
        actor = coder.decodeObject(forKey: "actor") as? String
        area = coder.decodeObject(forKey: "area") as? String
        introduction = coder.decodeObject(forKey: "introduction") as? String
        director = coder.decodeObject(forKey: "director") as? String
        language = coder.decodeObject(forKey: "language") as? String
        pic = coder.decodeObject(forKey: "pic") as? String
        type = coder.decodeObject(forKey: "type") as? String
        url = coder.decodeObject(forKey: "url") as? String
        year = coder.decodeObject(forKey: "year") as? String
        category = coder.decodeObject(forKey: "category") as? String
        continu = coder.decodeObject(forKey: "continu") as? String
        seriesNames = coder.decodeObject(forKey: "seriesNames") as? Array<String>
        seriesUrls = coder.decodeObject(forKey: "seriesUrls") as? Array<String>
        playerSource = coder.decodeObject(forKey: "playerSource") as? String
    }
    
    
    /// 名称
    var name: String?
    
    /// 浏览时间
    var browseTime: String?
    
    /// 当前播放索引
    var currentPlayIndex: Int?
    
    /// 当前播放时间
    var currentPlayTime: CGFloat = 0.0
    
    /// 主演
    var actor : String?
    
    /// 地区
    var area : String?
    
    /// 视频简介
    var introduction : String?
    
    /// 导演
    var director : String?
    
    /// 视频语言
    var language : String?
    
    /// 封面图
    var pic : String?
    
    /// 类型
    var type : String?
    
    /// 播放地址
    var url : String?
    
    /// 上映年
    var year : String?
    
    /// 类别
    var category: String?
    
    /// 连续中  例：更新至XX集
    var continu: String?
    
    /// 剧集名称
    var seriesNames: Array<String>?
    
    /// 剧集地址
    var seriesUrls: Array<String>?
    
    /// 播放源
    var playerSource: String?
    
    func mapping(map: Map)
    {
        name <- map["vod_name"]
        actor <- map["vod_actor"]
        area <- map["vod_area"]
        introduction <- map["vod_content"]
        director <- map["vod_director"]
        language <- map["vod_language"]
        pic <- map["vod_pic"]
        type <- map["vod_class"]
        url <- map["vod_play_url"]
        year <- map["vod_year"]
        category <- map["type_name"]
        continu <- map["vod_remarks"]
    }
    
    class func newInstance(map: Map) -> Mappable?{
        return ReadShadowVideoModel()
    }
    required init?(map: Map){}
    override init(){}
}
