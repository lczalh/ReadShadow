//
//  VideoDetailsController.swift
//  Random
//
//  Created by yu mingming on 2019/11/8.
//  Copyright © 2019 刘超正. All rights reserved.
//

import UIKit
import Tiercel
import WebKit
import SafariServices

class VideoDetailsController: BaseController {
    
    lazy var videoDetailsView: VideoDetailsView = {
        let view = VideoDetailsView()
        view.tableView.dataSource = self
        view.tableView.delegate = self
        view.superPlayerView.delegate = self
        view.wkWebView.navigationDelegate = self
        return view
    }()
    
    /// 本页数据模型
    var model: ReadShadowVideoModel! {
        didSet {
            currentPlayerSourceIndex = 0
            currentPlayerParsingIndex = 0
        }
    }
    
    /// 当前播放源索引
    private var currentPlayerSourceIndex: Int = 0 {
        didSet {
            currentSeriesNames = model.allPlayerSourceSeriesNames?[currentPlayerSourceIndex] ?? []
            currentSeriesUrls = model.allPlayerSourceSeriesUrls?[currentPlayerSourceIndex] ?? []
            currentPlayerSourceName = model.allPlayerSourceNames?[currentPlayerSourceIndex] ?? ""
            DispatchQueue.main.async {
                self.videoDetailsView.switchSourceButton.setTitle(self.currentPlayerSourceName, for: .normal)
                self.videoDetailsView.tableView.reloadData()
            }
        }
    }
    
    /// 当前播放源所有剧集名称
    private var currentSeriesNames: Array<String> = []
    
    /// 当前播放源所有剧集地址
    private var currentSeriesUrls: Array<String> = []
    
    /// 当前播放源
    private var currentPlayerSourceName: String = ""
    
    /// 当前播放解析索引
    private var currentPlayerParsingIndex: Int = 0 {
        didSet {
            let parsingInterfaceModel = parsingInterfaceModels[currentPlayerParsingIndex]
            currentParsingInterface = parsingInterfaceModel.parsingInterface ?? ""
            // 设置解析名称
            DispatchQueue.main.async { self.videoDetailsView.switchParsingButton.setTitle(parsingInterfaceModel.parsingName, for: .normal) }
        }
    }
    
    /// 当前解析接口
    private var currentParsingInterface: String = ""
    
