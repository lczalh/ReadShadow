//
//  TelevisionSearchView.swift
//  Random
//
//  Created by yu mingming on 2020/7/9.
//  Copyright © 2020 刘超正. All rights reserved.
//

import UIKit

class TelevisionSearchView: BaseView {

    private var searchView: UIView!
    
    /// 取消按钮
    var cancelButton: UIButton!
    
    /// 搜索输入框
    var searchTextField: UITextField!
    
    /// 搜索结果表视图
    var searchResultTableView: UITableView!

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = cz_backgroundColor
        searchView = UIView()
            .cz.addSuperView(self).makeConstraints { (make) in
                make.left.right.top.equalToSuperview()
                make.height.equalTo(44)
            }
            .setContentHuggingPriority(.required, for: .vertical)
            .setContentCompressionResistancePriority(.required, for: .vertical)
            .build
        
        let searchImageView = UIImageView()
            .cz
            .addSuperView(searchView)
            .makeConstraints({ (make) in
                make.centerY.equalToSuperview()
                make.left.equalToSuperview().offset(15)
            })
            .image(UIImage(named: "Icon_Video_Search"))
            .setContentHuggingPriority(.required, for: .horizontal)
            .setContentCompressionResistancePriority(.required, for: .horizontal)
            .build
        
        cancelButton = UIButton()
            .cz
            .addSuperView(searchView)
            .makeConstraints { (make) in
                make.right.equalToSuperview().offset(-15)
                make.centerY.equalToSuperview()
            }
            .title("取消", for: .normal)
            .titleColor(cz_standardTextColor, for: .normal)
            .font(.systemFont(ofSize: 14))
            .setContentHuggingPriority(.required, for: .horizontal)
            .setContentCompressionResistancePriority(.required, for: .horizontal)
            .build
        
        searchTextField = UITextField()
            .cz
            .addSuperView(searchView)
            .makeConstraints({ (make) in
                make.centerY.equalToSuperview()
                make.left.equalTo(searchImageView.snp.right).offset(10)
                make.right.equalTo(cancelButton.snp.left).offset(-15)
            })
            .clearButtonMode(.always)
            .textColor(cz_standardTextColor)
            .font(.systemFont(ofSize: 16))
            .tintColor(cz_standardTextColor)
            .placeholder("请输入频道名称")
            .build
        
        let _ = UIView()
            .cz
            .addSuperView(searchView)
            .makeConstraints { (make) in
                make.left.right.bottom.equalToSuperview()
                make.height.equalTo(1)
            }
            .backgroundColor(cz_dividerColor)
            .build
        
        searchResultTableView = UITableView(frame: .zero, style: .plain)
            .cz
            .addSuperView(self).makeConstraints({ (make) in
                make.top.equalTo(searchView.snp.bottom)
                make.left.right.bottom.equalToSuperview()
            })
            .rowHeight(CZCommon.cz_dynamicFitHeight(40))
            .register(VideoSearchTableViewCell.self, forCellReuseIdentifier: VideoSearchTableViewCell.identifier)
            .register(BookReadHeaderView.self, forHeaderFooterViewReuseIdentifier: BookReadHeaderView.identifier)
            .backgroundColor(cz_backgroundColor)
            .separatorStyle(.none)
            .keyboardDismissMode(.onDrag)
            .build
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
