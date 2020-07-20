//
//  VideoSearchView.swift
//  Random
//
//  Created by yu mingming on 2020/6/3.
//  Copyright © 2020 刘超正. All rights reserved.
//

import UIKit

class VideoSearchView: BaseView {
    
    private var searchView: UIView!
    
    /// 取消按钮
    var cancelButton: UIButton!
    
    /// 搜索输入框
    var searchTextField: QMUITextField!
    
    lazy var tableView: UITableView = {
        return UITableView(frame: .zero, style: .plain)
                .cz
                .rowHeight(CZCommon.cz_dynamicFitHeight(40))
                .register(VideoSearchTableViewCell.self, forCellReuseIdentifier: VideoSearchTableViewCell.identifier)
                .register(BookReadHeaderView.self, forHeaderFooterViewReuseIdentifier: BookReadHeaderView.identifier)
                .backgroundColor(cz_backgroundColor)
                .separatorStyle(.none)
                .keyboardDismissMode(.onDrag)
                .build
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        createSearchView()
        tableView.cz.addSuperView(self).makeConstraints({ (make) in
            make.top.equalTo(searchView.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        })
    }
    
    private func createSearchView() {
        searchView = UIView()
        searchView.cz.addSuperView(self).makeConstraints { (make) in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(44)
        }
        
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
        
        searchTextField = QMUITextField()
            .cz
            .addSuperView(searchView)
            .makeConstraints({ (make) in
                make.centerY.equalToSuperview()
                make.left.equalTo(searchImageView.snp.right).offset(10)
                make.right.equalTo(cancelButton.snp.left).offset(-15)
            })
            .clearButtonMode(.always)
            .placeholder("请输入视频名称")
            .textColor(cz_standardTextColor)
            .font(.systemFont(ofSize: 16))
            .tintColor(cz_standardTextColor)
            .build
        searchTextField.placeholderColor = cz_unStandardTextColor
        searchTextField.becomeFirstResponder()
        
        let _ = UIView()
            .cz
            .addSuperView(searchView)
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
