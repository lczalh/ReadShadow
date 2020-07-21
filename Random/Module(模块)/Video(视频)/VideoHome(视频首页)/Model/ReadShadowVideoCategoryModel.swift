//
//  File.swift
//  Random
//
//  Created by yu mingming on 2020/7/21.
//  Copyright © 2020 刘超正. All rights reserved.
//

import Foundation

class ReadShadowVideoCategoryModel : NSObject, NSCoding, Mappable{
    
    /// 分类id
    var categoryId : Int?
    
    /// 分类名
    var categoryName : String?


    class func newInstance(map: Map) -> Mappable?{
        return ReadShadowVideoCategoryModel()
    }
    required init?(map: Map){}
    private override init(){}

    func mapping(map: Map)
    {
        categoryId <- map["type_id"]
        categoryId <- map["list_id"]

        categoryName <- map["list_name"]
        categoryName <- map["type_name"]
        
    }

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
    {
         categoryId = aDecoder.decodeObject(forKey: "categoryId") as? Int
         categoryName = aDecoder.decodeObject(forKey: "categoryName") as? String

    }

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc func encode(with aCoder: NSCoder)
    {
        if categoryId != nil{
            aCoder.encode(categoryId, forKey: "categoryId")
        }
        if categoryName != nil{
            aCoder.encode(categoryName, forKey: "categoryName")
        }

    }

}
