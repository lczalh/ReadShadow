//
//  FullscreenPlayController.swift
//  Random
//
//  Created by yu mingming on 2019/12/11.
//  Copyright © 2019 刘超正. All rights reserved.
//

import UIKit

class FullscreenPlayController: BaseController {
    
    lazy var fullscreenPlayView: FullscreenPlayView = {
        let view = FullscreenPlayView()
        view.superPlayerView.delegate = self
        return view
    }()
    
    var statusBarHidden: Bool = false {
        didSet {
            setNeedsStatusBarAppearanceUpdate()
        }
    }
    
    /// 播放模型
    private lazy var superPlayerModel: SuperPlayerModel = {
        let model = SuperPlayerModel()
        return model
    }()
    
    var videoURL: String = "" {
        didSet {
            superPlayerModel.videoURL = videoURL
            fullscreenPlayView.superPlayerView.play(with: superPlayerModel)
        }
    }

    /// 视频名称
    var videoName: String! {
        didSet {
            fullscreenPlayView.superPlayerView.controlView.title = videoName
        }
    }
    
    
    /// 起始播放时间
    var startTime: CGFloat = 0.0 {
        didSet {
            fullscreenPlayView.superPlayerView.startTime = startTime
        }
    }
    
    /// 播放结束回调
    var superPlayerDidEndBlock: ((_ player: SuperPlayerView) -> Void)?
    
    /// 实时播放时间回调
    var playCurrentTimeBlock: ((_ currentPlayTime: CGFloat) -> Void)?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fullscreenPlayView.cz.addSuperView(view).makeConstraints { (make) in
            if #available(iOS 11.0, *) {
                make.edges.equalTo(view.safeAreaLayoutGuide)
            } else {
                make.edges.equalToSuperview()
            }
        }
        
        //监听当前播放时间
        _ = fullscreenPlayView.superPlayerView.rx.observeWeakly(CGFloat.self, "playCurrentTime")
            .takeUntil(rx.deallocated)
            .subscribe(onNext: {[weak self] (value) in
                if self?.playCurrentTimeBlock != nil {
                    self!.playCurrentTimeBlock!(value ?? 0.0)
                }
        })
    }
    
    // 状态栏是否隐藏
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    deinit {
        /// 清理播放器内部状态，释放内存
        fullscreenPlayView.superPlayerView.resetPlayer()
    }
}

extension FullscreenPlayController: SuperPlayerDelegate {
    /// 返回事件
    func superPlayerBackAction(_ player: SuperPlayerView!) {
        navigationController?.popViewController(animated: true)
    }
    
    /// 播放结束通知
    func superPlayerDidEnd(_ player: SuperPlayerView!) {
        if superPlayerDidEndBlock != nil {
            superPlayerDidEndBlock!(player)
        }
    }
    
    /// 全屏改变通知
    func superPlayerFullScreenChanged(_ player: SuperPlayerView!) {
        statusBarHidden = player.isFullScreen
        if player.isFullScreen {
            let spDefaultControlView = (player.controlView as! SPDefaultControlView)
            spDefaultControlView.danmakuBtn.isHidden = true
        }
    }
}
