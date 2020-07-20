//
//  BaseTableHeaderFooterView.swift
//  Random
//
//  Created by yu mingming on 2019/10/17.
//  Copyright © 2019 刘超正. All rights reserved.
//

import UIKit

class BaseTableHeaderFooterView: UITableViewHeaderFooterView {

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = cz_backgroundColor
        backgroundColor = cz_backgroundColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
