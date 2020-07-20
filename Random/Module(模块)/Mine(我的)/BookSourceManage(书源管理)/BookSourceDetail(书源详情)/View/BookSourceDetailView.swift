//
//  BookSourceDetailView.swift
//  Random
//
//  Created by yu mingming on 2020/6/29.
//  Copyright © 2020 刘超正. All rights reserved.
//

import UIKit

class BookSourceDetailView: BaseView {
    
    var tableView: UITableView!

    override init(frame: CGRect) {
        super.init(frame: frame)
        tableView = UITableView(frame: .zero, style: .grouped)
        .cz
        .addSuperView(self)
        .makeConstraints({ (make) in
            make.edges.equalToSuperview()
        })
        .rowHeight(CZCommon.cz_dynamicFitHeight(40))
        .register(LeftTitleRightLabelTableViewCell.self, forCellReuseIdentifier: LeftTitleRightLabelTableViewCell.identifier)
        .register(BookReadHeaderView.self, forHeaderFooterViewReuseIdentifier: BookReadHeaderView.identifier)
        .backgroundColor(cz_backgroundColor)
        .separatorStyle(.none)
        .contentInset(UIEdgeInsets(top: 0, left: 0, bottom: CZCommon.cz_dynamicFitHeight(40), right: 0))
        .build
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
