//
//  ViewController.swift
//  Random
//
//  Created by 刘超正 on 2019/9/20.
//  Copyright © 2019 刘超正. All rights reserved.
//
import UIKit

public extension CZKit where Base: UIImageView {
    
    @discardableResult
    func image(_ image: UIImage?) -> CZKit {
        base.image = image
        return self
    }
    
    @discardableResult
    func isHighlighted(_ isHighlighted: Bool) -> CZKit {
        base.isHighlighted = isHighlighted
        return self
    }
}
