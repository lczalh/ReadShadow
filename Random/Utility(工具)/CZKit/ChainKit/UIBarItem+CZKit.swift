//
//  ViewController.swift
//  Random
//
//  Created by 刘超正 on 2019/9/20.
//  Copyright © 2019 刘超正. All rights reserved.
//
import UIKit

public extension CZKit where Base: UIBarItem {
    
    @discardableResult
    func isEnabled(_ isEnabled: Bool) -> CZKit {
        base.isEnabled = isEnabled
        return self
    }
    
    @discardableResult
    func titleTextAttributes(_ titleTextAttributes: [NSAttributedString.Key: Any]?,
                             for state: UIControl.State...) -> CZKit {
        state.forEach { base.setTitleTextAttributes(titleTextAttributes, for: $0) }
        return self
    }
}
