//
//  HaveDownloadedTableViewCell.swift
//  Random
//
//  Created by yu mingming on 2019/12/10.
//  Copyright © 2019 刘超正. All rights reserved.
//

import UIKit

class HaveDownloadedTableViewCell: SwipeTableViewCell {
    
    public static let identifier = "HaveDownloadedTableViewCell"
    
    /// 名称
    var titleLabel: QMUILabel!

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
        self.contentView.backgroundColor = UIColor.white
        titleLabel = QMUILabel()
            .cz
            .addSuperView(self.contentView)
            .makeConstraints({ (make) in
                make.left.equalToSuperview().offset(15)
                make.centerY.equalToSuperview()
            })
            .font(UIFont.cz_boldSystemFont(16))
            .textColor(cz_standardTextColor)
            .build
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
