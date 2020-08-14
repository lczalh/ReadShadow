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
        coder.encode(allPlayerSourceSeriesNames, forKey: "allPlayerSourceSeriesNames")
        coder.encode(allPlayerSourceSeriesUrls, forKey: "allPlayerSourceSeriesUrls")
        coder.encode(playerSource, forKey: "playerSource")
        coder.encode(readShadowVideoResourceModel, forKey: "readShadowVideoResourceModel")
        coder.encode(allPlayerSourceNames, forKey: "allPlayerSourceNames")
        coder.encode(allPlayerSourceSeriesCurrentTimes, forKey: "allPlayerSourceSeriesCurrentTimes")
        coder.encode(currentPlayerSourceIndex, forKey: "currentPlayerSourceIndex")
        coder.encode(currentPlayerParsingIndex, forKey: "currentPlayerParsingIndex")
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
        allPlayerSourceSeriesNames = coder.decodeObject(forKey: "allPlayerSourceSeriesNames") as? Array<Array<String>>
        allPlayerSourceSeriesUrls = coder.decodeObject(forKey: "allPlayerSourceSeriesUrls") as? Array<Array<String>>
        playerSource = coder.decodeObject(forKey: "playerSource") as? String
        readShadowVideoResourceModel = coder.decodeObject(forKey: "readShadowVideoResourceModel") as? ReadShadowVideoResourceModel
        allPlayerSourceNames = coder.decodeObject(forKey: "allPlayerSourceNames") as? Array<String>
        allPlayerSourceSeriesCurrentTimes = coder.decodeObject(forKey: "allPlayerSourceSeriesCurrentTimes") as? Array<Array<CGFloat>>
        currentPlayerSourceIndex = coder.decodeObject(forKey: "currentPlayerSourceIndex") as? Int
        currentPlayerParsingIndex = coder.decodeObject(forKey: "currentPlayerParsingIndex") as? Int
    }
    
    /// 资源模型
    var readShadowVideoResourceModel: ReadShadowVideoResourceModel?
    
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
    var url : String? {
        didSet {
            guard url != nil, url?.isEmpty == false else { return }
            let playerSourceAry = parsingResourceSiteM3U8Dddress(url: url!)
            allPlayerSourceSeriesNames = playerSourceAry.0
            allPlayerSourceSeriesUrls = playerSourceAry.1
            if allPlayerSourceSeriesCurrentTimes?.count ?? 0 <= 0 {
                var allPlayerSourceSeriesCurrentTimes: Array<Array<CGFloat>> = []
                for allPlayerSourceSeriesUrl in allPlayerSourceSeriesUrls ?? [] {
                    var seriesCurrentTimes: Array<CGFloat> = []
                    for _ in allPlayerSourceSeriesUrl {
                        seriesCurrentTimes.append(CGFloat(0.0))
                    }
                    allPlayerSourceSeriesCurrentTimes.append(seriesCurrentTimes)
                }
                self.allPlayerSourceSeriesCurrentTimes = allPlayerSourceSeriesCurrentTimes
            }
        }
    }
    
    /// 上映年
    var year : String?
    
    /// 类别
    var category: String?
    
    /// 连续中  例：更新至XX集
    var continu: String?
    
    /// 播放源
    private var playerSource: String? {
        didSet {
            guard playerSource?.count ?? 0 > 0 else { return }
            var playerSourceNames: Array<String> = []
            if playerSource?.contains("$$$") == true { // 多个播放器
                playerSourceNames = playerSource?.components(separatedBy: "$$$").filter{ $0.count > 0 } ?? []
            } else { // 单个
                playerSourceNames.append(playerSource ?? "")
            }
            allPlayerSourceNames = playerSourceNames
        }
    }
    
    /// 剧集名称
    var allPlayerSourceSeriesNames: Array<Array<String>>?
    
    /// 剧集地址
    var allPlayerSourceSeriesUrls: Array<Array<String>>?
    
    /// 所有播放源名称
    var allPlayerSourceNames: Array<String>?
    
    /// 所以播放源剧集当前播放时间
    var allPlayerSourceSeriesCurrentTimes: Array<Array<CGFloat>>?
    
    /// 当前播放源索引
    var currentPlayerSourceIndex: Int?
    
    /// 当前解析索引
    var currentPlayerParsingIndex: Int?
    
    
    func mapping(map: Map)
    {
        if name == nil || name?.isEmpty == true {
            name <- map["vod_name"]
        }
        
        if actor == nil || actor?.isEmpty == true {
            actor <- map["vod_actor"]
        }
        
        if area == nil || actor?.isEmpty == true {
            area <- map["vod_area"]
        }
        
        if introduction == nil || introduction?.isEmpty == true {
            introduction <- map["vod_content"]
        }
        
        if director == nil || director?.isEmpty == true {
            director <- map["vod_director"]
        }
        
        if language == nil || language?.isEmpty == true {
            language <- map["vod_language"]
        }
        
        if language == nil || language?.isEmpty == true {
            language <- map["vod_lang"]
        }
        
        if pic == nil || pic?.isEmpty == true {
            pic <- map["vod_pic"]
        }
        
        if type == nil || type?.isEmpty == true {
            type <- map["vod_class"]
        }
        if type == nil || type?.isEmpty == true {
            type <- map["vod_type"]
        }
        
        if url == nil || url?.isEmpty == true {
            url <- map["vod_play_url"]
        }
        if url == nil || url?.isEmpty == true {
            url <- map["vod_url"]
        }
        
        if year == nil || year?.isEmpty == true {
            year <- map["vod_year"]
        }
        
        if category == nil || category?.isEmpty == true {
            category <- map["type_name"]
        }
        if category == nil || category?.isEmpty == true {
            category <- map["list_name"]
        }
        
        if continu == nil || continu?.isEmpty == true {
            continu <- map["vod_remarks"]
        }
        if continu == nil || continu?.isEmpty == true {
            continu <- map["vod_continu"]
        }
        
        if playerSource == nil || playerSource?.isEmpty == true {
            playerSource <- map["vod_play"]
        }
        if playerSource == nil || playerSource?.isEmpty == true {
            playerSource <- map["vod_play_from"]
        }
    }
    
    class func newInstance(map: Map) -> Mappable?{
        return ReadShadowVideoModel()
    }
    required init?(map: Map){}
    override init(){}
    
    /// 解析资源站中的m3u8播放地址
    /// - Parameter url: 综合的播放地址字符串
    /// - Returns: (所有集数，所有集数播放地址)
    private func parsingResourceSiteM3U8Dddress(url: String) -> (Array<Array<String>>, Array<Array<String>>) {
        guard url.count > 0 else { return ([], []) }
        /// 存储所有播放源剧集名称
        var allPlayerSourceTitles: Array<Array<String>> = []
        /// 存储所有播放源剧集地址
        var allPlayerSourceUrls: Array<Array<String>> = []
        
        if url.contains("$$$") == true { // 存在多个播放器
            // 获取多个播放源数据
            let playerSourceAry = url.components(separatedBy: "$$$").filter{ $0.count > 0 }
                //.filter{ $0.contains(".m3u8") || $0.contains(".mp4") || $0.contains(".html") }
            // 遍历符合要求的数据
            for playerSource in playerSourceAry {
                let titleAndUrlAry = singlePlaybackSourceDataParsing(url: playerSource)
                allPlayerSourceTitles.append(titleAndUrlAry.0)
                allPlayerSourceUrls.append(titleAndUrlAry.1)
            }
        } else {
            let playerSource = url//.contains(".m3u8") || url.contains(".mp4") || url.contains(".html") ? url : ""
            let titleAndUrlAry = singlePlaybackSourceDataParsing(url: playerSource)
            allPlayerSourceTitles.append(titleAndUrlAry.0)
            allPlayerSourceUrls.append(titleAndUrlAry.1)
        }
        return (allPlayerSourceTitles, allPlayerSourceUrls)
    }
    
    /// 单个播放源数据解析
    private func singlePlaybackSourceDataParsing(url: String) -> (Array<String>, Array<String>) {
        // 存在m3u8的视频才继续往下处理
        guard url.count > 0 else { return ([], []) }
        // 存储所有剧集字符串的数组
        var allSeriesStringAry: Array<String> = []
        // 判断是否存在多集
        if url.contains("\r\n") == true { // 存在多集
            allSeriesStringAry = url.components(separatedBy: "\r\n").filter{ $0.count > 0 }
        } else if url.contains("#") == true { // 存在多集
            allSeriesStringAry = url.components(separatedBy: "#").filter{ $0.count > 0 }
        } else { //单集
            allSeriesStringAry.append(url)
        }
        var titles: Array<String> = []
        var urls: Array<String> = []
        for titleAndUrlString in allSeriesStringAry {
            let titleAndUrl = titleAndUrlString.components(separatedBy: "$").filter{ $0.count > 0 }
            guard titleAndUrl.count == 2 else { continue }
            titles.append(titleAndUrl.first!)
            urls.append(titleAndUrl.last!.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")
        }
        return (titles, urls)
    }
    
}
