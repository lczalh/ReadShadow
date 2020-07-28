//
//  File.swift
//  Random
//
//  Created by yu mingming on 2020/6/10.
//  Copyright © 2020 刘超正. All rights reserved.
//

import Foundation

/// 章节模型
class BookReadChapterModel: NSObject, NSCoding {
    
    /// 章节名称
    var chapterName: String?
    
    /// 章节内容
    var chapterContent: String?
    
    /// 章节地址
    var chapterUrl: String?
    
    /// 章节分页模型
    var chapterPaging: Array<BookReadChapterPagingModel>?
    
    
    func encode(with coder: NSCoder) {
        coder.encode(chapterName, forKey: "chapterName")
        coder.encode(chapterContent, forKey: "chapterContent")
        coder.encode(chapterUrl, forKey: "chapterUrl")
        coder.encode(chapterPaging, forKey: "chapterPaging")
    }
    
    required init?(coder: NSCoder) {
        chapterName = coder.decodeObject(forKey: "chapterName") as? String
        chapterContent = coder.decodeObject(forKey: "chapterContent") as? String
        chapterUrl = coder.decodeObject(forKey: "chapterUrl") as? String
        chapterPaging = coder.decodeObject(forKey: "chapterPaging") as? Array<BookReadChapterPagingModel>
    }
    
    override init() { }
}
