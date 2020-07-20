//
//  CZReadContentController.swift
//  Random
//
//  Created by yu mingming on 2020/5/6.
//  Copyright © 2020 刘超正. All rights reserved.
//

import UIKit

class CZReadContentController: BaseController {
    
    /// 背景
    lazy var readBackgroundImageView: CZReadBackgroundImageView = {
        let view = CZReadBackgroundImageView(frame: UIScreen.main.bounds)
        return view
    }()
    
    /// 头部
    lazy var czReadContentHeaderView: CZReadContentHeaderView = {
        let view = CZReadContentHeaderView(frame: CGRect(x: CZCommon.cz_dynamicFitWidth(15),
                                                         y: CZCommon.cz_statusBarHeight,
                                                         width: CZCommon.cz_screenWidth - CZCommon.cz_dynamicFitWidth(30),
                                                         height: CZCommon.cz_dynamicFitHeight(20)))
        return view
    }()
    
    /// 内容
    lazy var czReadContentView: CZReadContentView = {
        let view = CZReadContentView(frame: bookReadCententFrame)
        return view
    }()
    
    /// 尾部
    lazy var czReadContentFooterView: CZReadContentFooterView = {
        let view = CZReadContentFooterView(frame: CGRect(x: CZCommon.cz_dynamicFitWidth(15),
                                                         y: CZCommon.cz_screenHeight - CZCommon.cz_safeAreaHeight - CZCommon.cz_dynamicFitHeight(20),
                                                         width: CZCommon.cz_screenWidth - CZCommon.cz_dynamicFitWidth(30),
                                                         height: CZCommon.cz_dynamicFitHeight(20)))
        return view
    }()
    
    /// 章节名称
    var chapterName: String? {
        didSet {
            czReadContentHeaderView.chapterTitleLabel.attributedText = createAttributedString(text: chapterName ?? "")
        }
    }
    
    /// 章节内容
    var chapterContent: NSAttributedString? {
        didSet {
            czReadContentView.content = chapterContent
        }
    }
    
    /// 当前章节索引
    var chapterCurrentIndex: Int?
    
    /// 章节当前分页索引
    var chapterPagingCurrentIndex: Int?
    
    /// 章节分页总索引
    var chapterPagingTotalIndex: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = bookReadThemeColor
        readBackgroundImageView.cz.addSuperView(view)
        czReadContentHeaderView.cz.addSuperView(view)
        czReadContentFooterView.cz.addSuperView(view)
        czReadContentView.cz.addSuperView(view)
        // 设置电量
        czReadContentFooterView.batteryLevel = UIDevice.current.batteryLevel
        // 设置页码
        czReadContentFooterView.pageNumberLabel.attributedText = createAttributedString(text: "\(chapterPagingCurrentIndex ?? 0)/\(chapterPagingTotalIndex ?? 0)")
    }
    

    func createAttributedString(text: String) -> NSAttributedString {
        return NSAttributedString(string: text,
                                  attributes: [
                                    NSAttributedString.Key.foregroundColor : bookReadFontColor,
                                    NSAttributedString.Key.font: UIFont.init(name: (bookReadFamilyName), size: CZCommon.cz_dynamicFitWidth(12))!,
                                    ]
                                 )
    }

}
