//
//  CZReadStyleCollectionCell.swift
//  Random
//
//  Created by yu mingming on 2020/6/16.
//  Copyright © 2020 刘超正. All rights reserved.
//

import UIKit

class CZReadStyleCollectionCell: BaseCollectionViewCell {
    
    static var identifier = "CZReadStyleCollectionCell"
    
    /// 标题
    var titleLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .clear
        backgroundColor = .clear
        contentView.borderWidth = 1
        
        titleLabel = UILabel()
            .cz
            .addSuperView(contentView)
            .makeConstraints({ (make) in
                make.center.equalToSuperview()
            })
            .textColor(cz_standardTextColor)
            .text("无")
            .font(.cz_systemFont(12))
            .textAlignment(.center)
            .build
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
