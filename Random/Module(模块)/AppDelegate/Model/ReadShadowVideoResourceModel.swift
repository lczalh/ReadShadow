//
//  File.swift
//  Random
//
//  Created by yu mingming on 2020/7/8.
//  Copyright © 2020 刘超正. All rights reserved.
//  影源模型

import Foundation

class ReadShadowVideoResourceModel : NSObject, NSCoding, Mappable{
    
    /// 基础地址
    var baseUrl : String?
    /// 下载路径
    var downloadPath : String?
    /// 名称
    var name : String?
    /// 路径
    var path : String?
    
    /// 资源类型 0: 飞飞3.4    1.苹果CMS
    var type: String?


    class func newInstance(map: Map) -> Mappable?{
        return ReadShadowVideoResourceModel()
    }
    required init?(map: Map){}
    override init(){}

    func mapping(map: Map)
    {
        baseUrl <- map["baseUrl"]
        downloadPath <- map["downloadPath"]
        name <- map["name"]
        path <- map["path"]
        type <- map["type"]
    }

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
    {
         baseUrl = aDecoder.decodeObject(forKey: "baseUrl") as? String
         downloadPath = aDecoder.decodeObject(forKey: "downloadPath") as? String
         name = aDecoder.decodeObject(forKey: "name") as? String
         path = aDecoder.decodeObject(forKey: "path") as? String
         type = aDecoder.decodeObject(forKey: "type") as? String
    }

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc func encode(with aCoder: NSCoder)
    {
        if baseUrl != nil{
            aCoder.encode(baseUrl, forKey: "baseUrl")
        }
        if downloadPath != nil{
            aCoder.encode(downloadPath, forKey: "downloadPath")
        }
        if name != nil{
            aCoder.encode(name, forKey: "name")
        }
        if path != nil{
            aCoder.encode(path, forKey: "path")
        }
        if type != nil{
            aCoder.encode(type, forKey: "type")
        }
    }

}
