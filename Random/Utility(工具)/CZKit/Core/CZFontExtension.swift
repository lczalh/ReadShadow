//
//  CZFontExtension.swift
//  Random
//
//  Created by yu mingming on 2019/11/28.
//  Copyright © 2019 刘超正. All rights reserved.
//

import Foundation

public extension UIFont {
    
    
    /// 常规字体，根据屏幕大小动态调整字体大小
    /// - Parameter size: 字体大小
    static func cz_systemFont(_ size: CGFloat) -> UIFont {
        return UIFont.systemFont(ofSize: CZCommon.cz_screenWidthScale * size)
    }
    
    
    /// 常规字体和字重，根据屏幕大小动态调整字体大小
    /// - Parameters:
    ///   - size: 字体大小
    ///   - weight: 字重
    static func cz_systemFont(_ size: CGFloat, _ weight: CGFloat) -> UIFont {
        return UIFont.systemFont(ofSize: CZCommon.cz_screenWidthScale * size, weight: UIFont.Weight(rawValue: weight))
    }
    
    
    /// 粗体字体，根据屏幕大小动态调整字体大小
    /// - Parameter size: 字体大小
    static func cz_boldSystemFont(_ size: CGFloat) -> UIFont {
        return UIFont.boldSystemFont(ofSize: CZCommon.cz_screenWidthScale * size)
    }
    
}
