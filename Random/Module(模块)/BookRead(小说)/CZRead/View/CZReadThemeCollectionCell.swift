//
//  CZReadThemeCollectionCell.swift
//  Random
//
//  Created by yu mingming on 2020/6/16.
//  Copyright © 2020 刘超正. All rights reserved.
//

import UIKit

class CZReadThemeCollectionCell: BaseCollectionViewCell {
    
    static var identifier = "CZReadThemeCollectionCell"
    
    /// 主题view
    var themeImageView: UIImageView!
    
    /// 选中view
    var selectorView: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .clear
        backgroundColor = .clear
        
        selectorView = UIView()
            .cz
            .addSuperView(contentView)
            .makeConstraints({ (make) in
                make.center.equalToSuperview()
                make.size.equalTo(CGSize(width: 34, height: 34))
            })
            .backgroundColor(.clear)
            .cornerRadius(17)
            .clipsToBounds(true)
            .borderWidth(2)
            .build
        
        themeImageView = UIImageView()
            .cz
            .addSuperView(contentView)
            .makeConstraints({ (make) in
                make.center.equalToSuperview()
                make.size.equalTo(CGSize(width: 26, height: 26))
            })
            .cornerRadius(13)
            .clipsToBounds(true)
            .build
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
