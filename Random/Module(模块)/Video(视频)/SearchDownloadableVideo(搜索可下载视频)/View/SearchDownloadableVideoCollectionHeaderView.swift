//
//  SearchDownloadableVideoCollectionHeaderView.swift
//  Random
//
//  Created by yu mingming on 2020/7/15.
//  Copyright © 2020 刘超正. All rights reserved.
//

import UIKit

class SearchDownloadableVideoCollectionHeaderView: BaseCollectionReusableView {
    
    static var identifier = "SearchDownloadableVideoCollectionHeaderView"
    
    /// 标题
    var titleLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        titleLabel = UILabel()
            .cz
            .addSuperView(self)
            .makeConstraints({ (make) in
                make.left.equalToSuperview().offset(15)
                make.right.equalToSuperview().offset(-15)
                make.centerY.equalToSuperview()
            })
            .font(.cz_boldSystemFont(16))
            .build
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
