//
//  File.swift
//  Random
//
//  Created by yu mingming on 2020/7/8.
//  Copyright © 2020 刘超正. All rights reserved.
//

import Foundation

class TelevisionRootModel : NSObject, NSCoding, Mappable{

    var category : String?
    var country : TelevisionCountryModel?
    var language : [TelevisionCountryModel]?
    var logo : String?
    var name : String?
    var tvg : TelevisionTvgModel?
    var url : String?


    class func newInstance(map: Map) -> Mappable?{
        return TelevisionRootModel()
    }
    required init?(map: Map){}
    private override init(){}

    func mapping(map: Map)
    {
        category <- map["category"]
        country <- map["country"]
        language <- map["language"]
        logo <- map["logo"]
        name <- map["name"]
        tvg <- map["tvg"]
        url <- map["url"]
        
    }

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
    {
         category = aDecoder.decodeObject(forKey: "category") as? String
         country = aDecoder.decodeObject(forKey: "country") as? TelevisionCountryModel
         language = aDecoder.decodeObject(forKey: "language") as? [TelevisionCountryModel]
         logo = aDecoder.decodeObject(forKey: "logo") as? String
         name = aDecoder.decodeObject(forKey: "name") as? String
         tvg = aDecoder.decodeObject(forKey: "tvg") as? TelevisionTvgModel
         url = aDecoder.decodeObject(forKey: "url") as? String

    }

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc func encode(with aCoder: NSCoder)
    {
        if category != nil{
            aCoder.encode(category, forKey: "category")
        }
        if country != nil{
            aCoder.encode(country, forKey: "country")
        }
        if language != nil{
            aCoder.encode(language, forKey: "language")
        }
        if logo != nil{
            aCoder.encode(logo, forKey: "logo")
        }
        if name != nil{
            aCoder.encode(name, forKey: "name")
        }
        if tvg != nil{
            aCoder.encode(tvg, forKey: "tvg")
        }
        if url != nil{
            aCoder.encode(url, forKey: "url")
        }

    }

}
