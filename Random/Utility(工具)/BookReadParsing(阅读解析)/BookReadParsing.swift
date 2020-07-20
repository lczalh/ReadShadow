//
//  BookReadParsing.swift
//  Random
//
//  Created by yu mingming on 2020/6/10.
//  Copyright © 2020 刘超正. All rights reserved.
//

import UIKit

class BookReadParsing: NSObject {
    
    
    /// 小说详情解析
    /// - Parameters:
    ///   - bookReadModel: 阅读模型
    ///   - complete: 完成回调
    class func bookReadDetailParsing(bookReadModel: BookReadModel, complete: @escaping ((_ bookReadModel: BookReadModel?) -> Void)) {
        DispatchQueue.global().async {
            let encoding: String.Encoding = bookReadModel.bookReadParsingRule?.bookDetailPageEncoding == "0" ? .utf8 : .cz_gb_18030_2000
            if let detailHtml = try? HTML(url: URL(string: bookReadModel.bookDetailUrl)!, encoding: encoding) {
                cz_print(detailHtml.body?.toHTML)
                if let bookDetailImageUrlRule = bookReadModel.bookReadParsingRule?.bookDetailImageUrlRule, bookDetailImageUrlRule.isEmpty == false {
                    // 解析图片地址
                    if let bookImage = detailHtml.body?.xpath(bookDetailImageUrlRule) {
                        if bookImage.first?["src"]?.contains("http://") == false && bookImage.first?["src"]?.contains("https://") == false {
                            if bookImage.first?["src"]?.first == "/" {
                                bookReadModel.bookImageUrl = "\(bookReadModel.bookReadParsingRule?.bookSourceUrl ?? "")\(bookImage.first?["src"] ?? "")"
                            } else {
                                bookReadModel.bookImageUrl = "\(bookReadModel.bookReadParsingRule?.bookSourceUrl ?? "")/\(bookImage.first?["src"] ?? "")"
                            }
                        } else {
                            bookReadModel.bookImageUrl = bookImage.first?["src"] ?? ""
                        }
                        cz_print(bookImage.first?["src"] ?? "")
                    } else {
                        cz_print("图片地址解析失败")
                    }
                }
                
                if let bookDetailCategoryNameRule = bookReadModel.bookReadParsingRule?.bookDetailCategoryNameRule, bookDetailCategoryNameRule.isEmpty == false {
                    // 解析类别名称
                    if let bookCategory = detailHtml.body?.xpath(bookDetailCategoryNameRule) {
                        bookReadModel.bookCategory = bookCategory.first?.text?.cz_removeHeadAndTailSpacePro ?? ""
                        cz_print(bookCategory.first?.text ?? "")
                    } else {
                        cz_print("类别解析失败")
                    }
                }
                
                if let bookDetailAuthorRule = bookReadModel.bookReadParsingRule?.bookDetailAuthorRule, bookDetailAuthorRule.isEmpty == false {
                    // 解析作者
                    if let bookAuthor = detailHtml.body?.xpath(bookDetailAuthorRule) {
                        bookReadModel.bookAuthor = bookAuthor.first?.text?.cz_removeHeadAndTailSpacePro ?? ""
                        cz_print(bookAuthor.first?.text ?? "")
                    } else {
                        cz_print("作者解析失败")
                    }
                }
                
                if let bookDetailIntroductionRule = bookReadModel.bookReadParsingRule?.bookDetailIntroductionRule, bookDetailIntroductionRule.isEmpty == false {
                    // 解析简介
                    if let bookIntroduction = detailHtml.body?.xpath(bookDetailIntroductionRule) {
                        bookReadModel.bookIntroduction = bookIntroduction.first?.text?.cz_removeHeadAndTailSpacePro ?? ""
                        cz_print(bookIntroduction.first?.text ?? "")
                    } else {
                        cz_print("简介解析失败")
                    }
                }
                
                if let bookDetailSerialStateRule = bookReadModel.bookReadParsingRule?.bookDetailSerialStateRule, bookDetailSerialStateRule.isEmpty == false {
                    // 解析连载状态
                    if let bookSerialState = detailHtml.body?.xpath(bookDetailSerialStateRule) {
                        bookReadModel.bookSerialState = bookSerialState.first?.text?.cz_removeHeadAndTailSpacePro ?? ""
                        cz_print(bookSerialState.first?.text ?? "")
                    } else {
                        cz_print("连载状态解析失败")
                    }
                }

                
                
                // 判断章节列表是否在单独的一个HTML上
                // 是：先解析章节列表地址页，在解析章节列表
                // 否：直接解析章节列表
                if bookReadModel.bookReadParsingRule?.bookChapterListPageUrlRule == nil || bookReadModel.bookReadParsingRule?.bookChapterListPageUrlRule?.isEmpty == true {
                    parsingChapterList(detailHtml: detailHtml, bookReadModel: bookReadModel)
                } else {
                    // 解析章节列表页地址
                    if let bookChapterListPageUrl = detailHtml.body?.xpath(bookReadModel.bookReadParsingRule?.bookChapterListPageUrlRule ?? "") {
                        var bookChapterListPageUrlString = ""
                        if bookChapterListPageUrl.first?["href"]?.contains("http://") == false && bookChapterListPageUrl.first?["href"]?.contains("https://") == false {
                            if bookChapterListPageUrl.first?["href"]?.first == "/" {
                                bookChapterListPageUrlString = "\(bookReadModel.bookReadParsingRule?.bookSourceUrl ?? "")\(bookChapterListPageUrl.first?["href"] ?? "")"
                            } else {
                                bookChapterListPageUrlString = "\(bookReadModel.bookReadParsingRule?.bookSourceUrl ?? "")/\(bookChapterListPageUrl.first?["href"] ?? "")"
                            }
                        } else {
                            bookChapterListPageUrlString = bookChapterListPageUrl.first?["href"] ?? ""
                        }
                        cz_print(bookChapterListPageUrl.first?["href"])
                        if bookChapterListPageUrlString.isEmpty == false {
                            if let bookChapterListPageHtml = try? HTML(url: URL(string: bookChapterListPageUrlString)!, encoding: encoding) {
                                parsingChapterList(detailHtml: bookChapterListPageHtml, bookReadModel: bookReadModel)
                            } else {
                                cz_print("章节列表页失败")
                            }
                        }
                    } else {
                        cz_print("章节列表页地址解析失败")
                    }
                }
                
                if let bookDetailRecommendReadRule = bookReadModel.bookReadParsingRule?.bookDetailRecommendReadRule, bookDetailRecommendReadRule.isEmpty == false {
                    // 解析推荐列表
                    if let recommendReadLists = detailHtml.body?.xpath(bookDetailRecommendReadRule) {
                        var bookRecommendRead: Array<BookReadModel> = []
                        for recommendRead in recommendReadLists {
                            autoreleasepool {
                                let newBookReadModel = BookReadModel()
                                newBookReadModel.bookReadParsingRule = bookReadModel.bookReadParsingRule
                                if recommendRead["href"]?.contains("http://") == false && recommendRead["href"]?.contains("https://") == false {
                                    if recommendRead["href"]?.first == "/" {
                                        newBookReadModel.bookDetailUrl = "\(bookReadModel.bookReadParsingRule?.bookSourceUrl ?? "")\(recommendRead["href"] ?? "")"
                                    } else {
                                        newBookReadModel.bookDetailUrl = "\(bookReadModel.bookReadParsingRule?.bookSourceUrl ?? "")/\(recommendRead["href"] ?? "")"
                                    }
                                } else {
                                    newBookReadModel.bookDetailUrl = recommendRead["href"] ?? ""
                                }
                                newBookReadModel.bookName = recommendRead.text ?? ""
                                bookRecommendRead.append(newBookReadModel)
                                cz_print(recommendRead.text, recommendRead["href"])
                            }
                        }
                        bookReadModel.bookRecommendRead = bookRecommendRead
                    } else {
                        cz_print("推荐阅读列表解析失败")
                    }
                }
                
                complete(bookReadModel)
            } else {
                complete(nil)
                cz_print("详情解析失败")
            }
        }
    }
    
