//
//  File.swift
//  Random
//
//  Created by yu mingming on 2020/7/8.
//  Copyright © 2020 刘超正. All rights reserved.
//

import Foundation

class ReadShadowBasicConfigModel : NSObject, NSCoding, Mappable{
    
    /// 状态
    var state : String?
    /// 版本
    var version : String?


    class func newInstance(map: Map) -> Mappable?{
        return ReadShadowBasicConfigModel()
    }
    required init?(map: Map){}
    private override init(){}

    func mapping(map: Map)
    {
        state <- map["state"]
        version <- map["version"]
        
    }

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
    {
         state = aDecoder.decodeObject(forKey: "state") as? String
         version = aDecoder.decodeObject(forKey: "version") as? String

    }

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc func encode(with aCoder: NSCoder)
    {
        if state != nil{
            aCoder.encode(state, forKey: "state")
        }
        if version != nil{
            aCoder.encode(version, forKey: "version")
        }

    }

}
