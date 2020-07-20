//
//  LCZProgressHUD.swift
//  Diary
//
//  Created by 谷粒公社 on 2019/3/20.
//  Copyright © 2019 lcz. All rights reserved.
//

import Foundation
import SVProgressHUD

class CZHUD {
    
    /// 只有循环的小圆圈提示框
    @objc class func show() -> () {
        SVProgressHUD.show()
        SVProgressHUD.setBackgroundColor(UIColor.black)
        SVProgressHUD.setForegroundColor(UIColor.white)
        SVProgressHUD.setDefaultMaskType(.clear)
    }

    /// 循环小圈圈 + 文字
    ///
    /// - Parameter title: 提示标题
    @objc class func show(_ title : String?) -> Void {
        SVProgressHUD.show(withStatus: title)
        SVProgressHUD.setBackgroundColor(UIColor.black)
        SVProgressHUD.setForegroundColor(UIColor.white)
        SVProgressHUD.setDefaultMaskType(.clear)
    }
    
    /// 成功的提示框 两秒消失
    ///
    /// - Parameter title: 提示标题
    @objc class func showSuccess(_ title: String?, delay: TimeInterval = 2) -> Void {
        SVProgressHUD.showSuccess(withStatus: title)
        SVProgressHUD.setBackgroundColor(UIColor.black)
        SVProgressHUD.setForegroundColor(UIColor.white)
        SVProgressHUD.setDefaultMaskType(.clear)
        dismiss(withDelay: delay)
    }
    
    /// 错误的提示框 两秒消失
    ///
    /// - Parameter title: 提示标题
    @objc class func showError(_ title: String?, delay: TimeInterval = 2) -> Void {
        SVProgressHUD.showError(withStatus: title)
        SVProgressHUD.setBackgroundColor(UIColor.black)
        SVProgressHUD.setForegroundColor(UIColor.white)
        SVProgressHUD.setDefaultMaskType(.clear)
        dismiss(withDelay: delay)
    }
    
    /// 进度的提示框
    /// - Parameter progress: 进度
    /// - Parameter status: 状态
    @objc class func showProgress(_ progress: Float, _ status: String?) -> Void {
        SVProgressHUD.showProgress(progress, status: status)
        SVProgressHUD.setBackgroundColor(UIColor.black)
        SVProgressHUD.setForegroundColor(UIColor.white)
        SVProgressHUD.setDefaultMaskType(.clear)
    }
    
    /// 立即隐藏
    @objc class func dismiss() -> Void {
        SVProgressHUD.dismiss()
    }
    
    /// 延时隐藏
    ///
    /// - Parameter withDelay: 几秒后隐藏
    @objc class func dismiss(withDelay : TimeInterval) -> () {
        SVProgressHUD.dismiss(withDelay: withDelay)
    }
}
