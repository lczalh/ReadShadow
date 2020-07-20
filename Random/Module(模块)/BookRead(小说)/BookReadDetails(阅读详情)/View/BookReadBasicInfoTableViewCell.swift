//
//  BookReadBasicInfoTableViewCell.swift
//  Random
//
//  Created by yu mingming on 2020/6/9.
//  Copyright © 2020 刘超正. All rights reserved.
//

import UIKit

class BookReadBasicInfoTableViewCell: BaseTableViewCell {
    
    static var identifier = "BookReadBasicInfoTableViewCell"
    
    /// 小说图片
    var bookImageView: UIImageView!
    
    /// 背景图
    var bookBackImageView: UIImageView!
    
    /// 书名
    var bookNameLabel: UILabel!
    
    /// 小说作者
    var bookAuthorLabel: UILabel!
    
    /// 书分类
    var bookCategoryLabel: UILabel!

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
        
        bookBackImageView = UIImageView()
            .cz
            .addSuperView(contentView)
            .frame(x: 0, y: 0, width: CZCommon.cz_screenWidth, height: CZCommon.cz_dynamicFitHeight(100))
            .contentMode(.scaleAspectFit)
            .build
        
        //首先创建一个模糊效果
        let blurEffect = UIBlurEffect(style: .light)
        //接着创建一个承载模糊效果的视图
        let blurView = UIVisualEffectView(effect: blurEffect)
        //设置模糊视图的大小（全屏）
        blurView.frame.size = CGSize(width: CZCommon.cz_screenWidth, height: CZCommon.cz_dynamicFitHeight(110))
        bookBackImageView.addSubview(blurView)
        
        bookImageView = UIImageView()
            .cz
            .addSuperView(contentView)
            .makeConstraints({ (make) in
                make.top.equalToSuperview().offset(CZCommon.cz_navigationHeight + CZCommon.cz_statusBarHeight)
                make.left.equalToSuperview().offset(15)
                make.height.equalTo(CZCommon.cz_dynamicFitHeight(120))
                make.width.equalTo(CZCommon.cz_dynamicFitWidth(100))
                make.bottom.equalToSuperview().offset(-15)
            })
            .cornerRadius(5)
            .contentMode(.scaleAspectFit)
            .clipsToBounds(true)
            .build
        
        bookNameLabel = UILabel()
            .cz
            .addSuperView(contentView)
            .makeConstraints({ (make) in
                make.top.equalTo(bookImageView.snp.top)
                make.left.equalTo(bookImageView.snp.right).offset(10)
                make.right.equalToSuperview().offset(-15)
            })
            .font(UIFont.cz_boldSystemFont(16))
            .numberOfLines(0)
            .textColor(cz_standardTextColor)
            .setContentHuggingPriority(.required, for: .vertical)
            .setContentCompressionResistancePriority(.required, for: .vertical)
            .build

        bookAuthorLabel = UILabel()
            .cz
            .addSuperView(contentView)
            .makeConstraints({ (make) in
                make.top.equalTo(bookNameLabel.snp.bottom).offset(CZCommon.cz_dynamicFitHeight(8))
                make.left.equalTo(bookImageView.snp.right).offset(10)
                make.right.equalToSuperview().offset(-15)
            })
            .font(UIFont.cz_systemFont(12))
            .numberOfLines(0)
            .textColor(cz_unStandardTextColor)
            .setContentHuggingPriority(.required, for: .vertical)
            .setContentCompressionResistancePriority(.required, for: .vertical)
            .build
        
        bookCategoryLabel = UILabel()
            .cz
            .addSuperView(contentView)
            .makeConstraints({ (make) in
                make.top.equalTo(bookAuthorLabel.snp.bottom).offset(CZCommon.cz_dynamicFitHeight(10))
                make.left.equalTo(bookImageView.snp.right).offset(10)
                make.right.equalToSuperview().offset(-15)
            })
            .font(UIFont.cz_systemFont(12))
            .numberOfLines(0)
            .textColor(cz_unStandardTextColor)
            .setContentHuggingPriority(.required, for: .vertical)
            .setContentCompressionResistancePriority(.required, for: .vertical)
            .build
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}
