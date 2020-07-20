//
//  CZReadWordSizeVIew.swift
//  Random
//
//  Created by yu mingming on 2020/6/16.
//  Copyright © 2020 刘超正. All rights reserved.
//

import UIKit

class CZReadWordSizeView: BaseView {
    
    /// 滚动条
    var highWordSizeSlider: UISlider!
    
    var collectionView: UICollectionView!
    
    private var titles: Array<String> {
        return [
            "仿真",
          //  "覆盖",
            "平移",
           // "滚动",
           // "无",
        ]
    }
    
    /// 书阅读模型
    var bookReadModel: BookReadModel? {
        didSet {
            collectionView.reloadData()
        }
    }
    
    /// 点击风格的回调
    var tapBookReadStyleNameBlock: (() -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = cz_readNaviTabBarBackgroundColor
        let lowWordSizeLabel = UILabel()
            .cz
            .addSuperView(self)
            .makeConstraints({ (make) in
                make.top.equalToSuperview().offset(15)
                make.left.equalToSuperview().offset(15)
            })
            .text("A")
            .font(.cz_systemFont(14))
            .textColor(cz_standardTextColor)
            .build
        
        let highWordSizeLabel = UILabel()
            .cz
            .addSuperView(self)
            .makeConstraints({ (make) in
                make.centerY.equalTo(lowWordSizeLabel)
                make.right.equalToSuperview().offset(-15)
            })
            .text("A")
            .font(.cz_systemFont(20))
            .textColor(cz_standardTextColor)
            .build
        
        highWordSizeSlider = UISlider()
            .cz
            .addSuperView(self)
            .makeConstraints({ (make) in
                make.left.equalTo(lowWordSizeLabel.snp.right).offset(15)
                make.right.equalTo(highWordSizeLabel.snp.left).offset(-15)
                make.centerY.equalTo(lowWordSizeLabel)
            })
            .minimumValue(10)
            .maximumValue(26)
            .value(bookReadFontSize)
            .build
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: (CZCommon.cz_screenWidth - 30 - 15 * 4) / 5, height: 30)
        layout.minimumLineSpacing = 15
        layout.minimumInteritemSpacing = 15
        layout.sectionInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
            .cz
            .addSuperView(self)
            .makeConstraints({ (make) in
                make.top.equalTo(lowWordSizeLabel.snp.bottom).offset(10)
                make.bottom.equalToSuperview().offset(-5)
                make.left.right.equalToSuperview()
            })
            .register(CZReadStyleCollectionCell.self, forCellWithReuseIdentifier: CZReadStyleCollectionCell.identifier)
            .dataSource(self)
            .delegate(self)
            .showsHorizontalScrollIndicator(false)
            .backgroundColor(UIColor.clear)
            .build
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension CZReadWordSizeView: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return titles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CZReadStyleCollectionCell.identifier, for: indexPath) as! CZReadStyleCollectionCell
        let title = titles[indexPath.row]
        cell.titleLabel.text = title
        if bookReadStyleName == title {
            cell.titleLabel.textColor = UIColor.white
            cell.contentView.backgroundColor = cz_selectedColor
            cell.contentView.borderColor = cz_selectedColor
        } else {
            cell.titleLabel.textColor = cz_standardTextColor
            cell.contentView.backgroundColor = .clear
            cell.contentView.borderColor = cz_standardTextColor
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // 存储风格名称
        CZObjectStore.standard.cz_objectWriteUserDefault(object: titles[indexPath.row], key: "bookReadStyleName")
        collectionView.reloadData()
        if tapBookReadStyleNameBlock != nil {
            tapBookReadStyleNameBlock!()
        }
    }
    
}
