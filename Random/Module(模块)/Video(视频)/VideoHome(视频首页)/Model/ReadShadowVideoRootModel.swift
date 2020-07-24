//
//  File.swift
//  Random
//
//  Created by yu mingming on 2020/7/21.
//  Copyright © 2020 刘超正. All rights reserved.
//

import Foundation

class ReadShadowVideoRootModel : NSObject, NSCoding, Mappable{

    var data : [ReadShadowVideoModel]?
    var category : [ReadShadowVideoCategoryModel]?


    class func newInstance(map: Map) -> Mappable?{
        return ReadShadowVideoRootModel()
    }
    required init?(map: Map){}
    private override init(){}

    func mapping(map: Map)
    {
        if data == nil {
            data <- map["data"]
            category <- map["list"]
        }
        if data == nil {
            data <- map["list"]
            category <- map["class"]
        }
        
    }

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
    {
         data = aDecoder.decodeObject(forKey: "data") as? [ReadShadowVideoModel]
         category = aDecoder.decodeObject(forKey: "list") as? [ReadShadowVideoCategoryModel]

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
        if category != nil{
            aCoder.encode(category, forKey: "list")
        }

    }

}
