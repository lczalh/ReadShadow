//
//  DeviceIdentifierTabelHeaderView.swift
//  Random
//
//  Created by yu mingming on 2020/6/24.
//  Copyright © 2020 刘超正. All rights reserved.
//

import UIKit

class DeviceIdentifierTabelHeaderView: BaseTableHeaderFooterView {
    
    static var identifier = "DeviceIdentifierTabelHeaderView"
    
    /// 左图标
    var leftImageView: UIImageView!
    
    /// 标题
    var titleLabel: UILabel!
    
    /// 右标签
    var rightLabel: QMUILabel!
    
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
            .setContentHuggingPriority(.required, for: .horizontal)
            .setContentCompressionResistancePriority(.required, for: .horizontal)
            .build
        
        rightLabel = QMUILabel()
            .cz
            .addSuperView(contentView)
            .makeConstraints({ (make) in
                make.left.equalTo(titleLabel.snp.right).offset(15)
                make.right.equalToSuperview().offset(-15)
                make.centerY.equalToSuperview()
            })
            .text(UIDevice.vkKeychainIDFV())
            .textColor(cz_placeholderColor)
            .font(.cz_systemFont(12))
            .textAlignment(.right)
            .build
        rightLabel.canPerformCopyAction = true
        
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
