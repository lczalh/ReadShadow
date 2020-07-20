//
//  BrowsingHistoryTableViewCell.swift
//  Random
//
//  Created by yu mingming on 2020/7/2.
//  Copyright © 2020 刘超正. All rights reserved.
//

import UIKit

class BrowsingHistoryTableViewCell: BaseTableViewCell {
    
    static var identifier = "BrowsingHistoryTableViewCell"
    
    /// 图片
    var leftImageView: UIImageView!
    
    /// 名称
    var nameLabel: UILabel!
    
    /// 详情
    var detailsLabel: UILabel!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        leftImageView = UIImageView()
            .cz
            .addSuperView(contentView)
            .makeConstraints({ (make) in
                make.left.equalToSuperview().offset(15)
                make.centerY.equalToSuperview()
                make.width.equalTo(CZCommon.cz_dynamicFitWidth(150))
                make.height.equalTo(CZCommon.cz_dynamicFitHeight(80))
            })
            .backgroundColor(.red)
            .cornerRadius(5)
            .clipsToBounds(true)
            .setContentHuggingPriority(.required, for: .horizontal)
            .setContentCompressionResistancePriority(.required, for: .horizontal)
            .contentMode(.scaleAspectFill)
            .build
        
        nameLabel = UILabel()
            .cz
            .addSuperView(contentView)
            .makeConstraints({ (make) in
                make.left.equalTo(leftImageView.snp.right).offset(10)
                make.top.equalTo(leftImageView).offset(5)
                make.right.equalToSuperview().offset(-15)
            })
            .font(.cz_boldSystemFont(14))
            .textColor(cz_standardTextColor)
            .numberOfLines(2)
            .build
        
        detailsLabel = UILabel()
            .cz
            .addSuperView(contentView)
            .makeConstraints({ (make) in
                make.left.equalTo(leftImageView.snp.right).offset(10)
                make.top.equalTo(nameLabel.snp.bottom).offset(10)
                make.right.equalToSuperview().offset(-15)
            })
            .textColor(cz_unStandardTextColor)
            .font(.cz_systemFont(12))
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
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
