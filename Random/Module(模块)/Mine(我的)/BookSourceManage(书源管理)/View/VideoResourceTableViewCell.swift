//
//  VideoResourceTableViewCell.swift
//  Random
//
//  Created by yu mingming on 2019/12/18.
//  Copyright © 2019 刘超正. All rights reserved.
//

import UIKit

class VideoResourceTableViewCell: SwipeTableViewCell {
    
    static var identifier = "VideoResourceTableViewCell"
    
    /// 标题
    var titleLabel: UILabel!
    
    /// 选中显示的图片
    var selectorImageView: UIImageView!

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
        selectionStyle = .none
        titleLabel = UILabel()
            .cz
            .addSuperView(contentView)
            .makeConstraints({ (make) in
                make.left.equalToSuperview().offset(15)
                make.centerY.equalToSuperview()
            })
            .font(UIFont.cz_systemFont(14))
            .textColor(cz_standardTextColor)
            .build
        
        selectorImageView = UIImageView()
            .cz
            .addSuperView(contentView)
            .makeConstraints({ (make) in
                make.right.equalToSuperview().offset(-15)
                make.centerY.equalToSuperview()
                make.size.equalTo(CZCommon.cz_screenWidthScale * 20)
            })
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
}
