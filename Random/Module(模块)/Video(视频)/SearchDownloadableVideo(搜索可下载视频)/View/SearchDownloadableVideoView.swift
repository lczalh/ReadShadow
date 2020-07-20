//
//  SearchDownloadableVideoView.swift
//  Random
//
//  Created by yu mingming on 2020/7/15.
//  Copyright © 2020 刘超正. All rights reserved.
//

import UIKit

class SearchDownloadableVideoView: BaseView {
    
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
        tableView.cz.addSuperView(self).makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
