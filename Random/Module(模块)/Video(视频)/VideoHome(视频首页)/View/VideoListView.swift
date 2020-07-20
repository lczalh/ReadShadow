//
//  VideoListView.swift
//  Random
//
//  Created by yu mingming on 2019/11/8.
//  Copyright © 2019 刘超正. All rights reserved.
//

import UIKit

class VideoListView: BaseView {
    
    lazy var layout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
            .cz
            .minimumLineSpacing(10)
            .minimumInteritemSpacing(5)
            .sectionInset(top: 0, left: 5, bottom: 0, right: 5)
            .build
        if CZCommon.cz_isIphone {
            layout.itemSize = CGSize(width: (CZCommon.cz_screenWidth - 20) / 3, height: CZCommon.cz_dynamicFitHeight(180))
            layout.headerReferenceSize = CGSize(width: CZCommon.cz_screenWidth, height: CZCommon.cz_dynamicFitHeight(185))
        } else {
            layout.itemSize = CGSize(width: (CZCommon.cz_screenWidth - 20) / 3, height: CZCommon.cz_dynamicFitHeight(220))
            layout.headerReferenceSize = CGSize(width: CZCommon.cz_screenWidth, height: CZCommon.cz_dynamicFitHeight(250))
        }
        return layout
    }()
    
    var collectionView: UICollectionView!

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        collectionView = UICollectionView(frame: .zero,
                              collectionViewLayout: layout)
            .cz
            .addSuperView(self)
            .makeConstraints({ (make) in
                make.edges.equalToSuperview()
            })
            .backgroundColor(cz_backgroundColor)
            .register(VideoListCollectionViewCell.self,
                      forCellWithReuseIdentifier: VideoListCollectionViewCell.identifier)
            .register(VideoListCollectionHeaderView.self, forSectionHeaderWithReuseIdentifier: VideoListCollectionHeaderView.identifier)
            .build
        

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
