//
//  BookReadHeaderView.swift
//  Random
//
//  Created by yu mingming on 2020/6/9.
//  Copyright © 2020 刘超正. All rights reserved.
//

import UIKit

class BookReadHeaderView: BaseTableHeaderFooterView {
    
    static var identifier = "BookReadHeaderView"
    
    /// 书源名称
    var bookSourceNameLabel: UILabel!
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        bookSourceNameLabel = UILabel()
            .cz
            .addSuperView(contentView)
            .makeConstraints({ (make) in
                make.left.equalToSuperview().offset(15)
                make.centerY.equalToSuperview()
            })
            .font(.cz_boldSystemFont(14))
            .textColor(cz_standardTextColor)
            .build
        
        let _ = UIView()
            .cz
            .addSuperView(contentView)
            .makeConstraints { (make) in
                make.left.right.bottom.equalToSuperview()
                make.height.equalTo(1)
            }
            .backgroundColor(cz_dividerColor)
            .build
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
