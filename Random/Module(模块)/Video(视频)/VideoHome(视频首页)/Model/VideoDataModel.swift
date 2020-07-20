//
//  VideoDataModel.swift
//  Random
//
//  Created by yu mingming on 2019/11/8.
//  Copyright © 2019 刘超正. All rights reserved.
//  视频信息模型

import Foundation

class VideoDataModel: NSObject, NSCoding, Mappable{
    
    /// 浏览时间
    var browseTime: String?
    
    /// 分类名
    var listName : String?
    
    /// 主演
    var vodActor : String?
    
    /// 添加时间
    var vodAddtime : String?
    
    /// 视频地区
    var vodArea : String?
    var vodCid : String?
    
    /// 视频简介
    var vodContent : String?
    var vodContinu : String?
    var vodCopyright : Int?
    
    /// 导演
    var vodDirector : String?
    var vodDoubanId : Int?
    var vodFilmtime : Int?
    var vodHits : String?
    
    /// 视频id
    var vodId : String?
    var vodInputer : String?
    var vodIsend : Int?
    var vodKeywords : String?
    
    /// 视频语言
    var vodLanguage : String?

    var vodLength : Int?
    
    /// 视频名称
    var vodName : String?
    
    /// 封面图
    var vodPic : String?
    var vodPlay : String?
    var vodReurl : String?
    var vodSeries : String?
    var vodServer : String?
    var vodStars : Int?
    var vodState : String?
    var vodStatus : Int?
    var vodTitle : String?
    var vodTotal : Int?
    var vodTv : String?
    
    /// 视频类型
    var vodType : String?
    
    /// 视频地址
    var vodUrl : String?
    var vodVersion : String?
    var vodWeekday : String?
    /// 上映年
    var vodYear : String?
    
    /// 当前播放索引
    var currentPlayIndex: Int?
    
    /// 当前播放时间
    var currentPlayTime: CGFloat = 0.0
    
//    var index: CGFloat = 0


    class func newInstance(map: Map) -> Mappable?{
        return VideoDataModel()
    }
    required init?(map: Map){}
    private override init(){}

