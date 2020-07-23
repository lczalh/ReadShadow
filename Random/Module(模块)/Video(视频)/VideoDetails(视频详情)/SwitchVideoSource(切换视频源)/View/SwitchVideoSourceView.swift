//
//  SwitchVideoSourceView.swift
//  Random
//
//  Created by yu mingming on 2020/7/23.
//  Copyright © 2020 刘超正. All rights reserved.
//

import UIKit

class SwitchVideoSourceView: BaseView {
    
    /// 标题
    var titleLabel: UILabel!
    
    lazy var tableView: UITableView = {
        let view = UITableView(frame: .zero, style: .plain)
            .cz
            .rowHeight(CZCommon.cz_dynamicFitHeight(30))
            .register(SwitchVideoSourceTableViewCell.self, forCellReuseIdentifier: SwitchVideoSourceTableViewCell.identifier)
            .backgroundColor(cz_backgroundColor)
            .separatorStyle(.none)
            .showsVerticalScrollIndicator(false)
            .build
        return view
    }()
    
    /// 关闭
    var closeButton: UIButton!

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        titleLabel = UILabel()
            .cz
            .addSuperView(self)
            .makeConstraints({ (make) in
                make.left.equalToSuperview().offset(15)
                make.top.equalToSuperview().offset(5)
                make.height.equalTo(CZCommon.cz_dynamicFitHeight(20))
            })
            .text("选择播放源")
            .font(.cz_boldSystemFont(14))
            .textColor(cz_standardTextColor)
            .build
        
        // 关闭
        closeButton = UIButton()
            .cz
            .addSuperView(self)
            .makeConstraints({ (make) in
                make.right.equalToSuperview().offset(-10)
                make.centerY.equalTo(titleLabel)
            })
            .image(UIImage(named: "Icon_Video_Introduction_Close"), for: .normal)
            .font(.cz_boldSystemFont(14))
            .titleColor(cz_standardTextColor, for: .normal)
            .build
        
        let lineView = UIView()
            .cz
            .addSuperView(self)
            .makeConstraints { (make) in
                make.left.right.equalToSuperview()
                make.top.equalTo(titleLabel.snp.bottom).offset(5)
                make.height.equalTo(1)
            }
            .backgroundColor(cz_dividerColor)
            .build
        
        tableView.cz.addSuperView(self).makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(lineView.snp.bottom)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

