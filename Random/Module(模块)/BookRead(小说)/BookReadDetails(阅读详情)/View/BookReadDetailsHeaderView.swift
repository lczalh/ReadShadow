//
//  BookReadDetailsHeaderView.swift
//  Random
//
//  Created by yu mingming on 2020/6/10.
//  Copyright © 2020 刘超正. All rights reserved.
//

import UIKit

class BookReadDetailsHeaderView: BaseTableHeaderFooterView {
    
    static var identifier = "BookReadDetailsHeaderView"
    
    /// 推荐阅读
    var recommendReadLabel: UILabel!

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        recommendReadLabel = UILabel()
           .cz
           .addSuperView(contentView)
           .makeConstraints({ (make) in
            make.left.equalToSuperview().offset(15)
               make.centerY.equalToSuperview()
           })
           .font(.cz_boldSystemFont(14))
           .textColor(cz_standardTextColor)
           .setContentHuggingPriority(.required, for: .horizontal)
           .setContentCompressionResistancePriority(.required, for: .horizontal)
           .build
        
        let _ = UIView()
        .cz
        .addSuperView(self)
        .makeConstraints { (make) in
            make.right.bottom.equalToSuperview()
            make.left.equalToSuperview().offset(15)
            make.height.equalTo(1)
        }
        .backgroundColor(cz_dividerColor)
        .build
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
