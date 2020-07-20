//
//  TelevisionListView.swift
//  Random
//
//  Created by yu mingming on 2020/7/8.
//  Copyright © 2020 刘超正. All rights reserved.
//

import UIKit

class TelevisionListView: BaseView {

    var tableView: UITableView!

    override init(frame: CGRect) {
        super.init(frame: frame)
        tableView = UITableView(frame: .zero, style: .plain)
            .cz
            .addSuperView(self)
            .makeConstraints({ (make) in
                make.edges.equalToSuperview()
            })
            .rowHeight(CZCommon.cz_dynamicFitHeight(80))
            .backgroundColor(cz_backgroundColor)
            .separatorStyle(.none)
            .register(TelevisionTableViewCell.self, forCellReuseIdentifier: TelevisionTableViewCell.identifier)
            .build
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
