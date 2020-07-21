//
//  V.swift
//  Random
//
//  Created by yu mingming on 2020/7/20.
//  Copyright © 2020 刘超正. All rights reserved.
//

import UIKit

class VideoParsing: NSObject {
    
    /// 解析资源站中的m3u8播放地址
    /// - Parameter url: 综合的播放地址字符串
    /// - Returns: (所有集数，所有集数播放地址)
    class func parsingResourceSiteM3U8Dddress(url: String) -> (Array<String>, Array<String>) {
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
            guard titleAndUrl.count == 2 else {
                CZHUD.showError("播放地址解析失败")
                return ([], [])
            }
            titles.append(titleAndUrl.first!)
            urls.append(titleAndUrl.last!.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")
        }
        return (titles, urls)
    }
    
    /// 解析资源站中的直链播放地址
    /// - Parameter url: 综合的播放地址字符串
    /// - Returns: (所有播放源剧集字典, 所有播放源数组)
    class func parsingResourceSitelLnearChainDddress(playerSource: String, url: String) -> (Dictionary<String, Array<Dictionary<String, String>>>, Array<String>) {
        guard url.count > 0 else { return ([:], []) }
        /// 所有播放器数据
        var allPlayDict: Dictionary<String, Array<Dictionary<String, String>>> = [:]
        
        /// 存储所有播放源
        var playerSourceAry: Array<String> = []

        if url.contains("$$$") == true { // 存在多个播放源
            // 获取所有播放源名称
            playerSourceAry = playerSource.components(separatedBy: "$$$")
            
            let playSourceDataAry = url.components(separatedBy: "$$$")
            // 遍历所有播放源
            for (index, playSourceData) in playSourceDataAry.enumerated() {
                guard playSourceData.isEmpty == false else {
                    continue
                }
                // 获取播放器名称
                let playerSourceName = playerSourceAry[index]
                /// 存储当前播放器的所有剧集
                var playerSourceAppEpisodeAry: Array<Dictionary<String, String>> = []
                // 判断是否存在多集
                if playSourceData.contains("#") == true { // 多集
                    // 所有剧集数组
                    let playSourceSeriesAry = playSourceData.components(separatedBy: "#")
                    // 取出每一集标题和地址
                    for playSourceSeries in playSourceSeriesAry {
                        var seriesDict: Dictionary<String, String> = [:]
                        let titleAndUrlAry = playSourceSeries.components(separatedBy: "$")
                        seriesDict[titleAndUrlAry.first!] = titleAndUrlAry.last
                        playerSourceAppEpisodeAry.append(seriesDict)
                    }
                } else { // 单集
                    var seriesDict: Dictionary<String, String> = [:]
                    let titleAndUrlAry = playSourceData.components(separatedBy: "$")
                    seriesDict[titleAndUrlAry.first!] = titleAndUrlAry.last
                    playerSourceAppEpisodeAry.append(seriesDict)
                }
                allPlayDict[playerSourceName] = playerSourceAppEpisodeAry
            }
        } else { // 只有单个播放源
            playerSourceAry.append(playerSource)
            /// 存储当前播放器的所有剧集
            var playerSourceAppEpisodeAry: Array<Dictionary<String, String>> = []
            // 判断是否存在多集
            if url.contains("#") == true { // 多集
                // 所有剧集数组
                let playSourceSeriesAry = url.components(separatedBy: "#")
                // 取出每一集标题和地址
                for playSourceSeries in playSourceSeriesAry {
                    var seriesDict: Dictionary<String, String> = [:]
                    let titleAndUrlAry = playSourceSeries.components(separatedBy: "$")
                    seriesDict[titleAndUrlAry.first!] = titleAndUrlAry.last
                    playerSourceAppEpisodeAry.append(seriesDict)
                }
            } else { // 单集
                var seriesDict: Dictionary<String, String> = [:]
                let titleAndUrlAry = url.components(separatedBy: "$")
                seriesDict[titleAndUrlAry.first!] = titleAndUrlAry.last
                playerSourceAppEpisodeAry.append(seriesDict)
            }
            allPlayDict[playerSource] = playerSourceAppEpisodeAry
        }
        return (allPlayDict, playerSourceAry)
    }
    
//    class func passLnearChain
}
