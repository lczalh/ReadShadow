//
//  StartupPageController.swift
//  Random
//
//  Created by yu mingming on 2020/7/8.
//  Copyright © 2020 刘超正. All rights reserved.
//

import UIKit

class StartupPageController: BaseController {
    
    lazy var startupPageView: StartupPageView = {
        let view = StartupPageView(frame: .zero)
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        startupPageView.cz.addSuperView(view).makeConstraints { (make) in
            make.edges.equalTo(view)
        }
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
            guard CZCommon.cz_isProxyDetection() == true else {
                CZHUD.showError("检测到非法网络代理，请关闭后重试！！！")
                return
            }
            let tabBarController = MainTabBarController()
            let transtition = CATransition()
            transtition.duration = 0.5
            transtition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
            UIApplication.shared.delegate?.window??.layer.add(transtition, forKey: "animation")
            UIApplication.shared.delegate?.window??.rootViewController = tabBarController
        }
        //getApplicationConfigModelData()
    }
    
//    /// 获取应用配置数据
//    func getApplicationConfigModelData() {
//        guard CZCommon.cz_isProxyDetection() == true else {
//            CZHUD.showError("检测到非法网络代理，请关闭后重试！！！")
//            return
//        }
//        CZHUD.show("加载中")
//        DispatchQueue.global().async {
//            do {
//                let readShadowConfigJsonString = try String(contentsOf: URL(string: "https://www.letaoshijie.com/ReadShadowConfig.json")!)
//                let readShadowRootModel = Mapper<ReadShadowRootModel>().map(JSONString: readShadowConfigJsonString)
//                CZObjectStore.standard.cz_objectWriteUserDefault(object: readShadowRootModel!, key: "applicationConfigModel")
//            } catch {
//                cz_print("获取应用配置数据失败")
//            }
//            DispatchQueue.main.async {
//                CZHUD.dismiss()
//                let tabBarController = MainTabBarController()
//                let transtition = CATransition()
//                transtition.duration = 0.5
//                transtition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
//                UIApplication.shared.delegate?.window??.layer.add(transtition, forKey: "animation")
//                UIApplication.shared.delegate?.window??.rootViewController = tabBarController
//            }
//        }
//    }
}

