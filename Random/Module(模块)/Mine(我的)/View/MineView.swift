//
//  MineView.swift
//  Random
//
//  Created by yu mingming on 2020/6/1.
//  Copyright © 2020 刘超正. All rights reserved.
//

import UIKit

class MineView: BaseView {

    lazy var tableView: UITableView = {
        let view = UITableView(frame: .zero, style: .plain)
            .cz
            .register(MineTableHeaderView.self, forHeaderFooterViewReuseIdentifier: MineTableHeaderView.identifier)
            .register(DeviceIdentifierTabelHeaderView.self, forHeaderFooterViewReuseIdentifier: DeviceIdentifierTabelHeaderView.identifier)
            .register(RecordTableViewCell.self, forCellReuseIdentifier: RecordTableViewCell.identifier)
            .separatorStyle(.none)
            .backgroundColor(cz_backgroundColor)
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
