//
//  BookReadView.swift
//  Random
//
//  Created by yu mingming on 2020/6/9.
//  Copyright © 2020 刘超正. All rights reserved.
//

import UIKit

class BookReadView: BaseView {
    
    /// 搜索视图
    private lazy var searchFeatureView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: CZCommon.cz_screenWidth, height: CZCommon.cz_navigationHeight))
        return view
    }()
    
    /// 搜索图标
    private var searchImageView: UIImageView!
    
    /// 搜索提示文字
    private var searchLabel: UILabel!
    
    /// 点击搜索提示文字的回调
    var tapSearchLabelBlock: ((_ recognizer: UITapGestureRecognizer) -> Void)?
    
    private let minimumInteritemSpacing: CGFloat = 15
    
    private let minimumLineSpacing: CGFloat = 10

    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        if CZCommon.cz_isIphone {
            layout.itemSize = CGSize(width: (CZCommon.cz_screenWidth - minimumInteritemSpacing * 2 - 30) / 3, height: CZCommon.cz_dynamicFitHeight(140))
        } else {
            layout.itemSize = CGSize(width: (CZCommon.cz_screenWidth - minimumInteritemSpacing * 3 - 30) / 4, height: CZCommon.cz_dynamicFitHeight(220))
        }
        layout.minimumInteritemSpacing = minimumInteritemSpacing
        layout.minimumLineSpacing = minimumLineSpacing
        layout.sectionInset = UIEdgeInsets(top: 10, left: 15, bottom: 0, right: 15)
        return UICollectionView(frame: .zero, collectionViewLayout: layout)
            .cz
            .register(BookcaseCollectionViewCell.self, forCellWithReuseIdentifier: BookcaseCollectionViewCell.identifier)
            .backgroundColor(cz_backgroundColor)
            .build
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(searchFeatureView)
        searchImageView = UIImageView()
            .cz
            .addSuperView(searchFeatureView)
            .makeConstraints({ (make) in
                make.centerY.equalToSuperview()
                make.left.equalToSuperview().offset(15)
            })
            .image(UIImage(named: "Icon_Video_Search")?.cz_alterColor(color: cz_selectedColor))
            .contentMode(.scaleAspectFit)
            .setContentHuggingPriority(.required, for: .horizontal)
            .setContentCompressionResistancePriority(.required, for: .horizontal)
            .build
        
        let tapSearchLabel = UITapGestureRecognizer(target: self, action: #selector(tapSearchLabelAction))
        searchLabel = UILabel()
            .cz
            .addSuperView(searchFeatureView)
            .makeConstraints({ (make) in
                make.centerY.equalToSuperview()
                make.left.equalTo(searchImageView.snp.right).offset(10)
                make.right.equalToSuperview().offset(-15)
            })
            .isUserInteractionEnabled(true)
            .text("请输入小说名称")
            .font(UIFont.cz_systemFont(14))
            .textColor(cz_unStandardTextColor)
            .addGestureRecognizer(tapSearchLabel)
            .build
        
        let _ = UIView()
            .cz
            .addSuperView(searchFeatureView)
            .makeConstraints { (make) in
                make.left.right.bottom.equalToSuperview()
                make.height.equalTo(1)
            }
            .backgroundColor(cz_dividerColor)
            .build
        collectionView.cz.addSuperView(self).makeConstraints({ (make) in
            make.top.equalTo(searchFeatureView.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        })
    }
    
    @objc func tapSearchLabelAction(recognizer: UITapGestureRecognizer) {
        if tapSearchLabelBlock != nil {
            tapSearchLabelBlock!(recognizer)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
