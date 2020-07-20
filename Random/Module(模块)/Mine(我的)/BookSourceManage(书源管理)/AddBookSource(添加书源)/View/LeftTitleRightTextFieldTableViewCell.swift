//
//  LeftTitleRightTextFiledTableViewCell.swift
//  Random
//
//  Created by yu mingming on 2020/6/12.
//  Copyright © 2020 刘超正. All rights reserved.
//

import UIKit

class LeftTitleRightTextFieldTableViewCell: BaseTableViewCell {
    
    static var identifier = "LeftTitleRightTextFieldTableViewCell"
    
    /// 标题
    var titleLabel: UILabel!
    
    /// 输入框
    var textField: UITextField!
    
    /// 返回输入的值
    var returnInputText: ((_ text: String) -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        titleLabel = UILabel()
            .cz
            .addSuperView(contentView)
            .makeConstraints({ (make) in
                make.left.equalToSuperview().offset(15)
                make.centerY.equalToSuperview()
            })
            .font(UIFont.cz_systemFont(14))
            .textColor(cz_standardTextColor)
            .setContentHuggingPriority(.required, for: .horizontal)
            .setContentCompressionResistancePriority(.required, for: .horizontal)
            .build
        
        textField = UITextField()
            .cz
            .addSuperView(contentView)
            .makeConstraints({ (make) in
                make.right.equalToSuperview().offset(-15)
                make.centerY.equalToSuperview()
                make.left.equalTo(titleLabel.snp.right).offset(10)
            })
            .font(UIFont.cz_systemFont(14))
            .textColor(cz_standardTextColor)
            .textAlignment(.right)
            .build
        
        textField.rx.text.orEmpty.subscribe(onNext: {[weak self] (value) in
            if self?.returnInputText != nil {
                self!.returnInputText!(value)
            }
        }).disposed(by: rx.disposeBag)
        
        let _ = UIView()
            .cz
            .addSuperView(contentView)
            .makeConstraints { (make) in
                make.left.right.bottom.equalToSuperview()
                make.height.equalTo(1)
            }
            .backgroundColor(cz_dividerColor)
            .build
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