    /// 解析所有章节名称和地址
    class private func parsingChapterList(detailHtml: HTMLDocument, bookReadModel: BookReadModel) {
        if let bookChapterLists = detailHtml.body?.xpath(bookReadModel.bookReadParsingRule?.bookChapterDetailUrlRule ?? "") {
            var bookReadChapter: Array<BookReadChapterModel> = []
            for bookChapter in bookChapterLists {
                autoreleasepool {
                    let bookReadChapterModel = BookReadChapterModel()
                    // 章节地址
                    if bookChapter["href"]?.contains("http://") == false && bookChapter["href"]?.contains("https://") == false {
                        if bookChapter["href"]?.first == "/" {
                            bookReadChapterModel.chapterUrl = "\(bookReadModel.bookReadParsingRule?.bookSourceUrl ?? "")\(bookChapter["href"] ?? "")"
                        } else {
                            bookReadChapterModel.chapterUrl = "\(bookReadModel.bookReadParsingRule?.bookSourceUrl ?? "")/\(bookChapter["href"] ?? "")"
                        }
                    } else {
                        bookReadChapterModel.chapterUrl = bookChapter["href"] ?? ""
                    }
                    // 章节名称
                    bookReadChapterModel.chapterName = bookChapter.text ?? ""
                    bookReadChapter.append(bookReadChapterModel)
                    cz_print(bookChapter.text, bookChapter["href"])
                }
            }
            bookReadModel.bookReadChapter = bookReadChapter
        } else {
            cz_print("章节列表解析失败")
        }
    }
    
