//
//  ParsingInterfaceModel.swift
//  Random
//
//  Created by yu mingming on 2020/7/24.
//  Copyright © 2020 刘超正. All rights reserved.
//

import UIKit

class ParsingInterfaceModel: NSObject, NSCoding {
    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
    {
         parsingName = aDecoder.decodeObject(forKey: "parsingName") as? String
         parsingInterface = aDecoder.decodeObject(forKey: "parsingInterface") as? String
    }

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc func encode(with aCoder: NSCoder)
    {
        if parsingName != nil{
            aCoder.encode(parsingName, forKey: "parsingName")
        }
        if parsingInterface != nil{
            aCoder.encode(parsingInterface, forKey: "parsingInterface")
        }
    }
    
    
    /// 解析名称
    var parsingName: String?
    
    /// 解析接口
    var parsingInterface: String?
    
    override init() { }
}
