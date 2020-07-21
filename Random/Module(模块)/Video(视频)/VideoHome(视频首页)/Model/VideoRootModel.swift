//
//  File.swift
//  Random
//
//  Created by yu mingming on 2019/11/8.
//  Copyright © 2019 刘超正. All rights reserved.
//

import Foundation

class VideoRootModel : NSObject, NSCoding, Mappable{

    var data : [VideoDataModel]?
    var list : [ReadShadowVideoCategoryModel]?
    var page : VideoPageModel?
    var status : Int?


    class func newInstance(map: Map) -> Mappable?{
        return VideoRootModel()
    }
    required init?(map: Map){}
    private override init(){}

    func mapping(map: Map)
    {
        data <- map["data"]
        list <- map["list"]
        page <- map["page"]
        status <- map["status"]
        
    }

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
    {
         data = aDecoder.decodeObject(forKey: "data") as? [VideoDataModel]
         list = aDecoder.decodeObject(forKey: "list") as? [ReadShadowVideoCategoryModel]
         page = aDecoder.decodeObject(forKey: "page") as? VideoPageModel
         status = aDecoder.decodeObject(forKey: "status") as? Int

    }

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc func encode(with aCoder: NSCoder)
    {
        if data != nil{
            aCoder.encode(data, forKey: "data")
        }
        if list != nil{
            aCoder.encode(list, forKey: "list")
        }
        if page != nil{
            aCoder.encode(page, forKey: "page")
        }
        if status != nil{
            aCoder.encode(status, forKey: "status")
        }

    }

}
