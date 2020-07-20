//
//  BookReadRecordModel.swift
//  Random
//
//  Created by yu mingming on 2020/6/22.
//  Copyright © 2020 刘超正. All rights reserved.
//

import UIKit

class BookReadRecordModel: NSObject {
    
    /// 书名
    var bookName: String?
    
    /// 当前记录的阅读章节
    var chapterModel: BookReadChapterModel?
    
    /// 阅读到的页码
    var pageIndex: Int?
}
