//
//  File.swift
//  Random
//
//  Created by yu mingming on 2020/7/20.
//  Copyright © 2020 刘超正. All rights reserved.
//

import UIKit

class VideoEpisodeCollectionViewCell: BaseCollectionViewCell {
    
    static var identifier = "VideoEpisodeCollectionViewCell"
    
    /// 剧集
    var titleLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = cz_dividerColor
        titleLabel = UILabel()
            .cz
            .addSuperView(contentView)
            .makeConstraints({ (make) in
                make.center.equalToSuperview()
                make.left.equalToSuperview().offset(10)
                make.right.equalToSuperview().offset(-10)
            })
            .font(.cz_systemFont(10))
            .textColor(cz_standardTextColor)
            .build
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

