//
//  VideoSearchTableView.swift
//  Random
//
//  Created by yu mingming on 2020/6/3.
//  Copyright © 2020 刘超正. All rights reserved.
//

import UIKit

class VideoSearchTableViewCell: BaseTableViewCell {
    
    /// 视频名称
    var videoNameLabel: UILabel!
    
    var rightLabel: UILabel!
    
    static var identifier = "VideoSearchTableViewCell"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        videoNameLabel = UILabel()
            .cz
            .addSuperView(contentView)
            .makeConstraints({ (make) in
                make.centerY.equalToSuperview()
                make.left.equalToSuperview().offset(15)
            })
            .setContentHuggingPriority(.required, for: .horizontal)
            .setContentCompressionResistancePriority(.required, for: .horizontal)
            .textColor(cz_standardTextColor)
            .font(.cz_systemFont(14))
            .build
        
        rightLabel = UILabel()
            .cz
            .addSuperView(contentView)
            .makeConstraints({ (make) in
                make.centerY.equalToSuperview()
                make.left.equalTo(videoNameLabel.snp.right).offset(10)
                make.right.equalToSuperview().offset(-15)
            })
            .textAlignment(.right)
            .textColor(cz_unStandardTextColor)
            .font(.cz_systemFont(12))
            .setContentHuggingPriority(.required, for: .horizontal)
            .setContentCompressionResistancePriority(.required, for: .horizontal)
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
