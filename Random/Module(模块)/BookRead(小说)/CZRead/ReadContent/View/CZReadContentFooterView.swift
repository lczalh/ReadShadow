//
//  CZReadFooterView.swift
//  Random
//
//  Created by yu mingming on 2020/5/6.
//  Copyright © 2020 刘超正. All rights reserved.
//

import UIKit

/// 电池图片高度
private let batteryImageSize: CGSize = CGSize(width: CZCommon.cz_dynamicFitWidth(25), height: CZCommon.cz_dynamicFitHeight(10))

/// 电池电量高度
private let batteryElectricitySize: CGSize = CGSize(width: CZCommon.cz_dynamicFitWidth(19), height: CZCommon.cz_dynamicFitHeight(6))

class CZReadContentFooterView: BaseView {
    
    /// 电池图片
    var batteryImage: UIImageView!
    
    /// 电量
    var batteryElectricityView: UIView!
    
    /// 当前电量
    var batteryLevel: Float! {
        didSet {
            let batteryLevel = (self.batteryLevel < 0 ? 0 : self.batteryLevel > 1 ? 1 : self.batteryLevel)!
            // 计算当前电量宽度
            let batteryElectricityWidth = batteryElectricitySize.width * CGFloat(batteryLevel)
            batteryElectricityView.snp.updateConstraints { (make) in
                make.size.equalTo(CGSize(width: batteryElectricityWidth, height: batteryElectricitySize.height))
            }
        }
    }
    
    /// 分页数
    var pageNumberLabel: UILabel!
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.clear
        
        batteryImage = UIImageView()
            .cz
            .addSuperView(self)
            .makeConstraints({ (make) in
                make.left.equalToSuperview()
                make.centerY.equalToSuperview()
                make.size.equalTo(batteryImageSize)
            })
            .image(UIImage(named: "Icon_Home_Read_Battery")?.cz_alterColor(color: bookReadFontColor))
            .clipsToBounds(true)
            .build
       
        batteryElectricityView = UIView()
            .cz
            .addSuperView(batteryImage)
            .makeConstraints({ (make) in
                make.left.equalToSuperview().offset(CZCommon.cz_dynamicFitWidth(2))
                make.centerY.equalToSuperview()
                make.size.equalTo(batteryElectricitySize)
            })
            .backgroundColor(bookReadFontColor)
            .build
        
        pageNumberLabel = UILabel()
            .cz
            .addSuperView(self)
            .makeConstraints({ (make) in
                make.right.centerY.equalToSuperview()
            })
            .font(UIFont.cz_systemFont(12))
            .textColor(bookReadFontColor)
            .build
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
