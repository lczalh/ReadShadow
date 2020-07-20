//
//  VideoIntroductionView.swift
//  Random
//
//  Created by yu mingming on 2020/7/20.
//  Copyright © 2020 刘超正. All rights reserved.
//

import UIKit

class VideoIntroductionView: BaseView {
    
    /// 视频名称
    var videoNameLabel: UILabel!
    
    /// 视频信息 评分、年、地区、类别
    var videoInfoLabel: UILabel!
    
    /// 导演
    var directorLabel: UILabel!
    
    /// 演员
    var actorLabel: UILabel!
    
    /// 简介
    var introductionLabel: CZLabel!
    
    /// 关闭
    var closeButton: UIButton!

    override init(frame: CGRect) {
        super.init(frame: frame)
        // 视频名称
        videoNameLabel = UILabel()
             .cz
             .addSuperView(self)
             .makeConstraints({ (make) in
                make.left.equalToSuperview().offset(10)
                make.top.equalToSuperview().offset(10)
             })
            .font(.cz_boldSystemFont(14))
            .textColor(cz_standardTextColor)
            .setContentHuggingPriority(.required, for: .vertical)
            .setContentCompressionResistancePriority(.required, for: .vertical)
            .build
        let videoNameBottomLine = UIView()
            .cz
            .addSuperView(self)
            .makeConstraints { (make) in
                make.top.equalTo(videoNameLabel.snp.bottom).offset(10)
                make.left.right.equalToSuperview()
                make.height.equalTo(1)
            }
            .backgroundColor(cz_dividerColor)
            .setContentHuggingPriority(.required, for: .vertical)
            .setContentCompressionResistancePriority(.required, for: .vertical)
            .build
        
        // 关闭
        closeButton = UIButton()
            .cz
            .addSuperView(self)
            .makeConstraints({ (make) in
                make.right.equalToSuperview().offset(-10)
                make.centerY.equalTo(videoNameLabel)
            })
            .image(UIImage(named: "Icon_Video_Introduction_Close"), for: .normal)
            .font(.cz_boldSystemFont(14))
            .titleColor(cz_standardTextColor, for: .normal)
            .build
        
        videoInfoLabel = UILabel()
            .cz
            .addSuperView(self)
            .makeConstraints({ (make) in
                make.left.equalToSuperview().offset(10)
                make.top.equalTo(videoNameBottomLine.snp.bottom).offset(10)
            })
            .font(.cz_systemFont(10))
            .textColor(cz_standardTextColor)
            .setContentHuggingPriority(.required, for: .vertical)
            .setContentCompressionResistancePriority(.required, for: .vertical)
            .build
        
        directorLabel = UILabel()
            .cz
            .addSuperView(self)
            .makeConstraints({ (make) in
                make.left.equalToSuperview().offset(10)
                make.right.equalToSuperview().offset(-10)
                make.top.equalTo(videoInfoLabel.snp.bottom).offset(10)
            })
            .font(.cz_systemFont(10))
            .numberOfLines(0)
            .textColor(cz_standardTextColor)
            .setContentHuggingPriority(.required, for: .vertical)
            .setContentCompressionResistancePriority(.required, for: .vertical)
            .build
        
        actorLabel = UILabel()
            .cz
            .addSuperView(self)
            .makeConstraints({ (make) in
                make.left.equalToSuperview().offset(10)
                make.right.equalToSuperview().offset(-10)
                make.top.equalTo(directorLabel.snp.bottom).offset(10)
            })
            .font(.cz_systemFont(10))
            .textColor(cz_standardTextColor)
            .setContentHuggingPriority(.required, for: .vertical)
            .setContentCompressionResistancePriority(.required, for: .vertical)
            .numberOfLines(0)
            .build
        
        let actorBottomLine = UIView()
            .cz
            .addSuperView(self)
            .makeConstraints { (make) in
                make.top.equalTo(actorLabel.snp.bottom).offset(10)
                make.left.right.equalToSuperview()
                make.height.equalTo(1)
            }
            .backgroundColor(cz_dividerColor)
            .setContentHuggingPriority(.required, for: .vertical)
            .setContentCompressionResistancePriority(.required, for: .vertical)
            .build
        
        let introductionTitleLabel = UILabel()
            .cz
            .addSuperView(self)
            .makeConstraints({ (make) in
                make.left.equalToSuperview().offset(10)
                make.top.equalTo(actorBottomLine.snp.bottom).offset(10)
            })
            .font(.cz_boldSystemFont(12))
            .textColor(cz_standardTextColor)
            .setContentHuggingPriority(.required, for: .vertical)
            .setContentCompressionResistancePriority(.required, for: .vertical)
            .text("简介")
            .build
        
        introductionLabel = CZLabel()
            .cz
            .addSuperView(self)
            .makeConstraints({ (make) in
                make.left.equalToSuperview().offset(10)
                make.top.equalTo(introductionTitleLabel.snp.bottom).offset(10)
                make.right.equalToSuperview().offset(-10)
                make.bottom.equalToSuperview().offset(-10)
            })
            .font(.cz_systemFont(10))
            .textColor(cz_standardTextColor)
            .numberOfLines(0)
            .build
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
