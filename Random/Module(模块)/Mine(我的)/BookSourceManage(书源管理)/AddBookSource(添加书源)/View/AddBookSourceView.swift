//
//  AddBookSourceView.swift
//  Random
//
//  Created by yu mingming on 2020/6/12.
//  Copyright © 2020 刘超正. All rights reserved.
//

import UIKit

class AddBookSourceView: BaseView {
    
    var tableView: UITableView!
    
    /// 添加按钮
    var addButton: UIButton!

    override init(frame: CGRect) {
        super.init(frame: frame)
        tableView = UITableView(frame: .zero, style: .grouped)
        .cz
        .addSuperView(self)
        .makeConstraints({ (make) in
            make.edges.equalToSuperview()
        })
        .rowHeight(CZCommon.cz_dynamicFitHeight(40))
        .register(LeftTitleRightTextFieldTableViewCell.self, forCellReuseIdentifier: LeftTitleRightTextFieldTableViewCell.identifier)
        .register(BookReadHeaderView.self, forHeaderFooterViewReuseIdentifier: BookReadHeaderView.identifier)
        .backgroundColor(cz_backgroundColor)
        .separatorStyle(.none)
        .contentInset(UIEdgeInsets(top: 0, left: 0, bottom: CZCommon.cz_dynamicFitHeight(40), right: 0))
        .build
        
        addButton = UIButton()
            .cz
            .addSuperView(self)
            .makeConstraints({ (make) in
                make.left.right.bottom.equalToSuperview()
                make.height.equalTo(CZCommon.cz_dynamicFitHeight(40))
            })
            .title("确定", for: .normal)
            .titleColor(UIColor.white, for: .normal)
            .backgroundColor(cz_selectedColor)
            .font(.cz_systemFont(14))
            .build
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
