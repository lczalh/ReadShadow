//
//  LeftTitleRightLabelTableViewCell.swift
//  Random
//
//  Created by yu mingming on 2020/6/29.
//  Copyright © 2020 刘超正. All rights reserved.
//

import UIKit

class LeftTitleRightLabelTableViewCell: BaseTableViewCell {
    
    static var identifier = "LeftTitleRightLabelTableViewCell"
    
    /// 标题
    var titleLabel: UILabel!
    
    /// 输入框
    var rightLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
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
        
        rightLabel = UILabel()
            .cz
            .addSuperView(contentView)
            .makeConstraints({ (make) in
                make.right.equalToSuperview().offset(-15)
                make.centerY.equalToSuperview()
                make.left.equalTo(titleLabel.snp.right).offset(10)
            })
            .font(UIFont.cz_systemFont(14))
            .textColor(cz_unStandardTextColor)
            .textAlignment(.right)
            .adjustsFontSizeToFitWidth(true)
            .build
        
        
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
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
