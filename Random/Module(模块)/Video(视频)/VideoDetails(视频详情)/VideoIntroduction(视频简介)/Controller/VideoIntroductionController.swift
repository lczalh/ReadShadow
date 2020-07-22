//
//  VideoIntroductionController.swift
//  Random
//
//  Created by yu mingming on 2020/7/20.
//  Copyright © 2020 刘超正. All rights reserved.
//

import UIKit

class VideoIntroductionController: BaseController {
    
    lazy var videoIntroductionViewHeight: CGFloat = {
        return 240
    }()
    
    lazy var videoIntroductionView: VideoIntroductionView = {
        let view = VideoIntroductionView(frame: CGRect(x: 0, y: CZCommon.cz_screenHeight, width: CZCommon.cz_screenWidth, height: CZCommon.cz_screenHeight - videoIntroductionViewHeight))
        return view
    }()
    
    /// 本页数据模型
    var model: ReadShadowVideoModel! {
        didSet {
            videoIntroductionView.videoNameLabel.text = model.name
            videoIntroductionView.videoInfoLabel.text = "\(model.language ?? "未知")·\(model.year ?? "未知")·\(model.area ?? "未知")·\(model.category ?? (model.type ?? "未知"))"
            videoIntroductionView.directorLabel.text = "导演：\(model.director ?? "未知")"
            videoIntroductionView.actorLabel.text = "主演：\(model.actor ?? "未知")"
            videoIntroductionView.introductionLabel.text = model.introduction ?? "未知"
        }
    }
    
    override public func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        videoIntroductionView.frame.origin = CGPoint(x: 0, y: CZCommon.cz_screenHeight)
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveLinear, animations: {
            self.view.backgroundColor = UIColor.cz_rgbColor(0, 0, 0, 0.5)
            self.videoIntroductionView.frame.origin = CGPoint(x: 0, y: self.videoIntroductionViewHeight)
        }, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .cz_rgbColor(0, 0, 0, 0.3)
        videoIntroductionView.cz.addSuperView(view)
        
        videoIntroductionView.closeButton.rx.tap.subscribe(onNext: {[weak self] () in
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveLinear, animations: {
                self?.view.backgroundColor = UIColor.cz_rgbColor(0, 0, 0, 0)
                self?.videoIntroductionView.frame.origin = CGPoint(x: 0, y: CZCommon.cz_screenHeight)
            }, completion: { (state) in
                DispatchQueue.main.async {
                    self!.dismiss(animated: false, completion: nil)
                }
            })
        }).disposed(by: rx.disposeBag)
    }
    
    
    override var modalPresentationStyle: UIModalPresentationStyle {
        get { .overFullScreen }
        set {}
    }

}
