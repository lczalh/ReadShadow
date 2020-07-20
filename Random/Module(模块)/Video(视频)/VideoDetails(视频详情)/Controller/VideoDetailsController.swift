//
//  VideoDetailsController.swift
//  Random
//
//  Created by yu mingming on 2019/11/8.
//  Copyright © 2019 刘超正. All rights reserved.
//

import UIKit
import Tiercel

class VideoDetailsController: BaseController {
    
    lazy var videoDetailsView: VideoDetailsView = {
        let view = VideoDetailsView()
        view.tableView.dataSource = self
        view.tableView.delegate = self
        view.superPlayerView.delegate = self
        view.superPlayerView.startTime = model.currentPlayTime
        return view
    }()
    
    /// 本页数据模型
    var model: VideoDataModel!
    
    /// 剧集
    var titles: Array<String> = []
    
    /// 播放地址
    var urls: Array<String> = []
    
//    /// 分组标题
//    var sectionTitles: Array<String> = []
    
    /// 播放模型
    lazy var superPlayerModel: SuperPlayerModel = {
        let model = SuperPlayerModel()
        return model
    }()
    
    /// 所有影源模型
    var readShadowVideoResourceModels: Array<ReadShadowVideoResourceModel> {
        do {
            var models: Array<ReadShadowVideoResourceModel> = []
            let files = try FileManager().contentsOfDirectory(atPath: videoResourceFolderPath).filter{ $0.pathExtension == "plist" }
            for file in files {
                let model = CZObjectStore.standard.cz_unarchiver(filePath: "\(videoResourceFolderPath)/\(file)") as? ReadShadowVideoResourceModel
                models.append(model!)
            }
            return models
        } catch  {
            return []
        }
    }
    
    /// 随机数
    private var randomNumber = 0
    
    /// 更多精彩模型数据
    private var moreWonderfulModels: Array<VideoDataModel> = []
    
    var statusBarHidden: Bool = false {
        didSet {
            DispatchQueue.main.async { self.setNeedsStatusBarAppearanceUpdate() }
        }
    }
    
    /// 插页式广告
    var gadInterstitial: GADInterstitial!
    
    /// 广告特权
    lazy var isAdvertisingPrivilege: Bool = {
        return isGetAdvertisingPrivilege()
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func setupNavigationItems() {
        super.setupNavigationItems()
        navigationController?.setNavigationBarHidden(true, animated: false)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        if isAdvertisingPrivilege == false {
            requestAdvertising(adUnitId: "ca-app-pub-7194032995143004/7501390732")
        }
        showEmptyViewWithLoading()
        videoDetailsView.cz.addSuperView(view).makeConstraints { (make) in
            if #available(iOS 11.0, *) {
                make.edges.equalTo(view.safeAreaLayoutGuide)
            } else {
                make.edges.equalToSuperview().inset(UIEdgeInsets(top: CZCommon.cz_navigationHeight + CZCommon.cz_statusBarHeight, left: 0, bottom: 0, right: 0))
            }
        }
    
        // 获取随机数
        randomNumber = Int(arc4random() % UInt32(readShadowVideoResourceModels.count - 1))
        
        // 创建历史浏览记录文件夹
        _ = CZObjectStore.standard.cz_createFolder(folderPath: videoBrowsingRecordFolderPath)
        
        //监听当前播放时间
        _ = videoDetailsView.superPlayerView.rx.observeWeakly(CGFloat.self, "playCurrentTime")
            .takeUntil(rx.deallocated)
            .subscribe(onNext: {[weak self] (value) in
                // 记录当前播放时间 和 浏览时间
                self?.model.currentPlayTime = value!
                self?.model.browseTime = Date().string(withFormat: "yyyy-MM-dd HH:mm:ss")
                _ = CZObjectStore.standard.cz_archiver(object: self!.model!, filePath: "\(videoBrowsingRecordFolderPath)/\(self?.model.vodName ?? "").plist")
        })
        
        // 分享
        videoDetailsView.shareButton.rx.tap.subscribe(onNext: {[weak self] () in
            self?.videoDetailsView.superPlayerView.pause()
            self?.callNativeShare(items: ["我在用“\(CZCommon.cz_appName)”，快来看看吧", UIImage(named: "AppIcon")!, URL(string: "https://apps.apple.com/cn/app/悦影-小说电影神器/id\(appId)".cz_encoded())!])
        }).disposed(by: rx.disposeBag)
        
        // 下载
        videoDetailsView.downloadButton.rx.tap.subscribe(onNext: {[weak self] () in
            DispatchQueue.main.async {
                let searchDownloadableVideoController = SearchDownloadableVideoController()
                searchDownloadableVideoController.vodName = self?.model.vodName ?? ""
                searchDownloadableVideoController.hidesBottomBarWhenPushed = true
                self?.navigationController?.pushViewController(searchDownloadableVideoController, animated: true)
            }
        }).disposed(by: rx.disposeBag)
        
        // 简介
        videoDetailsView.introductionButton.rx.tap.subscribe(onNext: {[weak self] () in
            DispatchQueue.main.async {
                let videoIntroductionController = VideoIntroductionController()
                videoIntroductionController.model = self!.model
                self?.present(videoIntroductionController, animated: false, completion: nil)
            }
        }).disposed(by: rx.disposeBag)
        
        // 数据处理
        self.dataTreating()
        
        getMoreWonderfulModels()
    }
    
