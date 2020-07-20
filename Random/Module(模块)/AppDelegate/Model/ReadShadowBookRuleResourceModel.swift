//
//  File.swift
//  Random
//
//  Created by yu mingming on 2020/7/8.
//  Copyright © 2020 刘超正. All rights reserved.
//  书源模型

import Foundation

class ReadShadowBookRuleResourceModel : NSObject, NSCoding, Mappable{
    
    /// 解析章节详情中的内容规则
    var bookChapterDetailContentRule : String?
    /// 解析章节详情中的内容下一页规则 （部分书源的章节内容是分页的）
    var bookChapterDetailNextPageContentUrlRule : String?
    /// 解析章节地址规则
    var bookChapterDetailUrlRule : String?
    /// 解析详情中的章节列表页规则（部分书源的章节列表是单独的HTML）
    var bookChapterListPageUrlRule : String?
    /// 解析详情中的作者规则
    var bookDetailAuthorRule : String?
    /// 解析详情中的类别名称规则
    var bookDetailCategoryNameRule : String?
    /// 解析详情中的书图片规则
    var bookDetailImageUrlRule : String?
    /// 解析详情中的简介规则
    var bookDetailIntroductionRule : String?
    /// 解析详情中的推荐阅读规则
    var bookDetailRecommendReadRule : String?
    /// 解析详情中的连载状态规则
    var bookDetailSerialStateRule : String?
    /// 搜索页编码格式（0：UTF-8，1：GBK）
    var bookSearchEncoding : String?
    /// 解析搜索列表中的类别名称规则
    var bookSearchListCategoryNameRule : String?
    /// 解析搜索列表中的详情地址规则
    var bookSearchListDetailUrlRule : String?
    /// 解析搜索列表中的最新章节名称规则
    var bookSearchListLatestChapterNameRule : String?
    /// 解析搜索列表中的书名规则
    var bookSearchListNameRule : String?
    /// 解析搜索列表中的连载状态规则
    var bookSearchListSerialStateRule : String?
    /// 书搜索地址
    var bookSearchUrl : String?
    /// 书源名称
    var bookSourceName : String?
    /// 书源地址
    var bookSourceUrl : String?
    /// 书详情页面编码格式（0：UTF-8，1：GBK）
    var bookDetailPageEncoding : String?


    class func newInstance(map: Map) -> Mappable?{
        return ReadShadowBookRuleResourceModel()
    }
    required init?(map: Map){}
    override init(){}

