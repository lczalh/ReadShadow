//
//  HighSpeedDataApi.swift
//  Random
//
//  Created by yu mingming on 2019/10/18.
//  Copyright © 2019 刘超正. All rights reserved.
//

import Foundation

/// 定义分类
public enum HighSpeedDataApi {
    
    // MARK: - 获取新闻数据
    case getNewsList(appkey: String, channel: String, num: Int, start: Int)
    
    // MARK: - 获取所有新闻类型数据
    case getNewsTypeList(appkey: String)
    
    // MARK: - 查询快递物流信息
    case getLogisticsDetails(appkey: String, type: String, number: String)
    
    // MARK: - 查询快递公司
    case getCourierCompany(appkey: String)
    
    // MARK: - 查询新闻
    case searchNews(appkey: String, keyword: String)
    
    // MARK: - 笑话
    case getJokeList(appkey: String, pagenum: Int, pagesize: Int, sort: String)
 
}

//设置请求配置
extension HighSpeedDataApi : TargetType {
    
    //服务器地址
    public var baseURL: URL {
        return URL(string:"https://api.jisuapi.com")!
    }
    
    //各个请求的具体路径
    public var path: String {
        
        switch self {
            
        case .getNewsList:
            return "/news/get"
        case .getNewsTypeList:
            return "/news/channel"
        case .getLogisticsDetails:
            return "/express/query"
        case .getCourierCompany:
            return "/express/type"
        case .searchNews:
            return "/news/search"
        case .getJokeList:
            return "/xiaohua/all"
        }
        
    }
    
    //请求类型
    public var method: Moya.Method {
        return .post
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
        case .getNewsTypeList(let appkey):
            parameterDict["appkey"] = appkey
            break
        case .getNewsList(let appkey, let channel, let num, let start):
            parameterDict["appkey"] = appkey
            parameterDict["channel"] = channel
            parameterDict["num"] = num
            parameterDict["start"] = start
            break
        case .getLogisticsDetails(let appkey, let type, let number):
            parameterDict["appkey"] = appkey
            parameterDict["type"] = type
            parameterDict["number"] = number
            break
        case .getCourierCompany(let appkey):
            parameterDict["appkey"] = appkey
            break
        case .searchNews(let appkey, let keyword):
            parameterDict["appkey"] = appkey
            parameterDict["keyword"] = keyword
            break
        case .getJokeList(let appkey, let pagenum, let pagesize, let sort):
            parameterDict["appkey"] = appkey
            parameterDict["pagenum"] = pagenum
            parameterDict["pagesize"] = pagesize
            parameterDict["sort"] = sort
            break
        }
        return  .requestParameters(parameters: parameterDict, encoding: URLEncoding.default)
    }
    
    
    //请求头
    public var headers: [String : String]? {
        return nil
    }
    
    
}
