//
//  BookReadParsingRuleModel.swift
//  Random
//
//  Created by yu mingming on 2020/6/9.
//  Copyright © 2020 刘超正. All rights reserved.
//

import UIKit

enum BookReadEncoding: String {
    case utf8 = "utf8"
    case gbk = "gbk"
}

class BookReadParsingRuleModel: NSObject, NSCoding {
    
    /// 书源名称
    var bookSourceName: String?
    
    /// 书源地址
    var bookSourceUrl: String?
    
    /// 编码格式类型
    private var bookEncodingString: String?
    
    /// 编码格式类型
    var bookSearchEncoding: BookReadEncoding? {
        get {
            return BookReadEncoding(rawValue: bookEncodingString ?? "")
        }
        set {
            bookEncodingString = newValue?.rawValue ?? ""
        }
    }
    
    /// 书搜索地址
    var bookSearchUrl: String?
    
    /// 解析搜索列表中的书名规则
    var bookSearchListNameRule: String?
    
    /// 解析搜索列表中的详情地址规则
    var bookSearchListDetailUrlRule: String?
    
    /// 解析搜索列表中的最新章节名称
    var bookSearchListLatestChapterNameRule: String?
    
    /// 解析搜索列表中的类别名称规则
    var bookSearchListCategoryNameRule: String?
    
    /// 解析搜索列表中的连载状态规则
    var bookSearchListSerialStateRule: String?
    
    /// 解析详情中的书图片规则
    var bookDetailImageUrlRule: String?
    
    /// 解析详情中的类别名称规则
    var bookDetailCategoryNameRule: String?
    
    /// 解析详情中的作者规则
    var bookDetailAuthorRule: String?
    
    /// 解析详情中的简介规则
    var bookDetailIntroductionRule: String?
    
    /// 解析详情中的连载状态规则
    var bookDetailSerialStateRule: String?
    
    /// 解析详情中的章节列表页规则（部分书源的章节列表是单独的HTML）
    var bookChapterListPageUrlRule: String?
    
    /// 解析详情中的章节地址规则
    var bookChapterDetailUrlRule: String?
    
    /// 解析章节详情中的内容规则
    var bookChapterDetailContentRule: String?
    
    /// 解析章节详情中的内容下一页规则 （部分书源的章节内容是分页的）
    var bookChapterDetailNextPageContentUrlRule: String?
    
    /// 解析详情中的推荐阅读规则
    var bookDetailRecommendReadRule: String?
    
    func encode(with coder: NSCoder) {
        coder.encode(bookSourceName, forKey: "bookSourceName")
        coder.encode(bookSourceUrl, forKey: "bookSourceUrl")
        coder.encode(bookEncodingString, forKey: "bookEncodingString")
        coder.encode(bookSearchUrl, forKey: "bookSearchUrl")
        coder.encode(bookSearchListLatestChapterNameRule, forKey: "bookSearchListLatestChapterNameRule")
        coder.encode(bookSearchListNameRule, forKey: "bookSearchListNameRule")
        coder.encode(bookSearchListDetailUrlRule, forKey: "bookSearchListDetailUrlRule")
        coder.encode(bookDetailImageUrlRule, forKey: "bookDetailImageUrlRule")
        coder.encode(bookSearchListCategoryNameRule, forKey: "bookSearchListCategoryNameRule")
        coder.encode(bookDetailAuthorRule, forKey: "bookDetailAuthorRule")
        coder.encode(bookDetailIntroductionRule, forKey: "bookDetailIntroductionRule")
        coder.encode(bookChapterListPageUrlRule, forKey: "bookChapterListPageUrlRule")
        coder.encode(bookChapterDetailUrlRule, forKey: "bookChapterDetailUrlRule")
        coder.encode(bookChapterDetailContentRule, forKey: "bookChapterDetailContentRule")
        coder.encode(bookChapterDetailNextPageContentUrlRule, forKey: "bookChapterDetailNextPageContentUrlRule")
        coder.encode(bookSearchListSerialStateRule, forKey: "bookSearchListSerialStateRule")
        coder.encode(bookDetailRecommendReadRule, forKey: "bookDetailRecommendReadRule")
        coder.encode(bookDetailCategoryNameRule, forKey: "bookDetailCategoryNameRule")
        coder.encode(bookDetailSerialStateRule, forKey: "bookDetailSerialStateRule")
    }
    
    required init?(coder: NSCoder) {
        bookSourceName = coder.decodeObject(forKey: "bookSourceName") as? String
        bookSourceUrl = coder.decodeObject(forKey: "bookSourceUrl") as? String
        bookEncodingString = coder.decodeObject(forKey: "bookEncodingString") as? String
        bookSearchUrl = coder.decodeObject(forKey: "bookSearchUrl") as? String
        bookSearchListLatestChapterNameRule = coder.decodeObject(forKey: "bookSearchListLatestChapterNameRule") as? String
        bookSearchListNameRule = coder.decodeObject(forKey: "bookSearchListNameRule") as? String
        bookSearchListDetailUrlRule = coder.decodeObject(forKey: "bookSearchListDetailUrlRule") as? String
        bookDetailImageUrlRule = coder.decodeObject(forKey: "bookDetailImageUrlRule") as? String
        bookSearchListCategoryNameRule = coder.decodeObject(forKey: "bookSearchListCategoryNameRule") as? String
        bookDetailAuthorRule = coder.decodeObject(forKey: "bookDetailAuthorRule") as? String
        bookDetailIntroductionRule = coder.decodeObject(forKey: "bookDetailIntroductionRule") as? String
        bookChapterListPageUrlRule = coder.decodeObject(forKey: "bookChapterListPageUrlRule") as? String
        bookChapterDetailUrlRule = coder.decodeObject(forKey: "bookChapterDetailUrlRule") as? String
        bookChapterDetailContentRule = coder.decodeObject(forKey: "bookChapterDetailContentRule") as? String
        bookChapterDetailNextPageContentUrlRule = coder.decodeObject(forKey: "bookChapterDetailNextPageContentUrlRule") as? String
        bookSearchListSerialStateRule = coder.decodeObject(forKey: "bookSearchListSerialStateRule") as? String
        bookDetailRecommendReadRule = coder.decodeObject(forKey: "bookDetailRecommendReadRule") as? String
        bookDetailCategoryNameRule = coder.decodeObject(forKey: "bookDetailCategoryNameRule") as? String
        bookDetailSerialStateRule = coder.decodeObject(forKey: "bookDetailSerialStateRule") as? String
    }
    
    override init() { }
}
