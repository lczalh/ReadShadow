//
//  BaseView.swift
//  Random
//
//  Created by 刘超正 on 2019/10/1.
//  Copyright © 2019 刘超正. All rights reserved.
//

import UIKit

class BaseView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = cz_backgroundColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
