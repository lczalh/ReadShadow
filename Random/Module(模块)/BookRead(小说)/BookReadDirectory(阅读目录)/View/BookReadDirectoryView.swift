//
//  BookReadDirectoryView.swift
//  Random
//
//  Created by yu mingming on 2020/6/10.
//  Copyright © 2020 刘超正. All rights reserved.
//

import UIKit

class BookReadDirectoryView: BaseView {

    lazy var tableView: UITableView = {
        return UITableView(frame: .zero, style: .plain)
                .cz
            .rowHeight(CZCommon.cz_dynamicFitHeight(40))
                .register(BookReadDirectoryTableViewCell.self, forCellReuseIdentifier: BookReadDirectoryTableViewCell.identifier)
//                .register(VideoSearchTableViewCell.self, forCellReuseIdentifier: VideoSearchTableViewCell.identifier)
//                .register(BookReadIntroductionTableViewCell.self, forCellReuseIdentifier: BookReadIntroductionTableViewCell.identifier)
//                .register(BookReadNewestTableViewCell.self, forCellReuseIdentifier: BookReadNewestTableViewCell.identifier)
                .backgroundColor(cz_backgroundColor)
                .separatorStyle(.none)
                .keyboardDismissMode(.onDrag)
                .contentInset(UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
                .build
    }()
    
    /// 章节数量
    var chapterNumberLabel: UILabel!
    
    /// 连载状态
    var serialStateLabel: UILabel!

    override init(frame: CGRect) {
        super.init(frame: frame)
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: CZCommon.cz_screenWidth, height: CZCommon.cz_dynamicFitHeight(40)))
        headerView.cz.addSuperView(self)
        
        serialStateLabel = UILabel()
            .cz
            .addSuperView(headerView)
            .makeConstraints { (make) in
                make.left.equalToSuperview().offset(15)
                make.centerY.equalToSuperview()
            }
            .font(.cz_systemFont(14))
            .textColor(cz_standardTextColor)
            .build
        
        chapterNumberLabel = UILabel()
            .cz
            .addSuperView(headerView)
            .makeConstraints { (make) in
                make.left.equalTo(serialStateLabel.snp.right).offset(10)
                make.centerY.equalToSuperview()
            }
            .font(.cz_systemFont(14))
            .textColor(cz_standardTextColor)
            .build
        
        tableView.cz.addSuperView(self).makeConstraints({ (make) in
            make.top.equalTo(headerView.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        })
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
