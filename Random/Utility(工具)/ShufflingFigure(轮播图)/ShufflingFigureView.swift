//
//  ShufflingFigureView.swift
//  Diary
//
//  Created by 谷粒公社 on 2019/6/26.
//  Copyright © 2019 lcz. All rights reserved.
//

import UIKit

class ShufflingFigureView: UIView {
    
    public lazy var fsPagerView: FSPagerView = {
        let view = FSPagerView()
        view.register(FSPagerViewCell.self, forCellWithReuseIdentifier: "FSPagerViewCell")
        view.itemSize = FSPagerView.automaticSize
        view.automaticSlidingInterval = 3
        view.isInfinite = !view.isInfinite
        view.decelerationDistance = FSPagerView.automaticDistance
        view.contentMode = .scaleAspectFill
        // 随机轮播图样式
        let i = arc4random_uniform(9 - 0) + 0

        let type = self.shufflingFigureTransformerTypes[Int(i)]
        view.transformer = FSPagerViewTransformer(type:type)
        switch type {
        case .crossFading, .zoomOut, .depth:
            view.itemSize = FSPagerView.automaticSize
            view.decelerationDistance = 1
        case .linear, .overlap:
            let transform = CGAffineTransform(scaleX: 0.6, y: 0.75)
            view.itemSize = view.frame.size.applying(transform)
            view.decelerationDistance = FSPagerView.automaticDistance
        case .ferrisWheel, .invertedFerrisWheel:
            view.itemSize = CGSize(width: 180, height: 140)
            view.decelerationDistance = FSPagerView.automaticDistance
        case .coverFlow:
            view.itemSize = CGSize(width: 220, height: 170)
            view.decelerationDistance = FSPagerView.automaticDistance
        case .cubic:
            let transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
            view.itemSize = view.frame.size.applying(transform)
            view.decelerationDistance = 1
        }
        return view
    }()
    
    public lazy var fsPageControl: FSPageControl = {
        let control = FSPageControl()
        control.contentHorizontalAlignment = .right
        //设置下标指示器颜色（选中状态和普通状态）
        control.setFillColor(cz_unselectedColor, for: .normal)
        control.setFillColor(cz_selectedColor, for: .selected)
        return control
    }()
    
    /// 轮播图样式
    lazy var shufflingFigureTransformerTypes: [FSPagerViewTransformerType] = {
        return [.crossFading,
                .zoomOut,
                .depth,
                .linear,
                .overlap,
                .ferrisWheel,
                .invertedFerrisWheel,
                .coverFlow,
                .cubic]
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        fsPagerView.cz.addSuperView(self).makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        fsPageControl.cz.addSuperView(fsPagerView).makeConstraints { (make) in
            make.right.equalToSuperview().offset(-20)
            make.bottom.equalToSuperview().offset(-5)
        }

        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
