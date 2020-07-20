//
//  CZBasePageController.swift
//  Random
//
//  Created by yu mingming on 2020/5/8.
//  Copyright © 2020 刘超正. All rights reserved.
//

import UIKit

@objc protocol CZBasePageControllerDelegate: NSObjectProtocol {
    
    /// 获取上一页
    @objc optional func pageViewController(_ pageViewController: CZBasePageController, getViewControllerBefore viewController: UIViewController!)
    
    /// 获取下一页
    @objc optional func pageViewController(_ pageViewController: CZBasePageController, getViewControllerAfter viewController: UIViewController!)
}

class CZBasePageController: UIPageViewController {
    
    /// 是否打开自定义单击手势  true: 启用 false：禁用
    var cz_isOpenCustomTapGesture: Bool = false {
        didSet {
            if (cz_isOpenCustomTapGesture) {
                cz_customTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(customTapGestureRecognizerAction))
                cz_customTapGestureRecognizer.delegate = self
                view.addGestureRecognizer(cz_customTapGestureRecognizer)
            }
            // 打开 / 禁用默认手势
            for recognizer in gestureRecognizers {
                if recognizer is UITapGestureRecognizer {
                    recognizer.isEnabled = !cz_isOpenCustomTapGesture
                }
            }
        }
    }
    
    /// 自定义手势代理
    weak var cz_delegate: CZBasePageControllerDelegate?
    
    // 自定义单击手势
    private(set) var cz_customTapGestureRecognizer: UITapGestureRecognizer!
    
    // 左边点击区域宽度
    private let cz_leftAreaWidth: CGFloat = CZCommon.cz_screenWidth / 3

    // 右边点击区域宽度
    private let cz_rightAreaWidth: CGFloat = CZCommon.cz_screenWidth / 3

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // 单击手势事件
    @objc func customTapGestureRecognizerAction(gestureRecognizer: UIGestureRecognizer) {
        let touchPoint = gestureRecognizer.location(in: view)
        if (touchPoint.x < cz_leftAreaWidth) { // 左边
            cz_delegate?.pageViewController?(self, getViewControllerBefore: viewControllers?.first)
        }else if (touchPoint.x > cz_rightAreaWidth * 2) { // 右边
            cz_delegate?.pageViewController?(self, getViewControllerAfter: viewControllers?.first)
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension CZBasePageController: UIGestureRecognizerDelegate {
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if (gestureRecognizer.isKind(of: UITapGestureRecognizer.classForCoder()) && gestureRecognizer.isEqual(cz_customTapGestureRecognizer)) {
            let touchPoint = cz_customTapGestureRecognizer.location(in: view)
            if (touchPoint.x > cz_leftAreaWidth && touchPoint.x < (CZCommon.cz_screenWidth - cz_rightAreaWidth)) {
                return true
            }
        }
        return false
    }
}