    /// 内容排版整理
    ///
    /// - Parameter content: 内容
    /// - Returns: 整理好的内容
    @objc class func contentTypesetting(content: String) -> String {
        // 将 "    " 替换 "\r\n　　"
        var content = content.replacingOccurrences(of: "    ", with: "\r\n　　")
        // 去除首尾空格
        content = content.cz_removeHeadAndTailSpacePro
        // 首部插入 "　　"
        content.insert(contentsOf: "　　", at: content.startIndex)
        return content
    }
    
    
    /// 章节内容解析 && 内容分页
    /// - Parameters:
    ///   - currentChapterIndex: 当前章节索引
    ///   - bookReadModel: 书模型
    ///   - num: 预加载数
    ///   - complete: 完成回调
    class func chapterContentParsing(currentChapterIndex: Int, bookReadModel: BookReadModel, num: Int = 2, complete: @escaping ((_ state: Bool) -> Void)) {
        // 判断索引是否超过章节数量
        let tailChapterIndex = currentChapterIndex + num >= (bookReadModel.bookReadChapter?.count ?? 0) ? (bookReadModel.bookReadChapter?.count ?? 0) : currentChapterIndex + num
        DispatchQueue.global().async {
            let queue = DispatchQueue.init(label: "chapterContentParsing")
            let group = DispatchGroup()
            for index in currentChapterIndex..<tailChapterIndex {
                autoreleasepool {
                    queue.async(group: group, execute: DispatchWorkItem.init(block: {
                        let chapterModel = bookReadModel.bookReadChapter?[index]
                        // 判断是否存在章节分页内容
                        if chapterModel?.chapterPaging == nil || chapterModel?.chapterPaging?.count ?? 0 == 0 { // 不存在
                            let encoding: String.Encoding = bookReadModel.bookReadParsingRule?.bookDetailPageEncoding == "0" ? .utf8 : .cz_gb_18030_2000
                            let chapterContent = parsingChapterPagingContent(chapterContent: "",
                                                        chapterUrl: chapterModel?.chapterUrl ?? "",
                                                        encoding: encoding, bookSourceUrl: bookReadModel.bookReadParsingRule?.bookSourceUrl ?? "",
                                                        bookChapterDetailNextPageContentUrlRule: bookReadModel.bookReadParsingRule?.bookChapterDetailNextPageContentUrlRule ?? "",
                                                        bookChapterDetailContentRule: bookReadModel.bookReadParsingRule?.bookChapterDetailContentRule ?? "")
                            chapterModel?.chapterContent = BookReadParsing.contentTypesetting(content: chapterContent)
                            chapterModel?.chapterPaging = chapterContentPaging(chapterContent: chapterModel?.chapterContent ?? "")
                        } else { // 存在 则重新分页
                            chapterModel?.chapterPaging = chapterContentPaging(chapterContent: chapterModel?.chapterContent ?? "")
                        }
                    }))
                }
            }
            //1,所有任务执行结束汇总，不阻塞当前线程
            group.notify(queue: .global(), execute: {
                let chapterModel = bookReadModel.bookReadChapter?[currentChapterIndex]
                if chapterModel?.chapterPaging == nil || chapterModel?.chapterPaging?.count ?? 0 == 0 {
                    complete(false)
                } else {
                    complete(true)
                }
            })
             
            //2,永久等待，直到所有任务执行结束，中途不能取消，阻塞当前线程
            group.wait()
        }
    }
    
