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
        if url.contains("$$$") == true {
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
}
