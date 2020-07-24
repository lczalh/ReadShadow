//
//  TelevisionView.swift
//  Random
//
//  Created by yu mingming on 2020/3/6.
//  Copyright © 2020 刘超正. All rights reserved.
//

import UIKit

class TelevisionView: BaseView {

    /// 搜索视图
    private lazy var searchFeatureView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: CZCommon.cz_screenWidth, height: CZCommon.cz_dynamicFitHeight(40)))
        return view
    }()
    
    /// 搜索图标
    private var searchImageView: UIImageView!
    
    /// 搜索提示文字
    private var searchLabel: UILabel!
    
    /// 点击搜索提示文字的回调
    var tapSearchLabelBlock: ((_ recognizer: UITapGestureRecognizer) -> Void)?
    
    /// 初始化JXSegmentedView
    lazy var segmentedView: JXSegmentedView = {
        let view = JXSegmentedView(frame: CGRect(x: 0, y: searchFeatureView.height, width: CZCommon.cz_screenWidth, height: CZCommon.cz_dynamicFitHeight(40)))
        view.dataSource = self.segmentedDataSource
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
        addSubview(searchFeatureView)
        searchImageView = UIImageView()
            .cz
            .addSuperView(searchFeatureView)
            .makeConstraints({ (make) in
                make.centerY.equalToSuperview()
                make.left.equalToSuperview().offset(15)
            })
            .image(UIImage(named: "Icon_Video_Search")?.cz_alterColor(color: cz_selectedColor))
            .contentMode(.scaleAspectFit)
            .setContentHuggingPriority(.required, for: .horizontal)
            .setContentCompressionResistancePriority(.required, for: .horizontal)
            .build
        
        let tapSearchLabel = UITapGestureRecognizer(target: self, action: #selector(tapSearchLabelAction))
        searchLabel = UILabel()
            .cz
            .addSuperView(searchFeatureView)
            .makeConstraints({ (make) in
                make.centerY.equalToSuperview()
                make.left.equalTo(searchImageView.snp.right).offset(10)
                make.right.equalToSuperview().offset(-15)
            })
            .isUserInteractionEnabled(true)
            .text("请输入频道名称")
            .font(UIFont.cz_systemFont(14))
            .textColor(cz_unStandardTextColor)
            .addGestureRecognizer(tapSearchLabel)
            .build
        
        let _ = UIView()
            .cz
            .addSuperView(searchFeatureView)
            .makeConstraints { (make) in
                make.left.right.bottom.equalToSuperview()
                make.height.equalTo(1)
            }
            .backgroundColor(cz_dividerColor)
            .build
        addSubview(segmentedView)
    }
    
    ///
    @objc func tapSearchLabelAction(recognizer: UITapGestureRecognizer) {
        if tapSearchLabelBlock != nil {
            tapSearchLabelBlock!(recognizer)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
