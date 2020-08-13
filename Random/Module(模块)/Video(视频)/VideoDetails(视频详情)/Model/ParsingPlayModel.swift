//
//  File.swift
//  Random
//
//  Created by yu mingming on 2020/8/13.
//  Copyright © 2020 刘超正. All rights reserved.
//

import Foundation

class ParsingPlayModel : NSObject, NSCoding, Mappable{

    var code : String?
    var player : String?
    var success : String?
    var type : String?
    var url : String?


    class func newInstance(map: Map) -> Mappable?{
        return ParsingPlayModel()
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
         code = aDecoder.decodeObject(forKey: "code") as? String
         player = aDecoder.decodeObject(forKey: "player") as? String
         success = aDecoder.decodeObject(forKey: "success") as? String
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
