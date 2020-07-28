//
//  BookReadDirectoryTableViewCell.swift
//  Random
//
//  Created by yu mingming on 2020/6/10.
//  Copyright © 2020 刘超正. All rights reserved.
//

import UIKit

class BookReadDirectoryTableViewCell: BaseTableViewCell {
    
    static var identifier = "BookReadDirectoryTableViewCell"
    
    /// 章节名称
    var chapterNameLabel: UILabel!

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
        chapterNameLabel = UILabel()
           .cz
           .addSuperView(contentView)
           .makeConstraints({ (make) in
                make.left.equalToSuperview().offset(15)
                make.centerY.equalToSuperview()
                make.right.equalToSuperview().offset(-15)
           })
           .font(.cz_systemFont(12))
           .textColor(cz_unStandardTextColor)
           .setContentHuggingPriority(.required, for: .horizontal)
           .setContentCompressionResistancePriority(.required, for: .horizontal)
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
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
