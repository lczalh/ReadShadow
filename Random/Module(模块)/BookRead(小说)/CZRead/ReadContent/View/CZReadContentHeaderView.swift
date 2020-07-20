//
//  CZReadHeaderView.swift
//  Random
//
//  Created by yu mingming on 2020/5/6.
//  Copyright © 2020 刘超正. All rights reserved.
//

import UIKit

class CZReadContentHeaderView: BaseView {
    
    /// 章节标题
    var chapterTitleLabel: UILabel!

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.clear
        chapterTitleLabel = UILabel()
            .cz
            .addSuperView(self)
            .makeConstraints({ (make) in
                make.left.equalToSuperview()
                make.centerY.equalToSuperview()
            })
            .textColor(bookReadFontColor)
            .font(UIFont.cz_systemFont(12))
            .build
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
