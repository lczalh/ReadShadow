//
//  VideoListModel.swift
//  Random
//
//  Created by yu mingming on 2019/11/8.
//  Copyright © 2019 刘超正. All rights reserved.
//  分类模型

import Foundation

class VideoListModel : NSObject, NSCoding, Mappable{
    
    /// 分类id
    var listId : Int?
    
    /// 分类名
    var listName : String?


    class func newInstance(map: Map) -> Mappable?{
        return VideoListModel()
    }
    required init?(map: Map){}
    private override init(){}

    func mapping(map: Map)
    {
       // listId <- map["type_id"]
        listId <- map["list_id"]

        listName <- map["list_name"]
      //  listName <- map["type_name"]
        
    }

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
    {
         listId = aDecoder.decodeObject(forKey: "list_id") as? Int
         listName = aDecoder.decodeObject(forKey: "list_name") as? String

    }

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc func encode(with aCoder: NSCoder)
    {
        if listId != nil{
            aCoder.encode(listId, forKey: "list_id")
        }
        if listName != nil{
            aCoder.encode(listName, forKey: "list_name")
        }

    }

}
