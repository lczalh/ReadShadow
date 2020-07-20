//
//  VideoPageModel.swift
//  Random
//
//  Created by yu mingming on 2019/11/8.
//  Copyright © 2019 刘超正. All rights reserved.
//

import Foundation

class VideoPageModel : NSObject, NSCoding, Mappable{
    
    /// 总页码
    var pagecount : String?
    
    /// 当前页码
    var pageindex : String?
    
    /// 每页数量
    var pagesize : String?
    
    /// 总资源
    var recordcount : String?


    class func newInstance(map: Map) -> Mappable?{
        return VideoPageModel()
    }
    required init?(map: Map){}
    private override init(){}

    func mapping(map: Map)
    {
        pagecount <- map["pagecount"]
        pageindex <- map["pageindex"]
        pagesize <- map["pagesize"]
        recordcount <- map["recordcount"]
        
    }

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
    {
         pagecount = aDecoder.decodeObject(forKey: "pagecount") as? String
         pageindex = aDecoder.decodeObject(forKey: "pageindex") as? String
         pagesize = aDecoder.decodeObject(forKey: "pagesize") as? String
         recordcount = aDecoder.decodeObject(forKey: "recordcount") as? String

    }

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc func encode(with aCoder: NSCoder)
    {
        if pagecount != nil{
            aCoder.encode(pagecount, forKey: "pagecount")
        }
        if pageindex != nil{
            aCoder.encode(pageindex, forKey: "pageindex")
        }
        if pagesize != nil{
            aCoder.encode(pagesize, forKey: "pagesize")
        }
        if recordcount != nil{
            aCoder.encode(recordcount, forKey: "recordcount")
        }

    }

}
