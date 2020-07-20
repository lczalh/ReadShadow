//
//  VideoSourceModel.swift
//  Random
//
//  Created by yu mingming on 2020/6/24.
//  Copyright © 2020 刘超正. All rights reserved.
//

import UIKit

class VideoSourceModel: NSObject, NSCoding {
    /// 资源站名称
    var name: String?
    
    /// 地址
    var address: String?
    
    /// 所有资源路径
    var allDataPath: String?
    
    /// 可下载资源路径
    var downloadDataPath: String?
    
    init(name: String?, address: String?, allDataPath: String?, downloadDataPath: String?) {
        self.name = name
        self.address = address
        self.allDataPath = allDataPath
        self.downloadDataPath = downloadDataPath
    }
    
    override init() {
        
    }
    
    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
    {
         name = aDecoder.decodeObject(forKey: "name") as? String
         address = aDecoder.decodeObject(forKey: "address") as? String
         allDataPath = aDecoder.decodeObject(forKey: "allDataPath") as? String
         downloadDataPath = aDecoder.decodeObject(forKey: "downloadDataPath") as? String
    }

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc func encode(with aCoder: NSCoder)
    {
        if name != nil{
            aCoder.encode(name, forKey: "name")
        }
        if address != nil{
            aCoder.encode(address, forKey: "address")
        }
        if allDataPath != nil{
            aCoder.encode(allDataPath, forKey: "allDataPath")
        }
        if downloadDataPath != nil{
            aCoder.encode(downloadDataPath, forKey: "downloadDataPath")
        }
    }

}
