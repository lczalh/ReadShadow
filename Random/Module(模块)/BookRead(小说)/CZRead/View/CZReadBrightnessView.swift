//
//  CZReadView.swift
//  Random
//
//  Created by yu mingming on 2020/5/8.
//  Copyright © 2020 刘超正. All rights reserved.
//

import UIKit

class CZReadBrightnessView: BaseView {
    
    /// 滚动条
    var brightnessSlider: UISlider!
    
    var collectionView: UICollectionView!
    
    /// 书阅读模型
    var bookReadModel: BookReadModel? {
        didSet {
            collectionView.reloadData()
        }
    }
    
    var tapThemeBlock: (() -> Void)?
    
    private var themeColors: Array<UIColor> {
        return [
            .white,
            .cz_hexColor("#E3EEDE"),
            .cz_rgbColor(241, 221, 200),
            .cz_rgbColor(193, 217, 235),
            .black
        ]
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = cz_readNaviTabBarBackgroundColor
        let lowBrightnessImageView = UIImageView()
            .cz
            .addSuperView(self)
            .makeConstraints({ (make) in
                make.top.equalToSuperview().offset(15)
                make.left.equalToSuperview().offset(15)
            })
            .image(UIImage(named: "Icon_Home_Read_LowBattery")?.cz_alterColor(color: cz_readNaviTabBarTextColor))
            .build
        
        let highBrightnessImageView = UIImageView()
            .cz
            .addSuperView(self)
            .makeConstraints({ (make) in
                make.top.equalToSuperview().offset(15)
                make.right.equalToSuperview().offset(-15)
            })
            .image(UIImage(named: "Icon_Home_Read_LowHighBattery")?.cz_alterColor(color: cz_readNaviTabBarTextColor))
            .build
        
        brightnessSlider = UISlider()
            .cz
            .addSuperView(self)
            .makeConstraints({ (make) in
                make.left.equalTo(lowBrightnessImageView.snp.right).offset(15)
                make.right.equalTo(highBrightnessImageView.snp.left).offset(-15)
                make.centerY.equalTo(lowBrightnessImageView)
            })
            .minimumValue(0)
            .maximumValue(1)
            .value(Float(UIScreen.main.brightness))
            .build
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: (CZCommon.cz_screenWidth - 30 - 15 * 4) / 5, height: (CZCommon.cz_screenWidth - 30 - 15 * 4) / 5)
        layout.minimumLineSpacing = 15
        layout.sectionInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
            .cz
            .addSuperView(self)
            .makeConstraints({ (make) in
                make.top.equalTo(lowBrightnessImageView.snp.bottom).offset(10)
                make.bottom.equalToSuperview().offset(-5)
                make.left.right.equalToSuperview()
            })
            .register(CZReadThemeCollectionCell.self, forCellWithReuseIdentifier: CZReadThemeCollectionCell.identifier)
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

extension CZReadBrightnessView: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return themeColors.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CZReadThemeCollectionCell.identifier, for: indexPath) as! CZReadThemeCollectionCell
        let themeColor = themeColors[indexPath.row]
        cell.themeImageView.backgroundColor = themeColor
        if bookReadThemeColor == themeColor {
            cell.selectorView.borderColor = themeColor
        } else {
            cell.selectorView.borderColor = .clear
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let themeColor = themeColors[indexPath.row]
        if themeColor == UIColor.black {
            CZObjectStore.standard.cz_objectWriteUserDefault(object: cz_unselectedColor, key: "bookReadFontColor")
        } else {
            CZObjectStore.standard.cz_objectWriteUserDefault(object: UIColor.black, key: "bookReadFontColor")
        }
        CZObjectStore.standard.cz_objectWriteUserDefault(object: themeColor, key: "bookReadThemeColor")
        collectionView.reloadData()
        if tapThemeBlock != nil {
            tapThemeBlock!()
        }
    }
    
}
