//
//  BookReadChapterPagingModel.swift
//  Random
//
//  Created by yu mingming on 2020/6/16.
//  Copyright © 2020 刘超正. All rights reserved.
//

import UIKit

class BookReadChapterPagingModel: NSObject, NSCoding {
    
    /// 分页内容
    var pagingContent: NSAttributedString?
    
    func encode(with coder: NSCoder) {
        coder.encode(pagingContent, forKey: "pagingContent")
    }
    
    required init?(coder: NSCoder) {
        pagingContent = coder.decodeObject(forKey: "pagingContent") as? NSAttributedString
    }
    
    override init() { }
}
