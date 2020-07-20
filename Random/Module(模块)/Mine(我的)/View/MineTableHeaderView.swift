//
//  MineTableHeaderView.swift
//  Random
//
//  Created by yu mingming on 2020/6/5.
//  Copyright © 2020 刘超正. All rights reserved.
//

import UIKit

class MineTableHeaderView: BaseTableHeaderFooterView {
    
    static var identifier = "MineTableHeaderView"
    
    /// 左图标
    var leftImageView: UIImageView!
    
    /// 标题
    var titleLabel: UILabel!
    
    /// 右图标
    var rightImageView: UIImageView!
    
    /// 点击事件
    var tapBlock: ((_ recognizer: UITapGestureRecognizer) -> Void)?

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapGestureRecognizerAction))
        contentView.addGestureRecognizer(tapGestureRecognizer)
        
        leftImageView = UIImageView()
            .cz
            .addSuperView(contentView)
            .makeConstraints({ (make) in
                make.left.equalToSuperview().offset(15)
                make.centerY.equalToSuperview()
            })
            .contentMode(.scaleAspectFit)
            .build
        
        titleLabel = UILabel()
            .cz
            .addSuperView(contentView)
            .makeConstraints({ (make) in
                make.left.equalTo(leftImageView.snp.right).offset(10)
                make.centerY.equalToSuperview()
            })
            .font(.cz_systemFont(14))
            .textColor(cz_standardTextColor)
            .build
        
        rightImageView = UIImageView()
            .cz
            .addSuperView(contentView)
            .makeConstraints({ (make) in
                make.right.equalToSuperview().offset(-10)
                make.centerY.equalToSuperview()
            })
            .image(UIImage(named: "Icon_RightArrow"))
            .contentMode(.scaleAspectFit)
            .build
        
        let _ = UIView()
            .cz
            .addSuperView(self)
            .makeConstraints { (make) in
                make.right.bottom.equalToSuperview()
                make.left.equalToSuperview().offset(15)
                make.height.equalTo(1)
            }
            .backgroundColor(cz_dividerColor)
            .build
    }
    
    @objc func tapGestureRecognizerAction(recognizer: UITapGestureRecognizer) {
        if tapBlock != nil {
            tapBlock!(recognizer)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