    /// 解析章节内容
    class func parsingChapterPagingContent(chapterContent: String, chapterUrl: String, encoding: String.Encoding, bookSourceUrl: String, bookChapterDetailNextPageContentUrlRule: String, bookChapterDetailContentRule: String) -> String {
        var chapterContentString = chapterContent
        // 解析章节详情内容
        if let html = try? HTML(url: URL(string: chapterUrl)!, encoding: encoding) {
            if let content = html.body?.xpath(bookChapterDetailContentRule) {
                chapterContentString.append(content.first?.text ?? "")
                cz_print(content.first?.text)
            } else {
                cz_print("章节内容解析失败")
            }
            // 判断章节内容是否分页,也就是还有下一页
            if let nextPagingContent = html.body?.xpath(bookChapterDetailNextPageContentUrlRule) {
                // 拼接下一页内容地址
                var nextPagingContentUrl = ""
                if nextPagingContent.first?["href"]?.contains("http://") == false && nextPagingContent.first?["href"]?.contains("https://") == false {
                    if nextPagingContent.first?["href"]?.first == "/" {
                        nextPagingContentUrl = "\(bookSourceUrl)\(nextPagingContent.first?["href"] ?? "")"
                    } else {
                        nextPagingContentUrl = "\(bookSourceUrl)/\(nextPagingContent.first?["href"] ?? "")"
                    }
                } else {
                    nextPagingContentUrl = nextPagingContent.first?["href"] ?? ""
                }
                if nextPagingContentUrl.isEmpty == false {
                    return parsingChapterPagingContent(chapterContent: chapterContentString, chapterUrl: nextPagingContentUrl, encoding: encoding, bookSourceUrl: bookSourceUrl, bookChapterDetailNextPageContentUrlRule: bookChapterDetailNextPageContentUrlRule, bookChapterDetailContentRule: bookChapterDetailContentRule)
                }
            } else {
                cz_print("章节下一页地址解析失败")
            }
        } else {
            cz_print("解析章节详情失败")
        }
        return chapterContentString
    }
    
    /// 将已加载的章节内容重新分页
    @objc class func filterLoadedChapterContentAndPaging(bookReadModel: BookReadModel) {
        let chapterModels = bookReadModel.bookReadChapter?.filter{ $0.chapterContent != nil && $0.chapterContent?.isEmpty != true } ?? []
        for chapterModel in chapterModels {
            chapterModel.chapterPaging = chapterContentPaging(chapterContent: chapterModel.chapterContent ?? "")
        }
        // 获取当前章节模型
        let chapterModel = bookReadModel.bookReadChapter?[bookReadModel.bookLastReadChapterIndex ?? 0]
        // 判断当前分页索引是否大于等于当前章节分页模型
        if (bookReadModel.bookLastReadChapterPagingIndex ?? 0) >= chapterModel?.chapterPaging?.count ?? 0 {
            bookReadModel.bookLastReadChapterPagingIndex = (chapterModel?.chapterPaging?.count ?? 0) - 1
        }
    }
    
    /// 章节内容分页
    @objc class func chapterContentPaging(chapterContent: String) -> Array<BookReadChapterPagingModel> {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = CZCommon.cz_dynamicFitWidth(7)
        let attrString = NSAttributedString(string: chapterContent,
                                            attributes: [NSAttributedString.Key.foregroundColor : bookReadFontColor,
                                                         NSAttributedString.Key.font: UIFont.init(name: (bookReadFamilyName), size: CZCommon.cz_dynamicFitWidth(CGFloat(bookReadFontSize)))!,
                                                         NSAttributedString.Key.paragraphStyle: paragraphStyle
                                                        ]
                                            )
        var chapterPagingModels: Array<BookReadChapterPagingModel> = []
        let framesetter = CTFramesetterCreateWithAttributedString(attrString as CFAttributedString)
        let path = CGPath(rect: bookReadCententFrame, transform: nil)
        var range = CFRangeMake(0, 0)
        var rangeOffset:NSInteger = 0
        var index = 0
        repeat{
            autoreleasepool {
                let frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(rangeOffset, 0), path, nil)
                range = CTFrameGetVisibleStringRange(frame)
                // 创建章节模型
                let chapterPagingModel = BookReadChapterPagingModel()
                chapterPagingModel.pagingContent = attrString.attributedSubstring(from: NSMakeRange(rangeOffset, range.length))
                chapterPagingModels.append(chapterPagingModel)
                rangeOffset += range.length
                index += 1
            }
        } while ( range.location + range.length < attrString.length )
        return chapterPagingModels
    }
}
