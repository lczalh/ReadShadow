//
//  BaseTabBarController.swift
//  Random
//
//  Created by 刘超正 on 2019/10/1.
//  Copyright © 2019 刘超正. All rights reserved.
//

import UIKit

class BaseTabBarController: QMUITabBarViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.isTranslucent = false
    }
    
    // MARK: - 设置所有控制器的默认状态栏颜色
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override var shouldAutorotate: Bool {
        return selectedViewController?.shouldAutorotate ?? false
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return selectedViewController?.supportedInterfaceOrientations ?? .portrait
    }
    
    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation{
        return selectedViewController?.preferredInterfaceOrientationForPresentation ?? .portrait
    }
    
    override var childForStatusBarStyle: UIViewController? {
        return selectedViewController
    }
    
    override var childForStatusBarHidden: UIViewController? {
        return selectedViewController
    }
    
}
