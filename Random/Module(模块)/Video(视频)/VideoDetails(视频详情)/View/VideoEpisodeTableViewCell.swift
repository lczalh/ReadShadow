//
//  File.swift
//  Random
//
//  Created by yu mingming on 2020/7/20.
//  Copyright © 2020 刘超正. All rights reserved.
//

import Foundation

class VideoEpisodeTableViewCell: BaseTableViewCell {
    
    static var identifier = "VideoEpisodeTableViewCell"
    
    /// 剧集
    var seriesLabel: UILabel!
    
    /// 初始化JXSegmentedView
    lazy var segmentedView: JXSegmentedView = {
        let view = JXSegmentedView()
        view.dataSource = self.segmentedDataSource
        return view
    }()
    
    /// 配置数据源
    lazy var segmentedDataSource: JXSegmentedTitleDataSource = {
        let dataSource = JXSegmentedTitleDataSource()
        dataSource.isItemSpacingAverageEnabled = false
        dataSource.isTitleColorGradientEnabled = true
        dataSource.titleNormalColor = cz_unselectedColor
        dataSource.titleSelectedColor = cz_selectedColor
        dataSource.titleNormalFont = UIFont.cz_systemFont(12)
        dataSource.titleSelectedFont = UIFont.cz_boldSystemFont(12)
        return dataSource
    }()

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
        
        seriesLabel = UILabel()
            .cz
            .addSuperView(contentView)
            .makeConstraints({ (make) in
                make.top.equalToSuperview().offset(10)
                make.left.equalToSuperview().offset(10)
                
            })
            .font(.cz_boldSystemFont(14))
            .text("剧集与更新")
            .build
        
        segmentedView.cz.addSuperView(contentView).makeConstraints({ (make) in
            make.top.equalTo(seriesLabel.snp.bottom)
            make.left.right.equalToSuperview()
            make.height.equalTo(CZCommon.cz_dynamicFitHeight(40))
            make.bottom.equalToSuperview()
        })
        
        let _ = UIView()
            .cz
            .addSuperView(contentView)
            .makeConstraints { (make) in
                make.right.left.bottom.equalToSuperview()
                make.height.equalTo(1)
            }
            .backgroundColor(cz_dividerColor)
            .build
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

