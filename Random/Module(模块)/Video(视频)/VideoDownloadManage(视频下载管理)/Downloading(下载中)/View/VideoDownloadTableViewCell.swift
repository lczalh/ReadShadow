//
//  VideoDownloadManageTableViewCell.swift
//  Random
//
//  Created by yu mingming on 2019/11/19.
//  Copyright © 2019 刘超正. All rights reserved.
//

import UIKit

class VideoDownloadTableViewCell: SwipeTableViewCell {
    
    public static let identifier = "VideoDownloadTableViewCell"
    
    /// 标题
    var titleLabel: QMUILabel!
    
    /// 时间
    var timeLabel: QMUILabel!
    
    /// 开始 / 暂停按钮
    var playAndPauseButton: UIButton!
    
    /// 已下载大小 / 总大小
    var downloadAndTotalSizeLabel: QMUILabel!
    
    /// 下载速度
    var downloadSpeedLabel: QMUILabel!
    
    /// 下载进度视图
    var downloadProgressView: UIProgressView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.backgroundColor = UIColor.white
        
        playAndPauseButton = UIButton()
            .cz
            .addSuperView(contentView)
            .makeConstraints({ (make) in
                make.right.equalToSuperview().offset(-15)
                make.centerY.equalToSuperview()
            })
            .image(UIImage(named: "Icon_Home_Video_Player")?.cz_alterColor(color: cz_selectedColor), for: .normal)
            .image(UIImage(named: "Icon_Home_Video_Pause")?.cz_alterColor(color: cz_selectedColor), for: .selected)
            .setContentHuggingPriority(.required, for: .horizontal)
            .setContentCompressionResistancePriority(.required, for: .horizontal)
            .build
        
        titleLabel = QMUILabel()
            .cz
            .addSuperView(contentView)
            .makeConstraints({ (make) in
                make.left.equalToSuperview().offset(15)
                make.top.equalToSuperview().offset(10)
                make.right.equalTo(playAndPauseButton.snp.left).offset(-15)
            })
            .font(UIFont.cz_boldSystemFont(14))
            .numberOfLines(2)
            .textColor(cz_standardTextColor)
            .build
        
        downloadProgressView = UIProgressView()
            .cz
            .addSuperView(contentView)
            .makeConstraints({ (make) in
                make.left.equalToSuperview().offset(15)
                make.bottom.equalToSuperview().offset(-10)
                make.right.equalTo(playAndPauseButton.snp.left).offset(-15)
            })
            .progressTintColor(cz_selectedColor)
            .trackTintColor(cz_dividerColor)
            .build
        
        downloadAndTotalSizeLabel = QMUILabel()
            .cz
            .addSuperView(contentView)
            .makeConstraints({ (make) in
                make.bottom.equalTo(downloadProgressView.snp.top).offset(-5)
                make.left.equalToSuperview().offset(15)
            })
            .font(UIFont.cz_boldSystemFont(12))
            .textColor(cz_selectedColor)
            .build
        
        downloadSpeedLabel = QMUILabel()
            .cz
            .addSuperView(contentView)
            .makeConstraints({ (make) in
                make.centerY.equalTo(downloadAndTotalSizeLabel)
                make.right.equalTo(playAndPauseButton.snp.left).offset(-15)
            })
            .font(UIFont.cz_boldSystemFont(12))
            .textColor(cz_selectedColor)
            .build
        
        timeLabel = QMUILabel()
            .cz
            .addSuperView(contentView)
            .makeConstraints({ (make) in
                make.centerY.equalTo(downloadAndTotalSizeLabel)
                make.right.equalTo(downloadSpeedLabel.snp.left).offset(-15)
            })
            .font(UIFont.cz_boldSystemFont(12))
            .textColor(cz_selectedColor)
            .build
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
