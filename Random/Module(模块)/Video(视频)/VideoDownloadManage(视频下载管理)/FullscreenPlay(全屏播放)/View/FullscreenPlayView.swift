//
//  FullscreenPlayView.swift
//  Random
//
//  Created by yu mingming on 2019/12/11.
//  Copyright © 2019 刘超正. All rights reserved.
//

import UIKit

class FullscreenPlayView: BaseView {
    
    lazy var superPlayerView: SuperPlayerView = {
        let view = SuperPlayerView(frame: bounds)
        view.fatherView = self
        let superPlayerViewConfig = SuperPlayerViewConfig()
        superPlayerViewConfig.maxCacheItem = 100
       // superPlayerViewConfig.renderMode = 0
        view.playerConfig = superPlayerViewConfig
        return view
    }()


    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
