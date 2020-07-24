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
  //  var page : VideoPageModel?
//    var code : Int?


    class func newInstance(map: Map) -> Mappable?{
        return ReadShadowVideoRootModel()
    }
    required init?(map: Map){}
    private override init(){}

    func mapping(map: Map)
    {
        if data == nil || data?.isEmpty == true {
            data <- map["data"]
            category <- map["list"]
        }
        if data == nil || data?.isEmpty == true {
            data <- map["list"]
            category <- map["class"]
        }
        
//        if category == nil || category?.isEmpty == true {
//            category <- map["list"]
//        }
        
//        if code == nil {
//            code <- map["status"]
//        }
//        if code == nil {
//            code <- map["code"]
//        }
        
    }

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
    {
         data = aDecoder.decodeObject(forKey: "data") as? [ReadShadowVideoModel]
         category = aDecoder.decodeObject(forKey: "list") as? [ReadShadowVideoCategoryModel]
//         page = aDecoder.decodeObject(forKey: "page") as? VideoPageModel
//         code = aDecoder.decodeObject(forKey: "status") as? Int

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
//        if page != nil{
//            aCoder.encode(page, forKey: "page")
//        }
//        if code != nil{
//            aCoder.encode(code, forKey: "status")
//        }

    }

}
