//
//  File.swift
//  Random
//
//  Created by yu mingming on 2020/7/20.
//  Copyright © 2020 刘超正. All rights reserved.
//  直链视频解析模型

import Foundation

class StraightChainVideoAnalysisModel : NSObject, NSCoding, Mappable{

    var code : Int?
    var player : String?
    var success : Int?
    var type : String?
    var url : String?


    class func newInstance(map: Map) -> Mappable?{
        return StraightChainVideoAnalysisModel()
    }
    required init?(map: Map){}
    private override init(){}

    func mapping(map: Map)
    {
        code <- map["code"]
        player <- map["player"]
        success <- map["success"]
        type <- map["type"]
        url <- map["url"]
        
    }

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
    {
         code = aDecoder.decodeObject(forKey: "code") as? Int
         player = aDecoder.decodeObject(forKey: "player") as? String
         success = aDecoder.decodeObject(forKey: "success") as? Int
         type = aDecoder.decodeObject(forKey: "type") as? String
         url = aDecoder.decodeObject(forKey: "url") as? String

    }

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc func encode(with aCoder: NSCoder)
    {
        if code != nil{
            aCoder.encode(code, forKey: "code")
        }
        if player != nil{
            aCoder.encode(player, forKey: "player")
        }
        if success != nil{
            aCoder.encode(success, forKey: "success")
        }
        if type != nil{
            aCoder.encode(type, forKey: "type")
        }
        if url != nil{
            aCoder.encode(url, forKey: "url")
        }

    }

}
