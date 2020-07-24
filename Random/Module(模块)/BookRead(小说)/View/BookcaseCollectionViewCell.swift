//
//  BookcaseCollectionViewCell.swift
//  Random
//
//  Created by yu mingming on 2020/6/11.
//  Copyright © 2020 刘超正. All rights reserved.
//

import UIKit

class BookcaseCollectionViewCell: BaseCollectionViewCell {
    
    static var identifier = "BookcaseCollectionViewCell"
    
    /// 小说图片
    var bookImageView: UIImageView!
    
    /// 小说标题
    var bookTitleLabel: UILabel!
    
//    /// 更新书架按钮
//    var updateBookButton: UIButton!
//    
//    /// 移除书架按钮
//    var removeBookButton: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .clear
        backgroundColor = .clear
        bookImageView = UIImageView()
            .cz
            .addSuperView(contentView)
            .makeConstraints({ (make) in
                make.top.equalToSuperview()
                make.left.right.equalToSuperview()
                make.bottom.equalToSuperview().offset(-CZCommon.cz_dynamicFitHeight(35))
            })
            .contentMode(.scaleAspectFill)
            .clipsToBounds(true)
            .isUserInteractionEnabled(true)
            .setContentHuggingPriority(.required, for: .vertical)
            .setContentCompressionResistancePriority(.required, for: .vertical)
            .build
        
        bookTitleLabel = UILabel()
            .cz
            .addSuperView(contentView)
            .makeConstraints({ (make) in
                make.top.equalTo(bookImageView.snp.bottom).offset(5)
                make.left.right.equalToSuperview()
            })
            .font(UIFont.cz_boldSystemFont(12))
            .textColor(cz_standardTextColor)
            .numberOfLines(2)
            .build
        
//        updateBookButton = UIButton()
//            .cz
//            .addSuperView(contentView)
//            .makeConstraints({ (make) in
//                make.bottom.equalTo(bookImageView).offset(-5)
//                make.left.equalTo(bookImageView).offset(5)
//                make.height.equalTo(CZCommon.cz_dynamicFitHeight(20))
//                make.width.equalTo(CZCommon.cz_dynamicFitWidth(30))
//            })
//            .title("更新", for: .normal)
//            .titleColor(UIColor.white, for: .normal)
//            .font(.cz_systemFont(10))
//            .backgroundColor(cz_selectedColor)
//            .cornerRadius(5)
//            .clipsToBounds(true)
//            .build
//        
//        removeBookButton = UIButton()
//            .cz
//            .addSuperView(contentView)
//            .makeConstraints({ (make) in
//                make.bottom.equalTo(bookImageView).offset(-5)
//                make.right.equalTo(bookImageView).offset(-5)
//                make.height.equalTo(CZCommon.cz_dynamicFitHeight(20))
//                make.width.equalTo(CZCommon.cz_dynamicFitWidth(40))
//            })
//            .title("移除", for: .normal)
//            .titleColor(UIColor.white, for: .normal)
//            .font(.cz_systemFont(10))
//            .backgroundColor(cz_selectedColor)
//            .cornerRadius(5)
//            .clipsToBounds(true)
//            .build
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
