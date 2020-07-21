//
//  File.swift
//  Random
//
//  Created by yu mingming on 2020/7/21.
//  Copyright © 2020 刘超正. All rights reserved.
//

import Foundation

class AppleCmsDetailsRootModel : NSObject, NSCoding, Mappable{

    var code : Int?
    var limit : String?
    var list : [ReadShadowVideoModel]?
    var msg : String?
    var page : Int?
    var pagecount : Int?
    var total : Int?
//    var category


    class func newInstance(map: Map) -> Mappable?{
        return AppleCmsDetailsRootModel()
    }
    required init?(map: Map){}
    private override init(){}

    func mapping(map: Map)
    {
        code <- map["code"]
        limit <- map["limit"]
        list <- map["list"]
        msg <- map["msg"]
        page <- map["page"]
        pagecount <- map["pagecount"]
        total <- map["total"]
        
    }

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
    {
         code = aDecoder.decodeObject(forKey: "code") as? Int
         limit = aDecoder.decodeObject(forKey: "limit") as? String
         list = aDecoder.decodeObject(forKey: "list") as? [ReadShadowVideoModel]
         msg = aDecoder.decodeObject(forKey: "msg") as? String
         page = aDecoder.decodeObject(forKey: "page") as? Int
         pagecount = aDecoder.decodeObject(forKey: "pagecount") as? Int
         total = aDecoder.decodeObject(forKey: "total") as? Int

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
        if limit != nil{
            aCoder.encode(limit, forKey: "limit")
        }
        if list != nil{
            aCoder.encode(list, forKey: "list")
        }
        if msg != nil{
            aCoder.encode(msg, forKey: "msg")
        }
        if page != nil{
            aCoder.encode(page, forKey: "page")
        }
        if pagecount != nil{
            aCoder.encode(pagecount, forKey: "pagecount")
        }
        if total != nil{
            aCoder.encode(total, forKey: "total")
        }

    }

}
