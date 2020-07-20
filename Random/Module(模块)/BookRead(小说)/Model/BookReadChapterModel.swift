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
    
//    /// 上一章章节索引 没有为nil
//    var beforeChapterIndex: Int?
//
//    /// 下一章章节索引 没有为nil
//    var afterChapterIndex: Int?
    
    func encode(with coder: NSCoder) {
        coder.encode(chapterName, forKey: "chapterName")
        coder.encode(chapterContent, forKey: "chapterContent")
        coder.encode(chapterUrl, forKey: "chapterUrl")
        coder.encode(chapterPaging, forKey: "chapterPaging")
        
//        coder.encode(beforeChapterIndex, forKey: "beforeChapterIndex")
//        coder.encode(afterChapterIndex, forKey: "afterChapterIndex")
    }
    
    required init?(coder: NSCoder) {
        chapterName = coder.decodeObject(forKey: "chapterName") as? String
        chapterContent = coder.decodeObject(forKey: "chapterContent") as? String
        chapterUrl = coder.decodeObject(forKey: "chapterUrl") as? String
        chapterPaging = coder.decodeObject(forKey: "chapterPaging") as? Array<BookReadChapterPagingModel>
        
//        beforeChapterIndex = coder.decodeObject(forKey: "beforeChapterIndex") as? Int
//        afterChapterIndex = coder.decodeObject(forKey: "afterChapterIndex") as? Int
    }
    
    override init() { }
}
