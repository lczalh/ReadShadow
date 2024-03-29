//
//  ViewController.swift
//  Random
//
//  Created by 刘超正 on 2019/9/20.
//  Copyright © 2019 刘超正. All rights reserved.
//
import UIKit

public extension CZKit where Base: UISegmentedControl {
    
    @discardableResult
    func title(_ title: String?, forSegmentAt segment: Int) -> CZKit {
        base.setTitle(title, forSegmentAt: segment)
        return self
    }
    
    @discardableResult
    func image(_ image: UIImage?, forSegmentAt segment: Int) -> CZKit {
        base.setImage(image, forSegmentAt: segment)
        return self
    }
    
    @discardableResult
    func width(_ width: CGFloat, forSegmentAt segment: Int) -> CZKit {
        base.setWidth(width, forSegmentAt: segment)
        return self
    }
    
    @discardableResult
    func contentOffset(_ offset: CGSize, forSegmentAt segment: Int) -> CZKit {
        base.setContentOffset(offset, forSegmentAt: segment)
        return self
    }
    
    @discardableResult
    func enabled(_ enabled: Bool, forSegmentAt segment: Int) -> CZKit {
        base.setEnabled(enabled, forSegmentAt: segment)
        return self
    }
    
    @discardableResult
    func selectedSegmentIndex(_ selectedSegmentIndex: Int) -> CZKit {
        base.selectedSegmentIndex = selectedSegmentIndex
        return self
    }
    
    @discardableResult
    func backgroundImage(_ backgroundImage: UIImage?, for state: UIControl.State..., barMetrics: UIBarMetrics) -> CZKit {
        state.forEach { base.setBackgroundImage(backgroundImage, for: $0, barMetrics: barMetrics) }
        return self
    }
    
    @discardableResult
    func dividerImage(_ dividerImage: UIImage?,
                      forLeftSegmentState leftState: UIControl.State,
                      rightSegmentState rightState: UIControl.State,
                      barMetrics: UIBarMetrics) -> CZKit {
        base.setDividerImage(dividerImage, forLeftSegmentState: leftState, rightSegmentState: rightState, barMetrics: barMetrics)
        return self
    }
    
    @discardableResult
    func titleTextAttributes(_ attributes: [NSAttributedString.Key : Any]?, for state: UIControl.State...) -> CZKit {
        state.forEach { base.setTitleTextAttributes(attributes, for: $0) }
        return self
    }
    
    @discardableResult
    func contentPositionAdjustment(_ adjustment: UIOffset,
                                   forSegmentType leftCenterRightOrAlone: UISegmentedControl.Segment,
                                   barMetrics: UIBarMetrics) -> CZKit {
        base.setContentPositionAdjustment(adjustment, forSegmentType: leftCenterRightOrAlone, barMetrics: barMetrics)
        return self
    }
}
