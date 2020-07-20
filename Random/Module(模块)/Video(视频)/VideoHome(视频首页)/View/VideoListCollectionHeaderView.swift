//
//  VideoListCollectionHeaderView.swift
//  Random
//
//  Created by yu mingming on 2020/6/4.
//  Copyright © 2020 刘超正. All rights reserved.
//

import UIKit

class VideoListCollectionHeaderView: BaseCollectionReusableView {
    
    static var identifier = "VideoListCollectionHeaderView"
    
    var shufflingFigureView: ShufflingFigureView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        shufflingFigureView = ShufflingFigureView()
            .cz
            .addSuperView(self)
            .makeConstraints({ (make) in
                make.left.top.right.equalToSuperview()
                make.bottom.equalToSuperview().offset(-5)
            })
            .build
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
