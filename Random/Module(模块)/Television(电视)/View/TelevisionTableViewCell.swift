//
//  TelevisionTableViewCell.swift
//  Random
//
//  Created by yu mingming on 2020/3/6.
//  Copyright © 2020 刘超正. All rights reserved.
//

import UIKit

class TelevisionTableViewCell: BaseTableViewCell {
    
    static var identifier = "TelevisionTableViewCell"
    
    /// 图片
    var logoImageView: UIImageView!
    
    /// 名称
    var televisionNameLabel: UILabel!
    
    /// 国家
    var countryLabel: UILabel!

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
        
        logoImageView = UIImageView()
            .cz
            .addSuperView(contentView)
            .makeConstraints({ (make) in
                make.left.equalToSuperview().offset(15)
                make.bottom.equalToSuperview().offset(-10)
                make.top.equalToSuperview().offset(10)
                make.width.equalTo(CZCommon.cz_dynamicFitWidth(120))
            })
            .contentMode(.scaleAspectFill)
            .clipsToBounds(true)
            .shadowOpacity(0.8)
            .shadowColor(cz_selectedColor)
            .shadowOffset(CGSize(width: 1, height: 1))
            .build
        
        televisionNameLabel = UILabel()
            .cz
            .addSuperView(contentView)
            .makeConstraints { (make) in
                make.left.equalTo(logoImageView.snp.right).offset(10)
                make.top.equalTo(logoImageView.snp.top)
                make.right.equalToSuperview().offset(-15)
            }
            .font(UIFont.cz_systemFont(16))
            .numberOfLines(2)
            .textColor(cz_standardTextColor)
            .build
        
        countryLabel = UILabel()
           .cz
           .addSuperView(contentView)
           .makeConstraints { (make) in
                make.left.equalTo(logoImageView.snp.right).offset(10)
                make.top.equalTo(televisionNameLabel.snp.bottom).offset(10)
                make.right.equalToSuperview().offset(-15)
           }
           .font(UIFont.cz_systemFont(14))
           .textColor(cz_standardTextColor)
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
