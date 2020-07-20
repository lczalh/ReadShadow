//
//  SearchDownloadableVideoCollectionViewCell.swift
//  Random
//
//  Created by yu mingming on 2020/7/15.
//  Copyright © 2020 刘超正. All rights reserved.
//

import UIKit

class SearchDownloadableVideoCollectionViewCell: BaseCollectionViewCell {
    
    static var identifier = "VideoSearchTableViewCell"
    
    /// 标题
    var titleLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = cz_dividerColor
        titleLabel = UILabel()
        .cz
        .addSuperView(self)
        .makeConstraints({ (make) in
            make.centerY.equalToSuperview()
        })
        .font(.cz_boldSystemFont(12))
        .build
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