    func mapping(map: Map)
    {
        browseTime <- map["browseTime"]
        listName <- map["list_name"]
        vodActor <- map["vod_actor"]
        vodAddtime <- map["vod_addtime"]
        vodArea <- map["vod_area"]
        vodCid <- map["vod_cid"]
        vodContent <- map["vod_content"]
        vodContinu <- map["vod_continu"]
        vodCopyright <- map["vod_copyright"]
        vodDirector <- map["vod_director"]
        vodDoubanId <- map["vod_douban_id"]
        vodFilmtime <- map["vod_filmtime"]
        vodHits <- map["vod_hits"]
        vodId <- map["vod_id"]
        vodInputer <- map["vod_inputer"]
        vodIsend <- map["vod_isend"]
        vodKeywords <- map["vod_keywords"]
        vodLanguage <- map["vod_language"]
        vodLength <- map["vod_length"]
        vodName <- map["vod_name"]
        vodPic <- map["vod_pic"]
        vodPlay <- map["vod_play"]
        vodReurl <- map["vod_reurl"]
        vodSeries <- map["vod_series"]
        vodServer <- map["vod_server"]
        vodStars <- map["vod_stars"]
        vodState <- map["vod_state"]
        vodStatus <- map["vod_status"]
        vodTitle <- map["vod_title"]
        vodTotal <- map["vod_total"]
        vodTv <- map["vod_tv"]
        vodType <- map["vod_type"]
        vodUrl <- map["vod_url"]
        vodVersion <- map["vod_version"]
        vodWeekday <- map["vod_weekday"]
        vodYear <- map["vod_year"]
    }

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
    {
        browseTime = aDecoder.decodeObject(forKey: "browseTime") as? String
        listName = aDecoder.decodeObject(forKey: "list_name") as? String
         vodActor = aDecoder.decodeObject(forKey: "vod_actor") as? String
         vodAddtime = aDecoder.decodeObject(forKey: "vod_addtime") as? String
         vodArea = aDecoder.decodeObject(forKey: "vod_area") as? String
         vodCid = aDecoder.decodeObject(forKey: "vod_cid") as? String
         vodContent = aDecoder.decodeObject(forKey: "vod_content") as? String
         vodContinu = aDecoder.decodeObject(forKey: "vod_continu") as? String
         vodCopyright = aDecoder.decodeObject(forKey: "vod_copyright") as? Int
         vodDirector = aDecoder.decodeObject(forKey: "vod_director") as? String
         vodDoubanId = aDecoder.decodeObject(forKey: "vod_douban_id") as? Int
         vodFilmtime = aDecoder.decodeObject(forKey: "vod_filmtime") as? Int
         vodHits = aDecoder.decodeObject(forKey: "vod_hits") as? String
         vodId = aDecoder.decodeObject(forKey: "vod_id") as? String
         vodInputer = aDecoder.decodeObject(forKey: "vod_inputer") as? String
         vodIsend = aDecoder.decodeObject(forKey: "vod_isend") as? Int
         vodKeywords = aDecoder.decodeObject(forKey: "vod_keywords") as? String
         vodLanguage = aDecoder.decodeObject(forKey: "vod_language") as? String
         vodLength = aDecoder.decodeObject(forKey: "vod_length") as? Int
         vodName = aDecoder.decodeObject(forKey: "vod_name") as? String
         vodPic = aDecoder.decodeObject(forKey: "vod_pic") as? String
         vodPlay = aDecoder.decodeObject(forKey: "vod_play") as? String
         vodReurl = aDecoder.decodeObject(forKey: "vod_reurl") as? String
         vodSeries = aDecoder.decodeObject(forKey: "vod_series") as? String
         vodServer = aDecoder.decodeObject(forKey: "vod_server") as? String
         vodStars = aDecoder.decodeObject(forKey: "vod_stars") as? Int
         vodState = aDecoder.decodeObject(forKey: "vod_state") as? String
         vodStatus = aDecoder.decodeObject(forKey: "vod_status") as? Int
         vodTitle = aDecoder.decodeObject(forKey: "vod_title") as? String
         vodTotal = aDecoder.decodeObject(forKey: "vod_total") as? Int
         vodTv = aDecoder.decodeObject(forKey: "vod_tv") as? String
         vodType = aDecoder.decodeObject(forKey: "vod_type") as? String
         vodUrl = aDecoder.decodeObject(forKey: "vod_url") as? String
         vodVersion = aDecoder.decodeObject(forKey: "vod_version") as? String
         vodWeekday = aDecoder.decodeObject(forKey: "vod_weekday") as? String
         vodYear = aDecoder.decodeObject(forKey: "vod_year") as? String
        currentPlayIndex = aDecoder.decodeObject(forKey: "currentPlayIndex") as? Int
        currentPlayTime = aDecoder.decodeObject(forKey: "currentPlayTime") as? CGFloat ?? 0.0
    }

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc func encode(with aCoder: NSCoder)
    {
        aCoder.encode(browseTime, forKey: "browseTime")
        aCoder.encode(listName, forKey: "list_name")
        aCoder.encode(vodActor, forKey: "vod_actor")
        aCoder.encode(vodAddtime, forKey: "vod_addtime")
        aCoder.encode(vodArea, forKey: "vod_area")
        aCoder.encode(vodCid, forKey: "vod_cid")
        aCoder.encode(vodContent, forKey: "vod_content")
        aCoder.encode(vodContinu, forKey: "vod_continu")
        aCoder.encode(vodCopyright, forKey: "vod_copyright")
        aCoder.encode(vodDirector, forKey: "vod_director")
        aCoder.encode(vodDoubanId, forKey: "vod_douban_id")
        aCoder.encode(vodFilmtime, forKey: "vod_filmtime")
        aCoder.encode(vodHits, forKey: "vod_hits")
        aCoder.encode(vodId, forKey: "vod_id")
        aCoder.encode(vodInputer, forKey: "vod_inputer")
        aCoder.encode(vodIsend, forKey: "vod_isend")
        aCoder.encode(vodKeywords, forKey: "vod_keywords")
        aCoder.encode(vodLanguage, forKey: "vod_language")
        aCoder.encode(vodLength, forKey: "vod_length")
        aCoder.encode(vodName, forKey: "vod_name")
        aCoder.encode(vodPic, forKey: "vod_pic")
        aCoder.encode(vodPlay, forKey: "vod_play")
        aCoder.encode(vodReurl, forKey: "vod_reurl")
        aCoder.encode(vodSeries, forKey: "vod_series")
        aCoder.encode(vodServer, forKey: "vod_server")
        aCoder.encode(vodStars, forKey: "vod_stars")
        aCoder.encode(vodState, forKey: "vod_state")
        aCoder.encode(vodStatus, forKey: "vod_status")
        aCoder.encode(vodTitle, forKey: "vod_title")
        aCoder.encode(vodTotal, forKey: "vod_total")
        aCoder.encode(vodTv, forKey: "vod_tv")
        aCoder.encode(vodType, forKey: "vod_type")
        aCoder.encode(vodUrl, forKey: "vod_url")
        aCoder.encode(vodVersion, forKey: "vod_version")
        aCoder.encode(vodWeekday, forKey: "vod_weekday")
        aCoder.encode(vodYear, forKey: "vod_year")
        aCoder.encode(currentPlayIndex, forKey: "currentPlayIndex")
        aCoder.encode(currentPlayTime, forKey: "currentPlayTime")
    }

}