    /// 所有影源模型
    private var readShadowVideoResourceModels: Array<ReadShadowVideoResourceModel> {
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
    
    /// 更多精彩模型数据
    private var moreWonderfulModels: Array<ReadShadowVideoModel> = []
    
    /// 所有解析接口
    private lazy var parsingInterfaceModels: Array<ParsingInterfaceModel> = {
        do {
            var models: Array<ParsingInterfaceModel> = []
            let files = try FileManager().contentsOfDirectory(atPath: parsingInterfaceFolderPath).filter{ $0.pathExtension == "plist" }
            for file in files {
                let model = CZObjectStore.standard.cz_unarchiver(filePath: "\(parsingInterfaceFolderPath)/\(file)") as? ParsingInterfaceModel
                models.append(model!)
            }
            return models
        } catch  {
            return []
        }
    }()
    
    /// 插页式广告
    private var gadInterstitial: GADInterstitial!
    
    /// 广告特权
    private lazy var isAdvertisingPrivilege: Bool = {
        return isGetAdvertisingPrivilege()
    }()
    
    /// 腾讯视频播放器播放模型
    private lazy var superPlayerModel: SuperPlayerModel = {
        let model = SuperPlayerModel()
        return model
    }()
    
    /// 是否显示状态栏
    private var statusBarHidden: Bool = false {
        didSet {
            setNeedsStatusBarAppearanceUpdate()
        }
    }
    
    // 播放类型枚举
    private enum VideoPlayType {
        case parsingPlay // 解析播放
        case directlyPlay // 直接播放
    }
    
    /// 记录当前播放类型
    private var currentPlayType: VideoPlayType?
    
    override func setupNavigationItems() {
        super.setupNavigationItems()
        titleView?.title = model.name
        navigationController?.setNavigationBarHidden(false, animated: false)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        if isAdvertisingPrivilege == false {
            requestAdvertising(adUnitId: "ca-app-pub-7194032995143004/7501390732")
        }
        showEmptyViewWithLoading()
        videoDetailsView.cz.addSuperView(view).makeConstraints { (make) in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        // 创建历史浏览记录文件夹
        _ = CZObjectStore.standard.cz_createFolder(folderPath: videoBrowsingRecordFolderPath)
        
        // 分享
        videoDetailsView.shareButton.rx.tap.subscribe(onNext: {[weak self] () in
            self?.callNativeShare(items: ["我在用“\(CZCommon.cz_appName)”，快来看看吧", UIImage(named: "AppIcon")!, URL(string: "https://apps.apple.com/cn/app/悦影-小说电影神器/id\(appId)".cz_encoded())!])
        }).disposed(by: rx.disposeBag)
        
        // 下载
        videoDetailsView.downloadButton.rx.tap.subscribe(onNext: {[weak self] () in
            DispatchQueue.main.async {
                let searchDownloadableVideoController = SearchDownloadableVideoController()
                searchDownloadableVideoController.vodName = self?.model.name ?? ""
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
        
        // 切换播放源
        videoDetailsView.switchSourceButton.rx.tap.subscribe(onNext: {[weak self] () in
            DispatchQueue.main.async {
                let switchVideoSourceController = SwitchVideoSourceController()
                switchVideoSourceController.titleName = "切换播放源"
                switchVideoSourceController.allPlayerSourceNames = self?.model.allPlayerSourceNames ?? []
                switchVideoSourceController.didSelectRowBlock = {[weak self] index in
                    self?.currentPlayerSourceIndex = index
                }
                self?.present(switchVideoSourceController, animated: false, completion: nil)
            }
        }).disposed(by: rx.disposeBag)
        
        // 切换解析
        videoDetailsView.switchParsingButton.rx.tap.subscribe(onNext: {[weak self] () in
            DispatchQueue.main.async {
                let switchVideoSourceController = SwitchVideoSourceController()
                switchVideoSourceController.titleName = "切换解析接口"
                switchVideoSourceController.allPlayerSourceNames = self?.parsingInterfaceModels.map{ $0.parsingName ?? "" } ?? []
                switchVideoSourceController.didSelectRowBlock = {[weak self] index in
                    self?.currentPlayerParsingIndex = index
                }
                self?.present(switchVideoSourceController, animated: false, completion: nil)
            }
        }).disposed(by: rx.disposeBag)
        
        //监听腾讯视频播放器当前播放时间
        _ = videoDetailsView.superPlayerView.rx.observeWeakly(CGFloat.self, "playCurrentTime")
            .takeUntil(rx.deallocated)
            .subscribe(onNext: {[weak self] (value) in
                // 记录当前播放时间 和 浏览时间
                self?.model.currentPlayTime = value ?? 0.0
                self?.model.browseTime = Date().string(withFormat: "yyyy-MM-dd HH:mm:ss")
                _ = CZObjectStore.standard.cz_archiver(object: self!.model!, filePath: "\(videoBrowsingRecordFolderPath)/\(self?.model.readShadowVideoResourceModel?.name ?? "")-\(self?.model.name ?? "").plist")
        })
        
        // 设置封面
        videoDetailsView.playerImageView.kf.indicatorType = .activity
        videoDetailsView.playerImageView.kf.setImage(with: URL(string: model.pic), placeholder: UIImage(named: "Icon_Placeholder"))
        // 设置视频名称
        videoDetailsView.videoNameLabel.text = model.name
        videoDetailsView.videoInfoLabel.text = "\(model.language ?? "未知")·\(model.year ?? "未知")·\(model.area ?? "未知")·\(model.category ?? (model.type ?? "未知"))·\(model.continu ?? "未知")"
        // 默认加载一次解析接口
        videoDetailsView.wkWebView.load(URLRequest(url: URL(string: currentParsingInterface)!))
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
        let readShadowVideoResourceModel = readShadowVideoResourceModels.first!
        CZNetwork.cz_request(target: VideoDataApi.getReadShadowVideoData(baseUrl: readShadowVideoResourceModel.baseUrl!, path: readShadowVideoResourceModel.path!, ac: "detail", categoryId: nil, pg: 1, wd: nil), model: ReadShadowVideoRootModel.self) {[weak self] (result) in
            switch result {
            case .success(let model):
                if let videoModels = model.data, videoModels.count > 0 {
                    var videos: [ReadShadowVideoModel] = []
                    for videoModel in videoModels {
                        guard filterVideoCategorys.filter({ videoModel.category == $0 }).first == nil else { continue }
                        // 默认播放首集
                        videoModel.currentPlayIndex = 0
                        videos.append(videoModel)
                    }
                    // 过滤空数组
                    guard videos.count > 0 else { return }
                    self?.moreWonderfulModels = videos
                    DispatchQueue.main.async { self?.videoDetailsView.tableView.reloadData() }
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
        DispatchQueue.main.async { self.present(controller, animated: true, completion: nil) }
    }
    
    /// 播放视频
    func playerVideo() {
        let url = currentSeriesUrls[model.currentPlayIndex!]
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
        let directBroadcastAction = UIAlertAction(title: "直接播放", style: .default) { (action) in
            self.currentPlayType = .directlyPlay
            DispatchQueue.main.async {
                self.videoDetailsView.wkWebView.load(URLRequest(url: URL(string: self.currentParsingInterface)!))
                self.videoDetailsView.wkWebView.isHidden = true
                self.videoDetailsView.superPlayerView.isHidden = false
                self.videoDetailsView.superPlayerView.startTime = self.model.currentPlayTime
                if self.currentSeriesNames.count > 1 {
                    self.videoDetailsView.superPlayerView.controlView.title = "\(self.model.name ?? "")\(self.currentSeriesNames[self.model.currentPlayIndex ?? 0])"
                } else {
                    self.videoDetailsView.superPlayerView.controlView.title = self.model.name
                }
                self.superPlayerModel.videoURL = url
                self.videoDetailsView.superPlayerView.play(with: self.superPlayerModel)
            }
        }
        let parsingPlayAction = UIAlertAction(title: "解析播放", style: .default) { (action) in
            if (try? String(contentsOf: URL(string: self.currentParsingInterface)!)) != nil {
                self.currentPlayType = .parsingPlay
                DispatchQueue.main.async {
                    self.videoDetailsView.superPlayerView.resetPlayer()
                    self.videoDetailsView.superPlayerView.isHidden = true
                    self.videoDetailsView.wkWebView.isHidden = false
                    self.videoDetailsView.wkWebView.load(URLRequest(url: URL(string: "\(self.currentParsingInterface)\(url)")!))
                }
            } else {
                CZHUD.showError("无效的解析接口")
            }
        }
        let cancelAction = UIAlertAction(title: "取消", style: .cancel) { (action) in }
        if url.contains(".m3u8") || url.contains(".mp4") {
            alertController.addAction(directBroadcastAction)
        }
        alertController.addAction(parsingPlayAction)
        alertController.addAction(cancelAction)
        DispatchQueue.main.async {
            self.present(alertController, animated: true, completion: nil)
        }
        // 更新历史记录
        model.browseTime = Date().string(withFormat: "yyyy-MM-dd HH:mm:ss")
        _ = CZObjectStore.standard.cz_archiver(object: model!, filePath: "\(videoBrowsingRecordFolderPath)/\(model.readShadowVideoResourceModel?.name ?? "")-\(model.name ?? "").plist")
    }
    
    override var prefersStatusBarHidden: Bool {
        return statusBarHidden
    }

    deinit {
        self.videoDetailsView.superPlayerView.resetPlayer()
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
            cell.segmentedDataSource.titles = currentSeriesNames
            cell.segmentedView.defaultSelectedIndex = model.currentPlayIndex ?? 0
            cell.segmentedView.reloadDataWithoutListContainer()
            cell.segmentedView.delegate = self
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: MoreBrilliantTableViewCell.identifier, for: indexPath) as! MoreBrilliantTableViewCell
            cell.models = moreWonderfulModels
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return CZCommon.cz_dynamicFitHeight(40)
        } else {
            return UITableView.automaticDimension
        }
    }
    
}

extension VideoDetailsController: JXSegmentedViewDelegate {
    
    func segmentedView(_ segmentedView: JXSegmentedView, didClickSelectedItemAt index: Int) {
        model.currentPlayIndex = index
        playerVideo()
    }
}

extension VideoDetailsController: SuperPlayerDelegate {
    /// 返回事件
    func superPlayerBackAction(_ player: SuperPlayerView!) {
        navigationController?.popViewController(animated: true)
    }
    
    /// 播放结束通知
    func superPlayerDidEnd(_ player: SuperPlayerView!) {
        guard model.currentPlayIndex != currentSeriesUrls.count - 1 else { return }
        model.currentPlayIndex! += 1
        let url = currentSeriesUrls[model.currentPlayIndex!]
        // 重置wkWebView 并隐藏
        videoDetailsView.wkWebView.load(URLRequest(url: URL(string: currentParsingInterface)!))
        videoDetailsView.wkWebView.isHidden = true
        videoDetailsView.superPlayerView.isHidden = false
        superPlayerModel.videoURL = url
        videoDetailsView.superPlayerView.controlView.title = "\(model.name ?? "")\(currentSeriesNames[model.currentPlayIndex ?? 0])"
        videoDetailsView.superPlayerView.play(with: superPlayerModel)
        DispatchQueue.main.async {
            self.videoDetailsView.tableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .none)
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

extension VideoDetailsController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
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
        
    }

    ///告诉委托用户单击将打开另一个应用程序
    ///(如App Store)，为当前应用设置后台。
    func interstitialWillLeaveApplication(_ ad: GADInterstitial) {
      print("interstitialWillLeaveApplication")
    }
}