    /// 请求广告
    func requestAdvertising(adUnitId: String) {
        gadInterstitial = GADInterstitial(adUnitID: adUnitId)
        gadInterstitial.delegate = self
        gadInterstitial.load(GADRequest())
    }
    
    /// 获取更多精彩模型数组
    func getMoreWonderfulModels() {
        let readShadowVideoResourceModel = readShadowVideoResourceModels[randomNumber]
        CZNetwork.cz_request(target: VideoDataApi.getVideoData(baseUrl: (readShadowVideoResourceModel.baseUrl)!,
                                                               path: (readShadowVideoResourceModel.path)!,
                                                               wd: nil,
                                                               p: 1,
                                                               cid: nil),
                             model: VideoRootModel.self) {[weak self] (result) in
            switch result {
                case .success(let model):
                    if let videoModels = model.data, videoModels.count > 0 {
                        var videos: [VideoDataModel] = []
                        for videoModel in videoModels {
                            guard filterVideoCategorys.filter({ videoModel.listName == $0 }).first == nil else {
                                continue
                            }
                            videos.append(videoModel)
                        }
                        // 过滤空数组
                        guard videos.count > 0 else {
                            return
                        }
                        self?.moreWonderfulModels = videos
//                        if self?.sectionTitles.count != 3 {
//                            self?.sectionTitles.append("更多精彩")
//                        }
                        DispatchQueue.main.async {
                            self?.videoDetailsView.tableView.reloadData()
                        }
                    }
                    
                    break
                case .failure(let error):
                    cz_print(error.localizedDescription)
                    break
                }
        }
    }
    
    /// 调用系统分享
    public func callNativeShare(items: Array<Any>) {
        let controller = UIActivityViewController(activityItems: items, applicationActivities: nil)
        controller.excludedActivityTypes = [
            UIActivity.ActivityType.mail,
            UIActivity.ActivityType.postToTwitter,
            UIActivity.ActivityType.message,
            UIActivity.ActivityType.print,
            UIActivity.ActivityType.assignToContact,
            UIActivity.ActivityType.addToReadingList,
            UIActivity.ActivityType.postToFlickr,
            UIActivity.ActivityType.postToVimeo,
            UIActivity.ActivityType.postToTencentWeibo,
            UIActivity.ActivityType.airDrop,
            UIActivity.ActivityType.openInIBooks
        ]
        controller.completionWithItemsHandler = {[weak self] activityType, completed, returnedItems, activityError in
            self?.videoDetailsView.superPlayerView.resume()
        }
        DispatchQueue.main.async { self.present(controller, animated: true, completion: nil) }
    }
    
