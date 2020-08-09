//
//  VideoDetailsView.swift
//  Random
//
//  Created by yu mingming on 2019/11/8.
//  Copyright © 2019 刘超正. All rights reserved.
//

import UIKit
import AVKit
import WebKit

class VideoDetailsView: BaseView {
    
    /// 播放视图
    lazy var playerImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        if CZCommon.cz_isIphone {
            view.frame = CGRect(x: 0, y: 0, width: CZCommon.cz_screenWidth, height: CZCommon.cz_dynamicFitHeight(210))
        } else {
            view.frame = CGRect(x: 0, y: 0, width: CZCommon.cz_screenWidth, height: CZCommon.cz_dynamicFitHeight(300))
        }
        view.isUserInteractionEnabled = true
        return view
    }()
    
    
    /// 网页播放器
    lazy var wkWebView: WKWebView = {
        let wkWebViewConfiguration = WKWebViewConfiguration()
        // 是使用h5的视频播放器在线播放, 还是使用原生播放器全屏播放
        wkWebViewConfiguration.allowsInlineMediaPlayback = true
        wkWebViewConfiguration.allowsAirPlayForMediaPlayback = true
        wkWebViewConfiguration.requiresUserActionForMediaPlayback = false
        //设置是否允许画中画技术 在特定设备上有效
        wkWebViewConfiguration.allowsPictureInPictureMediaPlayback = true
        let view = WKWebView(frame: playerImageView.bounds, configuration: wkWebViewConfiguration)
        // 请求桌面网站
        view.customUserAgent = "ASDF"
        view.isHidden = true
        view.scrollView.bounces = false
        view.scrollView.showsVerticalScrollIndicator = false
        view.scrollView.isScrollEnabled = false
        return view
    }()
    
    /// 腾讯视频播放器
    lazy var superPlayerView: SuperPlayerView = {
        let view = SuperPlayerView(frame: playerImageView.bounds)
        view.coverImageView.contentMode = .scaleAspectFill
        view.fatherView = playerImageView
        let superPlayerViewConfig = SuperPlayerViewConfig()
        superPlayerViewConfig.maxCacheItem = 100
        view.playerConfig = superPlayerViewConfig
        view.isHidden = true
        return view
    }()
    
    /// 流动提示
    lazy var marqueeLabel: QMUIMarqueeLabel = {
        let label = QMUIMarqueeLabel()
        label.text = "所有内容均来自互联网，视频滚动水印广告请勿相信，谨防上当受骗。特此告知！！！"
        label.font = UIFont.cz_boldSystemFont(14)
        label.textColor = cz_standardTextColor
        return label
    }()
    
    lazy var tableView: UITableView = {
        let view = UITableView(frame: .zero, style: .plain)
            .cz
            .rowHeight(UITableView.automaticDimension)
            .estimatedRowHeight(50)
            .register(MoreBrilliantTableViewCell.self, forCellReuseIdentifier: MoreBrilliantTableViewCell.identifier)
            .register(VideoEpisodeTableViewCell.self, forCellReuseIdentifier: VideoEpisodeTableViewCell.identifier)
            .backgroundColor(cz_backgroundColor)
            .tableHeaderView(createTableHeaderView())
            .separatorStyle(.none)
            .build
        return view
    }()
    
    /// 分享
    var shareButton: UIButton!
    
    /// 下载
    var downloadButton: UIButton!
    
    /// 视频名称
    var videoNameLabel: UILabel!

    /// 视频信息 评分、年、地区、类别
    var videoInfoLabel: UILabel!
    
    /// 简介按钮
    var introductionButton: UIButton!
    
    /// 切换源按钮
    var switchSourceButton: UIButton!
    
    /// 解析源
    var switchParsingLabel: UILabel!
    
    /// 切换解析
    var switchParsingButton: UIButton!
    
    // MARK: - 初始化
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(playerImageView)
        wkWebView.cz.addSuperView(playerImageView)
        marqueeLabel.cz.addSuperView(self).makeConstraints { (make) in
            make.top.equalTo(playerImageView.snp.bottom)
            make.left.right.equalToSuperview()
            make.height.equalTo(CZCommon.cz_dynamicFitHeight(30))
        }
        tableView.cz.addSuperView(self).makeConstraints({ (make) in
            make.top.equalTo(marqueeLabel.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        })
    }
    
    private func createTableHeaderView() -> UIView {
        let tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: CZCommon.cz_screenWidth, height: CZCommon.cz_dynamicFitHeight(80)))
        
        // 简介
        introductionButton = UIButton()
            .cz
            .addSuperView(tableHeaderView)
            .makeConstraints({ (make) in
                make.right.equalToSuperview().offset(-10)
                make.top.equalToSuperview()
            })
            .font(.cz_systemFont(12))
            .titleColor(cz_unStandardTextColor, for: .normal)
            .setContentHuggingPriority(.required, for: .horizontal)
            .setContentCompressionResistancePriority(.required, for: .horizontal)
            .build
        introductionButton.cz_textAndPictureLocation(image: UIImage(named: "Icon_Video_Introduction_RightArrow"), title: "简介", titlePosition: .left, additionalSpacing: 0, state: .normal)
        
        // 视频名称
        videoNameLabel = UILabel()
             .cz
             .addSuperView(tableHeaderView)
             .makeConstraints({ (make) in
                make.left.equalToSuperview().offset(10)
                make.top.equalToSuperview().offset(0)
                make.right.equalTo(introductionButton.snp.left).offset(-10)
             })
            .font(.cz_boldSystemFont(14))
            .textColor(cz_standardTextColor)
            .numberOfLines(2)
            .build
        
        // 视频信息
        videoInfoLabel = UILabel()
            .cz
            .addSuperView(tableHeaderView)
            .makeConstraints({ (make) in
                make.left.equalToSuperview().offset(10)
                make.top.equalTo(videoNameLabel.snp.bottom).offset(5)
            })
            .font(.cz_systemFont(10))
            .textColor(cz_unStandardTextColor)
            .build
        
        /// 播放源
        let playerSourceLabel = UILabel()
            .cz
            .addSuperView(tableHeaderView)
            .makeConstraints({ (make) in
                make.left.equalToSuperview().offset(10)
                make.bottom.equalToSuperview().offset(-10)
            })
            .font(.cz_systemFont(10))
            .textColor(cz_unStandardTextColor)
            .text("切换播放源:")
            .setContentHuggingPriority(.required, for: .horizontal)
            .setContentCompressionResistancePriority(.required, for: .horizontal)
            .build
        
        switchSourceButton = UIButton()
            .cz
            .addSuperView(tableHeaderView)
            .makeConstraints({ (make) in
                make.left.equalTo(playerSourceLabel.snp.right).offset(5)
                make.centerY.equalTo(playerSourceLabel)
            })
            .titleColor(cz_standardTextColor, for: .normal)
            .font(.cz_boldSystemFont(10))
            .setContentHuggingPriority(.required, for: .horizontal)
            .setContentCompressionResistancePriority(.required, for: .horizontal)
            .build
        
        // 下载
        downloadButton = UIButton()
            .cz
            .addSuperView(tableHeaderView)
            .makeConstraints({ (make) in
                make.bottom.equalToSuperview().offset(-10)
                make.right.equalToSuperview().offset(-10)
            })
            .image(UIImage(named: "Icon_Video_Download"), for: .normal)
            .setContentHuggingPriority(.required, for: .horizontal)
            .setContentCompressionResistancePriority(.required, for: .horizontal)
            .build

        // 分享
        shareButton = UIButton()
            .cz
            .addSuperView(tableHeaderView)
            .makeConstraints({ (make) in
                make.centerY.equalTo(downloadButton)
                make.right.equalTo(downloadButton.snp.left).offset(-10)
            })
            .image(UIImage(named: "Icon_Video_Share"), for: .normal)
            .setContentHuggingPriority(.required, for: .horizontal)
            .setContentCompressionResistancePriority(.required, for: .horizontal)
            .build

        // 投屏
        let avRoutePickerView = AVRoutePickerView()
            .cz
            .addSuperView(tableHeaderView)
            .makeConstraints({ (make) in
                make.centerY.equalTo(downloadButton)
                make.right.equalTo(shareButton.snp.left).offset(-10)
            })
            .tintColor(.black)
            .setContentHuggingPriority(.required, for: .horizontal)
            .setContentCompressionResistancePriority(.required, for: .horizontal)
            .build
        avRoutePickerView.activeTintColor = .black
        
        switchParsingButton = UIButton()
            .cz
            .addSuperView(tableHeaderView)
            .makeConstraints({ (make) in
                make.right.equalTo(avRoutePickerView.snp.left).offset(-10)
                make.centerY.equalTo(switchSourceButton)
            })
            .titleColor(cz_standardTextColor, for: .normal)
            .font(.cz_boldSystemFont(10))
            .setContentHuggingPriority(.required, for: .horizontal)
           // .setContentCompressionResistancePriority(.required, for: .horizontal)
            .build
        
        switchParsingLabel = UILabel()
            .cz
            .addSuperView(tableHeaderView)
            .makeConstraints({ (make) in
                make.left.equalTo(switchSourceButton.snp.right).offset(10)
                make.right.equalTo(switchParsingButton.snp.left).offset(-5)
                make.centerY.equalTo(switchSourceButton)
            })
            .font(.cz_systemFont(10))
            .textColor(cz_unStandardTextColor)
            .text("切换解析接口:")
            .setContentCompressionResistancePriority(.required, for: .horizontal)
            .textAlignment(.right)
        // .setContentHuggingPriority(.required, for: .horizontal)
         //.setContentCompressionResistancePriority(.required, for: .horizontal)
            .build
        
        let _ = UIView()
            .cz
            .addSuperView(tableHeaderView)
            .makeConstraints { (make) in
                make.right.left.bottom.equalToSuperview()
                make.height.equalTo(1)
            }
            .backgroundColor(cz_dividerColor)
            .build
        return tableHeaderView
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
