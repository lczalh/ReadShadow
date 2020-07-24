//
//  VideoHomeView.swift
//  Random
//
//  Created by 刘超正 on 2019/11/7.
//  Copyright © 2019 刘超正. All rights reserved.
//

import UIKit

class VideoHomeView: BaseView {
    
    /// 搜索视图
    lazy var videoSearchFeatureView: VideoSearchFeatureView = {
        let view = VideoSearchFeatureView(frame: CGRect(x: 0, y: 0, width: CZCommon.cz_screenWidth, height: CZCommon.cz_dynamicFitHeight(40)))
        return view
    }()
    
    /// 初始化JXSegmentedView
    lazy var segmentedView: JXSegmentedView = {
        let view = JXSegmentedView(frame: CGRect(x: 0, y: videoSearchFeatureView.height, width: CZCommon.cz_screenWidth, height: CZCommon.cz_dynamicFitHeight(40)))
        view.dataSource = segmentedDataSource
        return view
    }()
    
    /// 配置数据源
    lazy var segmentedDataSource: JXSegmentedTitleDataSource = {
        let dataSource = JXSegmentedTitleDataSource()
        dataSource.isTitleColorGradientEnabled = true
        dataSource.titleNormalColor = cz_unselectedColor
        dataSource.titleSelectedColor = cz_selectedColor
        dataSource.titleNormalFont = UIFont.cz_systemFont(14)
        dataSource.titleSelectedFont = UIFont.cz_boldSystemFont(16)
        return dataSource
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(videoSearchFeatureView)
        addSubview(segmentedView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
