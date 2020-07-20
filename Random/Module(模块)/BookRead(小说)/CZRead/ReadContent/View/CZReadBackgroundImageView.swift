//
//  CZReadBackgroundView.swift
//  Random
//
//  Created by yu mingming on 2020/5/9.
//  Copyright © 2020 刘超正. All rights reserved.
//

import UIKit

class CZReadBackgroundImageView: UIImageView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = bookReadThemeColor
        contentMode = .scaleAspectFill
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
