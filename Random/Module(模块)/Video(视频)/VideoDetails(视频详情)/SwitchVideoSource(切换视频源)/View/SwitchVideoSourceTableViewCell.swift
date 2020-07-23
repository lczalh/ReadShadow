//
//  SwitchVideoSourceTableViewCell.swift
//  Random
//
//  Created by yu mingming on 2020/7/23.
//  Copyright © 2020 刘超正. All rights reserved.
//

import UIKit

class SwitchVideoSourceTableViewCell: BaseTableViewCell {
    
    static var identifier = "SwitchVideoSourceTableViewCell"
    
    /// 资源名
    var sourceNameLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        sourceNameLabel = UILabel()
            .cz
            .addSuperView(contentView)
            .makeConstraints({ (make) in
                make.centerY.equalToSuperview()
                make.left.equalToSuperview().offset(15)
            })
            .textColor(cz_unStandardTextColor)
            .font(.cz_systemFont(12))
            .setContentHuggingPriority(.required, for: .horizontal)
            .setContentCompressionResistancePriority(.required, for: .horizontal)
            .build
        
        let _ = UIView()
            .cz
            .addSuperView(contentView)
            .makeConstraints { (make) in
                make.right.left.bottom.equalToSuperview()
                make.height.equalTo(1)
            }
            .backgroundColor(cz_dividerColor)
            .build
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
