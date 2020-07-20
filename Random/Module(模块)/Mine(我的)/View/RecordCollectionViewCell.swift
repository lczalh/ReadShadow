//
//  MineCollectionViewCell.swift
//  Random
//
//  Created by yu mingming on 2020/6/5.
//  Copyright © 2020 刘超正. All rights reserved.
//

import UIKit

class RecordMineCollectionViewCell: BaseCollectionViewCell {
    
    static var identifier = "RecordMineCollectionViewCell"
    
    /// 图片
    var videoImageView: UIImageView!
    
    /// 标题
    var videoTitleLabel: UILabel!
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        videoImageView = UIImageView()
            .cz
            .addSuperView(contentView)
            .makeConstraints({ (make) in
                make.left.right.equalToSuperview()
                make.top.equalToSuperview().offset(5)
               // make.height.equalTo(CZCommon.cz_dynamicFitHeight(60))
            })
            .contentMode(.scaleAspectFill)
            .clipsToBounds(true)
            .build
        
        videoTitleLabel = UILabel()
            .cz
            .addSuperView(contentView)
            .makeConstraints({ (make) in
                make.top.equalTo(videoImageView.snp.bottom).offset(5)
                make.bottom.equalToSuperview().offset(-5)
                make.left.right.equalToSuperview()
            })
            .font(.cz_systemFont(12))
            .textColor(cz_standardTextColor)
            .setContentHuggingPriority(.required, for: .vertical)
            .setContentCompressionResistancePriority(.required, for: .vertical)
            .build
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
