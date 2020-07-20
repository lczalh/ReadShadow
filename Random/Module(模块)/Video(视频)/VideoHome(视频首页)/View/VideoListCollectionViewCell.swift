//
//  VideoListCollectionViewCell.swift
//  Random
//
//  Created by yu mingming on 2020/6/4.
//  Copyright © 2020 刘超正. All rights reserved.
//

import UIKit

class VideoListCollectionViewCell: BaseCollectionViewCell {
    
    static var identifier = "VideoListCollectionViewCell"
    
    /// 图片
    var videoImageView: UIImageView!
    
    /// 连续
    var continuLabel: UILabel!
    
    /// 标题
    var titleLabel: QMUILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        videoImageView = UIImageView()
            .cz
            .addSuperView(contentView)
            .makeConstraints({ (make) in
                make.left.top.right.equalToSuperview()
                make.bottom.equalToSuperview().offset(-CZCommon.cz_dynamicFitHeight(20))
            })
            .contentMode(.scaleAspectFill)
            .clipsToBounds(true)
            .build
        
        continuLabel = UILabel()
            .cz
            .addSuperView(videoImageView)
            .makeConstraints({ (make) in
                make.bottom.right.equalToSuperview().offset(-5)
            })
            .font(UIFont.cz_boldSystemFont(10))
            .textColor(UIColor.white)
            .build
        
        titleLabel = QMUILabel()
            .cz
            .addSuperView(contentView)
            .makeConstraints({ (make) in
                make.top.equalTo(videoImageView.snp.bottom).offset(5)
                make.left.right.equalToSuperview()
                make.centerX.equalToSuperview()
            })
            .font(UIFont.cz_boldSystemFont(14))
            .textColor(cz_standardTextColor)
            .build

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
