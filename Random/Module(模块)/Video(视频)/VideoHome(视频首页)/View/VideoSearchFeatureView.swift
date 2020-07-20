//
//  VideoSearchView.swift
//  Random
//
//  Created by yu mingming on 2020/6/3.
//  Copyright © 2020 刘超正. All rights reserved.
//

import UIKit

class VideoSearchFeatureView: BaseView {
    
    /// 搜索图标
    var searchImageView: UIImageView!
    
    /// 搜索提示文字
    var searchLabel: UILabel!
    
    /// 缓存按钮
    var cacheButton: UIButton!
    
    /// 资源按钮
    var resourceButton: UIButton!
    
    /// 电视按钮
    var televisionButton: UIButton!
    
    /// 点击搜索提示文字的回调
    var tapSearchLabelBlock: ((_ recognizer: UITapGestureRecognizer) -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        searchImageView = UIImageView()
            .cz
            .addSuperView(self)
            .makeConstraints({ (make) in
                make.centerY.equalToSuperview()
                make.left.equalToSuperview().offset(15)
            })
            .image(UIImage(named: "Icon_Video_Search")?.cz_alterColor(color: cz_selectedColor))
            .contentMode(.scaleAspectFit)
            .setContentHuggingPriority(.required, for: .horizontal)
            .setContentCompressionResistancePriority(.required, for: .horizontal)
            .build
        
        // 缓存
        cacheButton = UIButton()
            .cz
            .addSuperView(self)
            .makeConstraints({ (make) in
                make.centerY.equalToSuperview()
                make.right.equalToSuperview().offset(-15)
            })
            .image(UIImage(named: "Icon_Home_Video_Download")?.cz_alterColor(color: cz_unselectedColor), for: .normal)
            .setContentHuggingPriority(.required, for: .horizontal)
            .setContentCompressionResistancePriority(.required, for: .horizontal)
            .build
        
        let tapSearchLabel = UITapGestureRecognizer(target: self, action: #selector(tapSearchLabelAction))
        searchLabel = UILabel()
            .cz
            .addSuperView(self)
            .makeConstraints({ (make) in
                make.centerY.equalToSuperview()
                make.left.equalTo(searchImageView.snp.right).offset(10)
                make.right.equalTo(cacheButton.snp.left).offset(-15)
            })
            .isUserInteractionEnabled(true)
            .text("请输入影片名称")
            .font(UIFont.cz_systemFont(14))
            .textColor(cz_unStandardTextColor)
            .addGestureRecognizer(tapSearchLabel)
            .build
        
        
        let _ = UIView()
            .cz
            .addSuperView(self)
            .makeConstraints { (make) in
                make.left.right.bottom.equalToSuperview()
                make.height.equalTo(1)
            }
            .backgroundColor(cz_dividerColor)
            .build
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
