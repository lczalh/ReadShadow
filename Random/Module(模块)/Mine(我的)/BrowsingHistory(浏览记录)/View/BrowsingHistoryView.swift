//
//  BrowsingHistoryView.swift
//  Random
//
//  Created by yu mingming on 2020/7/2.
//  Copyright © 2020 刘超正. All rights reserved.
//

import UIKit

class BrowsingHistoryView: BaseView {

    lazy var tableView: UITableView = {
        let view = UITableView(frame: .zero, style: .plain)
            .cz
            .register(BrowsingHistoryTableViewCell.self, forCellReuseIdentifier: BrowsingHistoryTableViewCell.identifier)
            .separatorStyle(.none)
            .backgroundColor(cz_backgroundColor)
            .rowHeight(CZCommon.cz_dynamicFitHeight(100))
            .build
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        tableView.cz.addSuperView(self).makeConstraints({ (make) in
            make.edges.equalToSuperview()
        })
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
