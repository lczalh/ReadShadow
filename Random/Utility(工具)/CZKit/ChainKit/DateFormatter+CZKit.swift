//
//  ViewController.swift
//  Random
//
//  Created by 刘超正 on 2019/9/20.
//  Copyright © 2019 刘超正. All rights reserved.
//
import UIKit

public extension CZKit where Base: DateFormatter {
    
    @discardableResult
    func dateFormat(_ dateFormat: String) -> CZKit {
        base.dateFormat = dateFormat
        return self
    }
    
    @discardableResult
    func dateStyle(_ dateStyle: DateFormatter.Style) -> CZKit {
        base.dateStyle = dateStyle
        return self
    }
    
    @discardableResult
    func timeStyle(_ timeStyle: DateFormatter.Style) -> CZKit {
        base.timeStyle = timeStyle
        return self
    }
    
    @discardableResult
    func locale(_ locale: Locale) -> CZKit {
        base.locale = locale
        return self
    }
    
    @discardableResult
    func generatesCalendarDates(_ generatesCalendarDates: Bool) -> CZKit {
        base.generatesCalendarDates = generatesCalendarDates
        return self
    }
    
    @discardableResult
    func formatterBehavior(_ formatterBehavior: DateFormatter.Behavior) -> CZKit {
        base.formatterBehavior = formatterBehavior
        return self
    }
    
    @discardableResult
    func timeZone(_ timeZone: TimeZone) -> CZKit {
        base.timeZone = timeZone
        return self
    }
    
    @discardableResult
    func calendar(_ calendar: Calendar) -> CZKit {
        base.calendar = calendar
        return self
    }
}
