//
//  BookReadDetailsView.swift
//  Random
//
//  Created by yu mingming on 2020/6/9.
//  Copyright © 2020 刘超正. All rights reserved.
//

import UIKit

class BookReadDetailsView: BaseView {
    
    lazy var tableView: UITableView = {
        return UITableView(frame: .zero, style: .plain)
                .cz
                .rowHeight(UITableView.automaticDimension)
                .estimatedRowHeight(100)
                .register(BookReadBasicInfoTableViewCell.self, forCellReuseIdentifier: BookReadBasicInfoTableViewCell.identifier)
                .register(BookReadIntroductionTableViewCell.self, forCellReuseIdentifier: BookReadIntroductionTableViewCell.identifier)
                .register(BookReadNewestTableViewCell.self, forCellReuseIdentifier: BookReadNewestTableViewCell.identifier)
                .register(BookReadDetailsHeaderView.self, forHeaderFooterViewReuseIdentifier: BookReadDetailsHeaderView.identifier)
                .backgroundColor(cz_backgroundColor)
                .separatorStyle(.none)
                .keyboardDismissMode(.onDrag)
                .contentInset(UIEdgeInsets(top: 0, left: 0, bottom: CZCommon.cz_dynamicFitHeight(40) + 15, right: 0))
                .build
    }()
    
    /// 阅读按钮
    var readButton: UIButton!
    
    /// 加入书架
    var addBookcaseButton: UIButton!

    override init(frame: CGRect) {
        super.init(frame: frame)
        tableView.cz.addSuperView(self).makeConstraints({ (make) in
            make.edges.equalToSuperview()
        })
        
        let bottomView = UIView()
            .cz
            .addSuperView(self)
            .makeConstraints { (make) in
                make.bottom.left.right.equalToSuperview()
                make.height.equalTo(CZCommon.cz_dynamicFitHeight(40))
            }
            .backgroundColor(cz_backgroundColor)
            .build
        
        readButton = UIButton()
            .cz
            .addSuperView(self)
            .makeConstraints({ (make) in
                make.centerX.equalToSuperview()
                make.bottom.equalToSuperview().offset(-15)
                make.width.equalTo(CZCommon.cz_dynamicFitWidth(100))
                make.height.equalTo(CZCommon.cz_dynamicFitHeight(40))
            })
            .cornerRadius(CZCommon.cz_dynamicFitHeight(20))
            .clipsToBounds(true)
            .backgroundColor(cz_selectedColor)
            .titleColor(UIColor.white, for: .normal)
            .font(.cz_systemFont(16))
            .build
        
        addBookcaseButton = UIButton()
            .cz
            .addSuperView(bottomView)
            .makeConstraints({ (make) in
                make.centerY.equalToSuperview()
                make.right.equalToSuperview()
                make.left.equalTo(readButton.snp.right)
            })
            .font(.cz_systemFont(12))
            .build
        
    }
    
    func createFooterView() {
        
            
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