    /// 数据处理
    func dataTreating() {
        guard self.model.vodUrl?.count ?? 0 > 0 else { return }
        var titleAndUrlAry: Array<String> = []
        if model.vodUrl?.contains("$$$") == true {
            titleAndUrlAry = model.vodUrl?.components(separatedBy: "$$$").filter{ $0.contains(".m3u8") }.first?.components(separatedBy: "\r\n") ?? []
        } else {
            titleAndUrlAry = model.vodUrl?.components(separatedBy: "\r\n").filter{ $0.contains("m3u8") } ?? []
        }
        for titleAndUrlString in titleAndUrlAry {
            let titleAndUrl = titleAndUrlString.components(separatedBy: "$")
            guard titleAndUrl.count == 2 else {
                CZHUD.showError("播放地址解析失败")
                return
            }
            self.titles.append(titleAndUrl.first!)
            self.urls.append(titleAndUrl.last!.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")
        }
        // 设置封面
        videoDetailsView.playerImageView.kf.indicatorType = .activity
        videoDetailsView.playerImageView.kf.setImage(with: URL(string: model.vodPic), placeholder: UIImage(named: "Icon_Placeholder"))
        videoDetailsView.superPlayerView.coverImageView.kf.indicatorType = .activity
        videoDetailsView.superPlayerView.coverImageView.kf.setImage(with: URL(string: model.vodPic), placeholder: UIImage(named: "Icon_Placeholder"))
        cz_print("视频地址：\(urls[model.currentPlayIndex ?? 0])")
        if isAdvertisingPrivilege == true {
            if urls.count > 1 {
                videoDetailsView.superPlayerView.controlView.title = "\(model.vodName ?? "")\(titles[model.currentPlayIndex ?? 0])"
            } else {
                videoDetailsView.superPlayerView.controlView.title = model.vodName
            }
            superPlayerModel.videoURL = urls[model.currentPlayIndex ?? 0]
            videoDetailsView.superPlayerView.play(with: superPlayerModel)
            // 刷新剧集
            videoDetailsView.tableView.reloadData()
        }
        // 设置视频名称
        videoDetailsView.videoNameLabel.text = model.vodName
        videoDetailsView.videoInfoLabel.text = "\(model.vodLanguage ?? "未知")·\(model.vodYear ?? "未知")·\(model.vodArea ?? "未知")·\(model.listName ?? (model.vodType ?? "未知"))"
        videoDetailsView.playerSourceLabel.text = "播放源：\(model.vodPlay ?? "")"
    }
    
    // 状态栏是否隐藏
    override var prefersStatusBarHidden: Bool {
        return statusBarHidden
    }

    deinit {
        /// 清理播放器内部状态，释放内存
        videoDetailsView.superPlayerView.resetPlayer()
    }

}

// MARK: - UITableViewDataSource
extension VideoDetailsController: UITableViewDataSource, UITableViewDelegate  {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: VideoEpisodeTableViewCell.identifier, for: indexPath) as! VideoEpisodeTableViewCell
            cell.episodeTitles = titles
            cell.selectorIndex = model.currentPlayIndex ?? 0
            cell.didSelectItemBlock = {[weak self] index in
                self?.model.currentPlayIndex = index
                if self?.urls.count ?? 0 > 1 {
                    self?.videoDetailsView.superPlayerView.controlView.title = "\(self?.model.vodName ?? "")\(self?.titles[index] ?? "")"
                } else {
                    self?.videoDetailsView.superPlayerView.controlView.title = self?.model.vodName
                }
                self?.superPlayerModel.videoURL = self?.urls[index]
                self?.videoDetailsView.superPlayerView.play(with: self?.superPlayerModel)
                DispatchQueue.main.async { tableView.reloadRows(at: [IndexPath(item: 0, section: 0)], with: .none) }
            }
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: MoreBrilliantTableViewCell.identifier, for: indexPath) as! MoreBrilliantTableViewCell
            cell.models = moreWonderfulModels
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return CZCommon.cz_dynamicFitHeight(50)
        } else {
            return UITableView.automaticDimension
        }
    }
    
}

extension VideoDetailsController: SuperPlayerDelegate {
    
    /// 返回事件
    func superPlayerBackAction(_ player: SuperPlayerView!) {
        DispatchQueue.main.async { self.navigationController?.popViewController(animated: true, nil) }
    }
    
    /// 播放结束通知
    func superPlayerDidEnd(_ player: SuperPlayerView!) {
        guard model.currentPlayIndex != urls.count - 1 else { return }
        model.currentPlayIndex! += 1
        videoDetailsView.superPlayerView.controlView.title = "\(model.vodName ?? "")\(titles[model.currentPlayIndex!])"
        superPlayerModel.videoURL = urls[model.currentPlayIndex!]
        videoDetailsView.superPlayerView.play(with: superPlayerModel)
        // 刷新剧集
        videoDetailsView.tableView.reloadData()
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

extension VideoDetailsController: GADInterstitialDelegate {
    /// 广告加载成功
    func interstitialDidReceiveAd(_ ad: GADInterstitial) {
        DispatchQueue.main.async {
            ad.present(fromRootViewController: self)
        }
    }

    /// 广告加载失败
    func interstitial(_ ad: GADInterstitial, didFailToReceiveAdWithError error: GADRequestError) {
        requestAdvertising(adUnitId: "ca-app-pub-7194032995143004/2475023559")
    }

    /// 告知委托将显示一个间隙。
    func interstitialWillPresentScreen(_ ad: GADInterstitial) {
      print("interstitialWillPresentScreen")
    }

    /// 告诉委托该间隙将被动画移出屏幕。
    func interstitialWillDismissScreen(_ ad: GADInterstitial) {
      print("interstitialWillDismissScreen")
    }

    /// 告诉委托该间隙已被动画移出屏幕。
    func interstitialDidDismissScreen(_ ad: GADInterstitial) {
        DispatchQueue.main.async {
            if self.urls.count > 1 {
                self.videoDetailsView.superPlayerView.controlView.title = "\(self.model.vodName ?? "")\(self.titles[self.model.currentPlayIndex ?? 0])"
            } else {
                self.videoDetailsView.superPlayerView.controlView.title = self.model.vodName
            }
            self.superPlayerModel.videoURL = self.urls[self.model.currentPlayIndex ?? 0]
            self.videoDetailsView.superPlayerView.play(with: self.superPlayerModel)
            // 刷新剧集
            self.videoDetailsView.tableView.reloadData()
        }
    }

    ///告诉委托用户单击将打开另一个应用程序
    ///(如App Store)，为当前应用设置后台。
    func interstitialWillLeaveApplication(_ ad: GADInterstitial) {
      print("interstitialWillLeaveApplication")
    }
}
