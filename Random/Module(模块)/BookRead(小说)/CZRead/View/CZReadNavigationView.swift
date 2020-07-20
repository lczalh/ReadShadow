//
//  CZReadView.swift
//  Random
//
//  Created by yu mingming on 2020/5/6.
//  Copyright © 2020 刘超正. All rights reserved.
//

import UIKit

class CZReadNavigationView: BaseView {
    
    /// 返回按钮
    var returnButton: UIButton!
    
    /// 目录
    var directoryButton: UIButton!

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = cz_readNaviTabBarBackgroundColor
        let navigationView = UIView(frame: CGRect(x: 0, y: CZCommon.cz_statusBarHeight, width: CZCommon.cz_screenWidth, height: CZCommon.cz_navigationHeight)).cz.addSuperView(self).build
        returnButton = UIButton()
            .cz
            .addSuperView(navigationView)
            .makeConstraints({ (make) in
                make.left.equalToSuperview().offset(5)
                make.centerY.equalToSuperview()
            })
            .image(UIImage(named: "Icon_Return")?.cz_alterColor(color: cz_readNaviTabBarTextColor), for: .normal)
            .contentMode(.scaleAspectFit)
            .build
        
        directoryButton = UIButton()
            .cz
            .addSuperView(navigationView)
            .makeConstraints({ (make) in
                make.right.equalToSuperview().offset(-15)
                make.centerY.equalToSuperview()
            })
            .title("目录", for: .normal)
            .titleColor(cz_readNaviTabBarTextColor, for: .normal)
            .font(UIFont.cz_systemFont(16))
            .contentMode(.scaleAspectFit)
            .isHidden(true)
            .build
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
