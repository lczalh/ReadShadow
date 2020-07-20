//
//  VideoDataApi.swift
//  Random
//
//  Created by yu mingming on 2019/11/8.
//  Copyright © 2019 刘超正. All rights reserved.
//
/*
 
 VideoResourceModel(name: "酷云资源", address: "http://caiji.kuyun98.com", allDataPath: "/inc/s_feifeikkm3u8", downloadDataPath: "/inc/feifei3down"),
  VideoResourceModel(name: "OK资源", address: "https://cj.okzy.tv", allDataPath: "/inc/feifei3ckm3u8s", downloadDataPath: "/inc/feifei3down"),
  VideoResourceModel(name: "最大资源", address: "http://www.zdziyuan.com", allDataPath: "/inc/s_feifei3zuidam3u8", downloadDataPath: "/inc/feifeidown"),
  VideoResourceModel(name: "酷播资源(无下载)", address: "http://api.kbzyapi.com", allDataPath: "/inc/s_feifei3.4", downloadDataPath: ""),
  VideoResourceModel(name: "最新资源(无下载)", address: "http://api.zuixinapi.com", allDataPath: "/inc/feifei3", downloadDataPath: ""),
  VideoResourceModel(name: "卧龙云资源(无下载)", address: "https://cj.wlzy.tv", allDataPath: "/api/ffs/vod", downloadDataPath: ""),
 // VideoResourceModel(name: "高清云资源(无下载)", address: "http://cj.gaoqingzyw.com", allDataPath: "/inc/feifei3", downloadDataPath: ""),
  VideoResourceModel(name: "135资源(无下载)", address: "http://cj.zycjw1.com", allDataPath: "/inc/feifei3", downloadDataPath: ""),
  VideoResourceModel(name: "永久云资源(无下载)", address: "http://www.yongjiuzy1.com", allDataPath: "/inc/s_feifei3", downloadDataPath: ""),
  VideoResourceModel(name: "麻花云资源(无下载)", address: "https://www.mhapi123.com", allDataPath: "/inc/feifei3", downloadDataPath: "")
 
 */

import Foundation

/// 定义分类
public enum VideoDataApi {
    
    // MARK: - 获取视频数据 wd: 搜索内容, p: 页码, cid: 类别
    case getVideoData(baseUrl: String, path: String, wd: String?, p: Int?, cid: String?)
    
    // MARK: - 获取视频下载数据 wd: 搜索内容, p: 页码, cid: 类别
    case getVideoDownData(baseUrl: String, downloadPath: String, wd: String?, p: Int?, cid: String?)
    
    // MARK: - 直链视频解析
    case straightChainVideoAnalysis(baseUrl: String, path: String, url: String)
}

//设置请求配置
extension VideoDataApi : TargetType {
    
    //服务器地址
    public var baseURL: URL {
        switch self {
        case .getVideoData(let baseUrl, _, _, _, _):
            return URL(string: baseUrl) ?? URL(string: "https://www.baidu.com")!
        case .getVideoDownData(let baseUrl, _, _, _, _):
            return URL(string: baseUrl) ?? URL(string: "https://www.baidu.com")!
        case .straightChainVideoAnalysis(let baseUrl, _, _):
            return URL(string: baseUrl) ?? URL(string: "https://www.baidu.com")!
        }
    }
    
    //各个请求的具体路径
    public var path: String {
        
        switch self {
        case .getVideoData(_, let path, _, _, _):
            return path
        case .getVideoDownData(_, let downloadPath, _, _, _):
            return downloadPath
        case .straightChainVideoAnalysis(_, let path, _):
            return path
        }
        
    }
    
    //请求类型
    public var method: Moya.Method {
        return .get
    }
    
    //这个就是做单元测试模拟的数据，只会在单元测试文件中有作用
    public var sampleData: Data {
        return "".data(using: String.Encoding.utf8)!
    }
    
    //请求任务事件
    public var task: Task {
        // 请求通用参数
        var parameterDict: [String : Any] = Dictionary()
        switch self {
        case .getVideoData(_, _, let wd, let p, let cid):
            parameterDict["wd"] = wd
            parameterDict["p"] = p
            parameterDict["cid"] = cid
            break
        case .getVideoDownData(_, _, let wd, let p, let cid):
            parameterDict["wd"] = wd
            parameterDict["p"] = p
            parameterDict["cid"] = cid
            break
        case .straightChainVideoAnalysis(_, _, let url):
            parameterDict["url"] = url
            break
        }
        return  .requestParameters(parameters: parameterDict, encoding: URLEncoding.default)
    }
    
    
    //请求头
    public var headers: [String : String]? {
        return nil
    }
    
    
}
