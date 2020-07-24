//
//  VideoDownloadManageView.swift
//  Random
//
//  Created by yu mingming on 2019/12/6.
//  Copyright © 2019 刘超正. All rights reserved.
//

import UIKit

class VideoDownloadManageView: BaseView {

    /// 初始化JXSegmentedView
    lazy var segmentedView: JXSegmentedView = {
        let view = JXSegmentedView(frame: CGRect(x: 0, y: 0, width: CZCommon.cz_screenWidth, height: CZCommon.cz_dynamicFitHeight(40)))
        view.dataSource = self.segmentedDataSource
        view.indicators = [indicator]
        view.backgroundColor = UIColor.white
        return view
    }()
    
    /// 配置数据源
    lazy var segmentedDataSource: JXSegmentedTitleDataSource = {
        let dataSource = JXSegmentedTitleDataSource()
        dataSource.isTitleColorGradientEnabled = true
        dataSource.titleNormalColor = cz_unselectedColor
        dataSource.titleSelectedColor = cz_selectedColor
        dataSource.titleNormalFont = UIFont.cz_systemFont(14)
        dataSource.titleSelectedFont = UIFont.cz_boldSystemFont(14)
        return dataSource
    }()
    
    /// 配置指示器
    lazy var indicator: JXSegmentedIndicatorLineView = {
        let view = JXSegmentedIndicatorLineView()
        view.indicatorWidth = JXSegmentedViewAutomaticDimension
        view.lineStyle = .lengthen
        view.indicatorColor = cz_selectedColor
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(segmentedView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
