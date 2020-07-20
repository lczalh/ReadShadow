//
//  OutlineTableViewCell.swift
//  Random
//
//  Created by yu mingming on 2019/11/11.
//  Copyright © 2019 刘超正. All rights reserved.
//

import UIKit

class OutlineTableViewCell: BaseTableViewCell {
    
    public static let identifier = "OutlineTableViewCell"
    
    /// 概要
    var outlineLabel: QMUILabel!

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
        outlineLabel = QMUILabel()
            .cz
            .addSuperView(contentView)
            .makeConstraints({ (make) in
                make.left.equalToSuperview().offset(15)
                make.right.equalToSuperview().offset(-15)
                make.top.equalToSuperview()
                make.bottom.equalToSuperview().offset(-5)
            })
            .textColor(cz_unStandardTextColor)
            .font(UIFont.cz_systemFont(12))
            .numberOfLines(0)
            .build
        outlineLabel.canPerformCopyAction = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
