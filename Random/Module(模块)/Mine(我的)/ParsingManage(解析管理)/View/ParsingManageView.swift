//
//  ParsingManageView.swift
//  Random
//
//  Created by yu mingming on 2020/7/24.
//  Copyright © 2020 刘超正. All rights reserved.
//

import UIKit

class ParsingManageView: BaseView {

    var tableView: UITableView!

    override init(frame: CGRect) {
        super.init(frame: frame)
        tableView = UITableView(frame: .zero, style: .plain)
        .cz
        .addSuperView(self)
        .makeConstraints({ (make) in
            make.edges.equalToSuperview()
        })
        .rowHeight(CZCommon.cz_dynamicFitHeight(40))
        .register(VideoResourceTableViewCell.self, forCellReuseIdentifier: VideoResourceTableViewCell.identifier)
        .backgroundColor(cz_backgroundColor)
        .separatorStyle(.none)
        .build
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