    func mapping(map: Map)
    {
        bookChapterDetailContentRule <- map["bookChapterDetailContentRule"]
        bookChapterDetailNextPageContentUrlRule <- map["bookChapterDetailNextPageContentUrlRule"]
        bookChapterDetailUrlRule <- map["bookChapterDetailUrlRule"]
        bookChapterListPageUrlRule <- map["bookChapterListPageUrlRule"]
        bookDetailAuthorRule <- map["bookDetailAuthorRule"]
        bookDetailCategoryNameRule <- map["bookDetailCategoryNameRule"]
        bookDetailImageUrlRule <- map["bookDetailImageUrlRule"]
        bookDetailIntroductionRule <- map["bookDetailIntroductionRule"]
        bookDetailRecommendReadRule <- map["bookDetailRecommendReadRule"]
        bookDetailSerialStateRule <- map["bookDetailSerialStateRule"]
        bookSearchEncoding <- map["bookSearchEncoding"]
        bookSearchListCategoryNameRule <- map["bookSearchListCategoryNameRule"]
        bookSearchListDetailUrlRule <- map["bookSearchListDetailUrlRule"]
        bookSearchListLatestChapterNameRule <- map["bookSearchListLatestChapterNameRule"]
        bookSearchListNameRule <- map["bookSearchListNameRule"]
        bookSearchListSerialStateRule <- map["bookSearchListSerialStateRule"]
        bookSearchUrl <- map["bookSearchUrl"]
        bookSourceName <- map["bookSourceName"]
        bookSourceUrl <- map["bookSourceUrl"]
        bookDetailPageEncoding <- map["bookDetailPageEncoding"]
    }

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
    {
         bookChapterDetailContentRule = aDecoder.decodeObject(forKey: "bookChapterDetailContentRule") as? String
         bookChapterDetailNextPageContentUrlRule = aDecoder.decodeObject(forKey: "bookChapterDetailNextPageContentUrlRule") as? String
         bookChapterDetailUrlRule = aDecoder.decodeObject(forKey: "bookChapterDetailUrlRule") as? String
         bookChapterListPageUrlRule = aDecoder.decodeObject(forKey: "bookChapterListPageUrlRule") as? String
         bookDetailAuthorRule = aDecoder.decodeObject(forKey: "bookDetailAuthorRule") as? String
         bookDetailCategoryNameRule = aDecoder.decodeObject(forKey: "bookDetailCategoryNameRule") as? String
         bookDetailImageUrlRule = aDecoder.decodeObject(forKey: "bookDetailImageUrlRule") as? String
         bookDetailIntroductionRule = aDecoder.decodeObject(forKey: "bookDetailIntroductionRule") as? String
         bookDetailRecommendReadRule = aDecoder.decodeObject(forKey: "bookDetailRecommendReadRule") as? String
         bookDetailSerialStateRule = aDecoder.decodeObject(forKey: "bookDetailSerialStateRule") as? String
         bookSearchEncoding = aDecoder.decodeObject(forKey: "bookSearchEncoding") as? String
         bookSearchListCategoryNameRule = aDecoder.decodeObject(forKey: "bookSearchListCategoryNameRule") as? String
         bookSearchListDetailUrlRule = aDecoder.decodeObject(forKey: "bookSearchListDetailUrlRule") as? String
         bookSearchListLatestChapterNameRule = aDecoder.decodeObject(forKey: "bookSearchListLatestChapterNameRule") as? String
         bookSearchListNameRule = aDecoder.decodeObject(forKey: "bookSearchListNameRule") as? String
         bookSearchListSerialStateRule = aDecoder.decodeObject(forKey: "bookSearchListSerialStateRule") as? String
         bookSearchUrl = aDecoder.decodeObject(forKey: "bookSearchUrl") as? String
         bookSourceName = aDecoder.decodeObject(forKey: "bookSourceName") as? String
         bookSourceUrl = aDecoder.decodeObject(forKey: "bookSourceUrl") as? String
         bookDetailPageEncoding = aDecoder.decodeObject(forKey: "bookDetailPageEncoding") as? String
    }

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc func encode(with aCoder: NSCoder)
    {
        if bookChapterDetailContentRule != nil{
            aCoder.encode(bookChapterDetailContentRule, forKey: "bookChapterDetailContentRule")
        }
        if bookChapterDetailNextPageContentUrlRule != nil{
            aCoder.encode(bookChapterDetailNextPageContentUrlRule, forKey: "bookChapterDetailNextPageContentUrlRule")
        }
        if bookChapterDetailUrlRule != nil{
            aCoder.encode(bookChapterDetailUrlRule, forKey: "bookChapterDetailUrlRule")
        }
        if bookChapterListPageUrlRule != nil{
            aCoder.encode(bookChapterListPageUrlRule, forKey: "bookChapterListPageUrlRule")
        }
        if bookDetailAuthorRule != nil{
            aCoder.encode(bookDetailAuthorRule, forKey: "bookDetailAuthorRule")
        }
        if bookDetailCategoryNameRule != nil{
            aCoder.encode(bookDetailCategoryNameRule, forKey: "bookDetailCategoryNameRule")
        }
        if bookDetailImageUrlRule != nil{
            aCoder.encode(bookDetailImageUrlRule, forKey: "bookDetailImageUrlRule")
        }
        if bookDetailIntroductionRule != nil{
            aCoder.encode(bookDetailIntroductionRule, forKey: "bookDetailIntroductionRule")
        }
        if bookDetailRecommendReadRule != nil{
            aCoder.encode(bookDetailRecommendReadRule, forKey: "bookDetailRecommendReadRule")
        }
        if bookDetailSerialStateRule != nil{
            aCoder.encode(bookDetailSerialStateRule, forKey: "bookDetailSerialStateRule")
        }
        if bookSearchEncoding != nil{
            aCoder.encode(bookSearchEncoding, forKey: "bookSearchEncoding")
        }
        if bookSearchListCategoryNameRule != nil{
            aCoder.encode(bookSearchListCategoryNameRule, forKey: "bookSearchListCategoryNameRule")
        }
        if bookSearchListDetailUrlRule != nil{
            aCoder.encode(bookSearchListDetailUrlRule, forKey: "bookSearchListDetailUrlRule")
        }
        if bookSearchListLatestChapterNameRule != nil{
            aCoder.encode(bookSearchListLatestChapterNameRule, forKey: "bookSearchListLatestChapterNameRule")
        }
        if bookSearchListNameRule != nil{
            aCoder.encode(bookSearchListNameRule, forKey: "bookSearchListNameRule")
        }
        if bookSearchListSerialStateRule != nil{
            aCoder.encode(bookSearchListSerialStateRule, forKey: "bookSearchListSerialStateRule")
        }
        if bookSearchUrl != nil{
            aCoder.encode(bookSearchUrl, forKey: "bookSearchUrl")
        }
        if bookSourceName != nil{
            aCoder.encode(bookSourceName, forKey: "bookSourceName")
        }
        if bookSourceUrl != nil{
            aCoder.encode(bookSourceUrl, forKey: "bookSourceUrl")
        }
        if bookDetailPageEncoding != nil{
            aCoder.encode(bookDetailPageEncoding, forKey: "bookDetailPageEncoding")
        }
    }

}
