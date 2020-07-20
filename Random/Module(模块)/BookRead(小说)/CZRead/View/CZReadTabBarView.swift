//
//  CZReadTabBarView.swift
//  Random
//
//  Created by yu mingming on 2020/6/15.
//  Copyright © 2020 刘超正. All rights reserved.
//

import UIKit

class CZReadTabBarView: BaseView {
    
    lazy var stackView: UIStackView = {
        let view = UIStackView(frame: CGRect(x: 0, y: 0, width: CZCommon.cz_screenWidth, height: CZCommon.cz_navigationHeight))
        view.alignment = .center
        view.axis = .horizontal
        view.distribution = .fillEqually
        return view
    }()
    
    /// 目录
    var directoryButton: UIButton!
    
    /// 亮度
    var brightnessButton: UIButton!
    
//    /// 主题
//    var themeButton: UIButton!
    
    /// 字号
    var wordSizeButton: UIButton!
    
    /// 字体
    var fontButton: UIButton!
    
    /// 点击目录回调
//    var tapDirectoryBlock: ((_ sender: UIButton) -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = cz_readNaviTabBarBackgroundColor
        directoryButton = UIButton()
            .cz
            .titleColor(cz_readNaviTabBarTextColor, for: .normal)
            .title("目录", for: .normal)
            .titleColor(cz_selectedColor, for: .selected)
            .font(.systemFont(ofSize: 14))
            .build
        
        brightnessButton = UIButton()
            .cz
            .titleColor(cz_readNaviTabBarTextColor, for: .normal)
            .titleColor(cz_selectedColor, for: .selected)
            .title("亮度", for: .normal)
            .font(.systemFont(ofSize: 14))
            .build
        
//        themeButton = UIButton()
//           .cz
//           .titleColor(cz_readNaviTabBarTextColor, for: .normal)
//           .title("主题", for: .normal)
//           .font(.systemFont(ofSize: 14))
//           .build
        
        wordSizeButton = UIButton()
            .cz
            .titleColor(cz_readNaviTabBarTextColor, for: .normal)
            .titleColor(cz_selectedColor, for: .selected)
            .title("字号", for: .normal)
            .font(.systemFont(ofSize: 14))
            .build
        
        fontButton = UIButton()
            .cz
            .titleColor(cz_readNaviTabBarTextColor, for: .normal)
            .titleColor(cz_selectedColor, for: .selected)
            .title("字体", for: .normal)
            .font(.systemFont(ofSize: 14))
            .build
        stackView.addArrangedSubview(directoryButton)
        stackView.addArrangedSubview(brightnessButton)
        stackView.addArrangedSubview(wordSizeButton)
        stackView.addArrangedSubview(fontButton)
        addSubview(stackView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    @objc func directoryAction(sender: UIButton) {
//        if tapDirectoryBlock != nil {
//            sender.isSelected = !sender.isSelected
//            tapDirectoryBlock!(sender)
//        }
//    }
    
}
