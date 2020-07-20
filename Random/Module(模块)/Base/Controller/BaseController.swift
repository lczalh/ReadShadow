//
//  BaseController.swift
//  Random
//
//  Created by 刘超正 on 2019/10/1.
//  Copyright © 2019 刘超正. All rights reserved.
//

import UIKit

class BaseController: QMUICommonViewController {
    
    /// 上一级页面需要更新的
    public var returnUpdated: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = cz_backgroundColor
        // 统一设置返回按钮
//        UINavigationBar.appearance().backIndicatorTransitionMaskImage = UIImage(named: "Icon_Fiction")
//        UINavigationBar.appearance().backIndicatorImage = UIImage(named: "Icon_Fiction")
        let backBarButtonItem = UIBarButtonItem(title: "", style: .done, target: nil, action: nil)
        navigationItem.backBarButtonItem = backBarButtonItem
        
        // 配置空视图
        emptyView?.backgroundColor = UIColor.white
        
        if #available(iOS 11.0, *) {
            
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
    }
    
    // MARK: - 设置所有控制器的默认状态栏颜色
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    // MARK: - 设置所有控制器的默认竖屏
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    override var shouldAutorotate: Bool {
        return false
    }
    
    deinit {
        cz_print("控制器销毁了")
    }

}
