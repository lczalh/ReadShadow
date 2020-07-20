//
//  StartupPageView.swift
//  Random
//
//  Created by yu mingming on 2020/7/8.
//  Copyright © 2020 刘超正. All rights reserved.
//

import UIKit

class StartupPageView: BaseView {
    
    /// 启动图片
    var startupImageView: UIImageView!

    override init(frame: CGRect) {
        super.init(frame: frame)
        startupImageView = UIImageView()
            .cz
            .addSuperView(self)
            .makeConstraints({ (make) in
                make.edges.equalToSuperview()
            })
            .contentMode(.scaleAspectFill)
            .clipsToBounds(true)
            .image(UIImage(named: "Icon_Banner_One"))
            .build
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
