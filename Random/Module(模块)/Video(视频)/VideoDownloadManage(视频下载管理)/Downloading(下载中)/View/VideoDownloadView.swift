//
//  VideoDownloadManageView.swift
//  Random
//
//  Created by yu mingming on 2019/11/15.
//  Copyright © 2019 刘超正. All rights reserved.
//

import UIKit

class VideoDownloadView: BaseView {

    var tableView: UITableView!
    

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        tableView = UITableView(frame: .zero, style: .plain)
            .cz
            .addSuperView(self)
            .makeConstraints({ (make) in
                make.edges.equalToSuperview()
            })
            .rowHeight(CZCommon.cz_dynamicFitHeight(70))
            .register(VideoDownloadTableViewCell.self, forCellReuseIdentifier: VideoDownloadTableViewCell.identifier)
            .backgroundColor(cz_backgroundColor)
            .separatorStyle(.none)
            .build
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
