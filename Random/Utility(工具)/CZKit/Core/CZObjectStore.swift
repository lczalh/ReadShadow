//
//  CZObjectWritePlist.swift
//  Random
//
//  Created by yu mingming on 2020/5/12.
//  Copyright © 2020 刘超正. All rights reserved.
//

import UIKit

class CZObjectStore: NSObject {
    static let standard = CZObjectStore()
    private override init() {}
    
    private let fileManager = FileManager()
    
    
    /// 将对象写入Plist文件
    /// - Parameters:
    ///   - object: 对象
    ///   - filePath: 文件路径
    ///   - key: 自定义key值
    /// - Returns: 是否成功写入
    public func cz_objectWritePlist(object: Any, filePath: String, key: String) -> Bool {
        let data = NSMutableData()
        //申明一个归档处理对象
        let archiver = NSKeyedArchiver(forWritingWith: data)
        //将lists以对应Checklist关键字进行编码
        archiver.encode(object, forKey: key)
        //编码结束
        archiver.finishEncoding()
        //数据写入
        return data.write(toFile: filePath, atomically: true)
    }
    
    /// 读取Plist文件中的对象
    /// - Parameters:
    ///   - filePath: 文件路径
    ///   - key: 自定义key值
    /// - Returns: 对象
    public func cz_readObjectInPlist(filePath: String, key: String) -> Any? {
        //通过文件地址判断数据文件是否存在
        if fileManager.fileExists(atPath: filePath) == false { // 不存在
            return nil
        } else {
            if let data = try? Data(contentsOf: URL(fileURLWithPath: filePath)) {
               //解码器
                let unarchiver = NSKeyedUnarchiver(forReadingWith: data)
                //通过归档时设置的关键字Checklist还原lists
                let resources = unarchiver.decodeObject(forKey: key)
                //结束解码
                unarchiver.finishDecoding()
                return resources
            }
            return nil
        }
    }
    
    /// 将对象写入偏好设置
    /// - Parameters:
    ///   - object: 对象
    ///   - key: 自定义key
    public func cz_objectWriteUserDefault(object: Any, key: String) {
        let data = NSKeyedArchiver.archivedData(withRootObject: object)
        UserDefaults.standard.set(data, forKey: key)
    }
    
    /// 读取偏好设置中的对象
    /// - Parameters:
    ///   - key: 自定义key
    /// - Returns: 对象
    public func cz_readObjectInUserDefault(key: String) -> Any? {
        if let data = UserDefaults.standard.data(forKey: key) {
            return NSKeyedUnarchiver.unarchiveObject(with: data)
        }
        return nil
    }
    
    
    /// 判断文件或文件夹是否存在
    /// - Parameter filePath: 文件路径
    /// - Returns: 是否存在
    public func cz_isFileExist(filePath: String) -> Bool {
        return fileManager.fileExists(atPath: filePath)
    }
    
    /// 创建文件夹
    /// - Parameter folderPath: 文件路径
    /// - Returns: 是否成功
    public func cz_createFolder(folderPath: String) -> Bool {
        if !cz_isFileExist(filePath: folderPath) {
            do {
                try fileManager.createDirectory(at: URL(fileURLWithPath: folderPath), withIntermediateDirectories: true,
                attributes: nil)
                return true
            } catch {
                return false
            }
        }
        return false
    }
    
    /// 数据归档
    /// - Parameters:
    ///   - object: 归档对象
    ///   - filePath: 文件路径
    /// - Returns: 是否成功
    public func cz_archiver(object: Any, filePath: String) -> Bool {
        return NSKeyedArchiver.archiveRootObject(object, toFile: filePath)
    }
    
    /// 数据解档
    /// - Parameter filePath: 文件路径
    /// - Returns: 解档对象
    public func cz_unarchiver(filePath: String) -> Any? {
        return NSKeyedUnarchiver.unarchiveObject(withFile: filePath)
    }
    
//    /// 获取文件夹中的所有文件/文件夹(不包含子文件)
//    public func cz_getShallowAllFilesInTheFolder() {
//        
//    }
    
    /// 删除文件或者文件夹
    /// - Parameter filePath: 文件路径
    /// - Returns: 是否成功
    public func cz_removeFileOrFolder(filePath: String) -> Bool {
        do {
            try FileManager().removeItem(atPath: filePath)
            return true
        } catch  {
            return false
        }
    }
}
