//
//  BookReadModel.swift
//  Random
//
//  Created by yu mingming on 2020/6/9.
//  Copyright © 2020 刘超正. All rights reserved.
//

import Foundation

/// 阅读模型
class BookReadModel: NSObject, NSCoding {
    
    func encode(with coder: NSCoder) {
        coder.encode(browseTime, forKey: "browseTime")
        coder.encode(bookName, forKey: "bookName")
        coder.encode(bookImageUrl, forKey: "bookImageUrl")
        coder.encode(bookAuthor, forKey: "bookAuthor")
        coder.encode(bookIntroduction, forKey: "bookIntroduction")
        coder.encode(bookDetailUrl, forKey: "bookDetailUrl")
        coder.encode(bookCategory, forKey: "bookCategory")
        coder.encode(bookLatestChapter, forKey: "bookLatestChapter")
        coder.encode(bookSerialState, forKey: "bookSerialState")
        coder.encode(bookReadChapter, forKey: "bookReadChapter")
        coder.encode(bookRecommendRead, forKey: "bookRecommendRead")
        coder.encode(bookLastReadChapterIndex, forKey: "bookLastReadChapterIndex")
        coder.encode(bookReadParsingRule, forKey: "bookReadParsingRule")
        coder.encode(bookLastReadChapterPagingIndex, forKey: "bookLastReadChapterPagingIndex")
        coder.encode(bookReadRecordModel, forKey: "bookReadRecordModel")
        coder.encode(bookReadChapterSortState, forKey: "bookReadChapterSortState")
    }
    
    required init?(coder: NSCoder) {
//        familyName = coder.decodeObject(forKey: "familyName") as? String
        browseTime = coder.decodeObject(forKey: "browseTime") as? String
        bookName = coder.decodeObject(forKey: "bookName") as? String
        bookImageUrl = coder.decodeObject(forKey: "bookImageUrl") as? String
        bookAuthor = coder.decodeObject(forKey: "bookAuthor") as? String
        bookIntroduction = coder.decodeObject(forKey: "bookIntroduction") as? String
        bookDetailUrl = coder.decodeObject(forKey: "bookDetailUrl") as? String
        bookCategory = coder.decodeObject(forKey: "bookCategory") as? String
        bookLatestChapter = coder.decodeObject(forKey: "bookLatestChapter") as? String
        bookSerialState = coder.decodeObject(forKey: "bookSerialState") as? String
        bookReadChapter = coder.decodeObject(forKey: "bookReadChapter") as? Array<BookReadChapterModel>
        bookRecommendRead = coder.decodeObject(forKey: "bookRecommendRead") as? Array<BookReadModel>
        bookLastReadChapterIndex = coder.decodeObject(forKey: "bookLastReadChapterIndex") as? Int
        bookReadParsingRule = coder.decodeObject(forKey: "bookReadParsingRule") as? ReadShadowBookRuleResourceModel
        bookLastReadChapterPagingIndex = coder.decodeObject(forKey: "bookLastReadChapterPagingIndex") as? Int
        bookReadRecordModel = coder.decodeObject(forKey: "bookReadRecordModel") as? BookReadRecordModel
        bookReadChapterSortState = coder.decodeObject(forKey: "bookReadChapterSortState") as? String
    }
    
    override init() { }
    
    /// 书名
    var bookName: String?
    
    /// 书图片地址
    var bookImageUrl: String?
    
    /// 作者
    var bookAuthor: String?
    
    /// 简介
    var bookIntroduction: String?
    
    /// 书详情地址
    var bookDetailUrl: String?
    
    /// 书类别
    var bookCategory: String?
    
    /// 最新章节名称
    var bookLatestChapter: String?
    
    /// 连载状态
    var bookSerialState: String?
    
    /// 所有章节模型
    var bookReadChapter: Array<BookReadChapterModel>?
    
    /// 推荐阅读模型
    var bookRecommendRead: Array<BookReadModel>?
    
    /// 最后阅读章节索引
    var bookLastReadChapterIndex: Int?
    
    /// 书源规则
    var bookReadParsingRule: ReadShadowBookRuleResourceModel?
    
    /// 浏览时间
    var browseTime: String?
    
    /// 阅读记录
    var bookReadRecordModel: BookReadRecordModel?
    
    /// 最后阅读章节分页索引
    var bookLastReadChapterPagingIndex: Int?
    
    /// 排序状态 默认是正序 0:正序 1:倒叙
    var bookReadChapterSortState: String?
    
 
}
