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
        coder.encode(readShadowVideoResourceModel, forKey: "readShadowVideoResourceModel")
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
        readShadowVideoResourceModel = coder.decodeObject(forKey: "readShadowVideoResourceModel") as? ReadShadowVideoResourceModel
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
            if url?.contains(".m3u8") == true {
                let m = parsingResourceSiteM3U8Dddress(url: url!)
                seriesNames = m.0
                seriesUrls = m.1
            } else {
                let m = parsingResourceSitelLnearChainDddress(url: url!).first
                seriesNames = m?.0 
                seriesUrls = m?.1
            }
        }
    }
    
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
        type <- map["vod_type"]
        
        url <- map["vod_play_url"]
        url <- map["vod_url"]
        
        year <- map["vod_year"]
        
        category <- map["type_name"]
        category <- map["list_name"]
        
        continu <- map["vod_remarks"]
        continu <- map["vod_continu"]
        
        playerSource <- map["vod_play"]
        playerSource <- map["vod_play_from"]
    }
    
    class func newInstance(map: Map) -> Mappable?{
        return ReadShadowVideoModel()
    }
    required init?(map: Map){}
    override init(){}
    
    /// 解析资源站中的m3u8播放地址
    /// - Parameter url: 综合的播放地址字符串
    /// - Returns: (所有集数，所有集数播放地址)
    private func parsingResourceSiteM3U8Dddress(url: String) -> (Array<String>, Array<String>) {
        guard url.count > 0 else { return ([], []) }
        var titleAndUrlAry: Array<String> = []
        if url.contains("$$$") == true { // 存在多个播放器 只去m3u8格式的视频
            titleAndUrlAry = url.components(separatedBy: "$$$").filter{ $0.contains(".m3u8") }.first?.components(separatedBy: "\r\n") ?? []
        } else {
            titleAndUrlAry = url.components(separatedBy: "\r\n").filter{ $0.contains("m3u8") }
        }
        var titles: Array<String> = []
        var urls: Array<String> = []
        for titleAndUrlString in titleAndUrlAry {
            let titleAndUrl = titleAndUrlString.components(separatedBy: "$")
            guard titleAndUrl.count == 2 else { return ([], []) }
            titles.append(titleAndUrl.first!)
            urls.append(titleAndUrl.last!.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")
        }
        return (titles, urls)
    }
    
    /// 解析资源站中的直链播放地址
    /// - Parameter url: 综合的播放地址字符串
    /// - Returns: (所有播放源剧集字典, 所有播放源数组)
    private func parsingResourceSitelLnearChainDddress(url: String) -> Array<(Array<String>, Array<String>)> {
        guard url.count > 0 else { return [] }
        /// 所有播放源数据
        var allPlayDataAry: Array<(Array<String>, Array<String>)> = []

        if url.contains("$$$") == true { // 存在多个播放源
            let playSourceDataAry = url.components(separatedBy: "$$$").filter{ $0.count > 0 }
            // 遍历所有播放源
            for playSourceData in playSourceDataAry {
                guard playSourceData.isEmpty == false else { continue }
                // 标题数组
                var titles: Array<String> = []
                /// 地址数组
                var urls: Array<String> = []
                // 判断是否存在多集
                if playSourceData.contains("#") == true { // 多集
                    // 所有剧集数组
                    let playSourceSeriesAry = playSourceData.components(separatedBy: "#")
                    // 取出每一集标题和地址
                    for playSourceSeries in playSourceSeriesAry {
                        let titleAndUrlAry = playSourceSeries.components(separatedBy: "$")
                        titles.append(titleAndUrlAry.first!)
                        urls.append(titleAndUrlAry.first!)
                    }
                } else { // 单集
                    let titleAndUrlAry = playSourceData.components(separatedBy: "$")
                    titles.append(titleAndUrlAry.first!)
                    urls.append(titleAndUrlAry.first!)
                }
                allPlayDataAry.append((titles, urls))
            }
        } else { // 只有单个播放源
            // 标题数组
            var titles: Array<String> = []
            /// 地址数组
            var urls: Array<String> = []
            
            // 判断是否存在多集
            if url.contains("#") == true { // 多集
                // 所有剧集数组
                let playSourceSeriesAry = url.components(separatedBy: "#")
                // 取出每一集标题和地址
                for playSourceSeries in playSourceSeriesAry {
                    let titleAndUrlAry = playSourceSeries.components(separatedBy: "$")
                    titles.append(titleAndUrlAry.first!)
                    urls.append(titleAndUrlAry.first!)
                }
            } else { // 单集
                let titleAndUrlAry = url.components(separatedBy: "$")
                titles.append(titleAndUrlAry.first!)
                urls.append(titleAndUrlAry.first!)
            }
            allPlayDataAry.append((titles, urls))
        }
        return allPlayDataAry
    }
}
