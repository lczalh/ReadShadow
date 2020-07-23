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
    
    // MARK: - ac=list/detail ids=数据ID，多个ID逗号分割。 t=类别ID pg=页码 wd=搜索关键字 h=几小时内的数据
    case getAppleCmsVideoListData(baseUrl: String, path: String, ac: String, ids: Int?, t: Int?, pg: Int?, wd: String?, h: Int?)
    
    
    
    /*
     获取视频数据
     baseUrl: 基础地址
     path: 路径
     downloadPath: 下载路径
     ac: 直链资源必填 ac=list(获取分类) / detail
     categoryId： 分类id
     pg: 页码
     wd：搜索
     */
    case getReadShadowVideoData(baseUrl: String, path: String, ac: String?, categoryId: Any?, pg: Int?, wd: String?)

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
        case .getAppleCmsVideoListData(let baseUrl, _, _, _, _, _, _, _):
            return URL(string: baseUrl) ?? URL(string: "https://www.baidu.com")!
        case .getReadShadowVideoData(let baseUrl, _, _, _, _, _):
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
        case .getAppleCmsVideoListData(_, let path, _, _, _, _, _, _):
            return path
        case .getReadShadowVideoData(_, let path, _, _, _, _):
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
        case .getAppleCmsVideoListData(_, _, let ac, let ids, let t, let pg, let wd, let h):
            parameterDict["ac"] = ac
            parameterDict["ids"] = ids
            parameterDict["t"] = t
            parameterDict["pg"] = pg
            parameterDict["wd"] = wd
            parameterDict["h"] = h
            break
        case .getReadShadowVideoData(_, let path, let ac, let categoryId, let pg, let wd):
            if path == "/api.php/provide/vod" {
                parameterDict["ac"] = ac
                parameterDict["pg"] = pg
                parameterDict["wd"] = wd
                parameterDict["t"] = categoryId as? Int
            } else {
                parameterDict["wd"] = wd
                parameterDict["p"] = pg
                parameterDict["cid"] = "\(categoryId ?? 0)"
            }
            break
        }
        return  .requestParameters(parameters: parameterDict, encoding: URLEncoding.default)
    }
    
    
    //请求头
    public var headers: [String : String]? {
        return nil
    }
    
    
}
