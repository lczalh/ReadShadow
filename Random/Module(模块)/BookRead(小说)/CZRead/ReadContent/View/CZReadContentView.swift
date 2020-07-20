//
//  CZReadContentView.swift
//  Random
//
//  Created by yu mingming on 2020/5/6.
//  Copyright © 2020 刘超正. All rights reserved.
//

import UIKit

class CZReadContentView: BaseView {
    
    var content: NSAttributedString! {
        didSet {
            setNeedsDisplay()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.clear
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        cz_superView(seekSuperView: UIView.self)?.layoutIfNeeded()
        guard let context = UIGraphicsGetCurrentContext() else { return }
        context.textMatrix = CGAffineTransform.identity
        context.translateBy(x: 0, y: bounds.size.height);
        context.scaleBy(x: 1.0, y: -1.0);
        let framesetter = CTFramesetterCreateWithAttributedString(content)
        let path = CGPath(rect: bounds, transform: nil)
        let ctFrame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), path, nil)
        CTFrameDraw(ctFrame, context);
    }
}
