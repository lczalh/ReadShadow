//
//  File.swift
//  Random
//
//  Created by yu mingming on 2020/7/8.
//  Copyright © 2020 刘超正. All rights reserved.
//

import Foundation

class ReadShadowRootModel : NSObject, NSCoding, Mappable{
    
    /// 书源规则资源
    var bookRuleResources : [ReadShadowBookRuleResourceModel]?
    /// 基础配置模型
    var basicConfig : [ReadShadowBasicConfigModel]?
    /// 电视资源
    var televisionResource : String?
    /// 视频过滤分类
    var videoFilterCategorys : [String]?
    /// 视频资源
    var videoResources : [ReadShadowVideoResourceModel]?


    class func newInstance(map: Map) -> Mappable?{
        return ReadShadowRootModel()
    }
    required init?(map: Map){}
    private override init(){}

    func mapping(map: Map)
    {
        bookRuleResources <- map["bookRuleResources"]
        basicConfig <- map["basicConfig"]
        televisionResource <- map["televisionResource"]
        videoFilterCategorys <- map["videoFilterCategorys"]
        videoResources <- map["videoResources"]
        
    }

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
    {
         bookRuleResources = aDecoder.decodeObject(forKey: "bookRuleResources") as? [ReadShadowBookRuleResourceModel]
         basicConfig = aDecoder.decodeObject(forKey: "basicConfig") as? [ReadShadowBasicConfigModel]
         televisionResource = aDecoder.decodeObject(forKey: "televisionResource") as? String
         videoFilterCategorys = aDecoder.decodeObject(forKey: "videoFilterCategorys") as? [String]
         videoResources = aDecoder.decodeObject(forKey: "videoResources") as? [ReadShadowVideoResourceModel]

    }

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc func encode(with aCoder: NSCoder)
    {
        if bookRuleResources != nil{
            aCoder.encode(bookRuleResources, forKey: "bookRuleResources")
        }
        if basicConfig != nil{
            aCoder.encode(basicConfig, forKey: "basicConfig")
        }
        if televisionResource != nil{
            aCoder.encode(televisionResource, forKey: "televisionResource")
        }
        if videoFilterCategorys != nil{
            aCoder.encode(videoFilterCategorys, forKey: "videoFilterCategorys")
        }
        if videoResources != nil{
            aCoder.encode(videoResources, forKey: "videoResources")
        }

    }

}
