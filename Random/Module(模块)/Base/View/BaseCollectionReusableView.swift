//
//  BaseCollectionReusableView.swift
//  Random
//
//  Created by yu mingming on 2020/6/5.
//  Copyright © 2020 刘超正. All rights reserved.
//

import UIKit

class BaseCollectionReusableView: UICollectionReusableView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = cz_backgroundColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
