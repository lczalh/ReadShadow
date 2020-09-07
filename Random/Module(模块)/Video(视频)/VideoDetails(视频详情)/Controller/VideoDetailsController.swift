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
        return view
    }()
    
    /// 本页数据模型
    var model: ReadShadowVideoModel!
    
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
    
    override func setupNavigationItems() {
        super.setupNavigationItems()
        titleView?.title = model.name
        navigationController?.setNavigationBarHidden(true, animated: true)
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
                    self?.model.currentPlayerSourceIndex = index
                    DispatchQueue.main.async {
                        self?.videoDetailsView.switchSourceButton.setTitle(self?.model.allPlayerSourceNames?[self?.model.currentPlayerSourceIndex ?? 0], for: .normal)
                        self?.videoDetailsView.tableView.reloadData()
                    }
                    self?.playerVideo()
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
                    self?.model.currentPlayerParsingIndex = index
                    // 设置解析名称
                    DispatchQueue.main.async { self?.videoDetailsView.switchParsingButton.setTitle(self?.parsingInterfaceModels[self?.model.currentPlayerParsingIndex ?? 0].parsingName, for: .normal) }
                    self?.playerVideo()
                }
                self?.present(switchVideoSourceController, animated: false, completion: nil)
            }
        }).disposed(by: rx.disposeBag)
        
        //监听腾讯视频播放器当前播放时间
        _ = videoDetailsView.superPlayerView.rx.observeWeakly(CGFloat.self, "playCurrentTime").skip(1)
            .takeUntil(rx.deallocated)
            .subscribe(onNext: {[weak self] (value) in
                guard value != nil else { return }
                // 记录当前播放时间 和 浏览时间
                self?.model.allPlayerSourceSeriesCurrentTimes?[self?.model.currentPlayerSourceIndex ?? 0][self?.model.currentPlayIndex ?? 0] = value ?? 0.0
                self?.model.browseTime = Date().string(withFormat: "yyyy-MM-dd HH:mm:ss")
                _ = CZObjectStore.standard.cz_archiver(object: self!.model!, filePath: "\(videoBrowsingRecordFolderPath)/\(self?.model.readShadowVideoResourceModel?.name ?? "")-\(self?.model.name ?? "").plist")
        })
        
        // 设置封面
        videoDetailsView.playerImageView.kf.indicatorType = .activity
        videoDetailsView.playerImageView.kf.setImage(with: URL(string: model.pic), placeholder: UIImage(named: "Icon_Placeholder"))
        videoDetailsView.superPlayerView.coverImageView.kf.indicatorType = .activity
        videoDetailsView.superPlayerView.coverImageView.kf.setImage(with: URL(string: model.pic), placeholder: UIImage(named: "Icon_Placeholder"))
        // 设置视频名称
        videoDetailsView.videoNameLabel.text = model.name
        videoDetailsView.videoInfoLabel.text = "\(model.language ?? "未知")·\(model.year ?? "未知")·\(model.area ?? "未知")·\(model.category ?? (model.type ?? "未知"))·\(model.continu ?? "未知")"
        
        // 默认加载一次解析接口
      //  videoDetailsView.wkWebView.load(URLRequest(url: URL(string: self.parsingInterfaceModels[self.model.currentPlayerParsingIndex ?? 0].parsingInterface)!))
        
        // 设置默认的播放源名称
        videoDetailsView.switchSourceButton.setTitle(model.allPlayerSourceNames?[model.currentPlayerSourceIndex ?? 0], for: .normal)
        // 设置默认的解析接口名称
        videoDetailsView.switchParsingButton.setTitle(parsingInterfaceModels[model.currentPlayerParsingIndex ?? 0].parsingName, for: .normal)
        
        getMoreWonderfulModels()
        
        playerVideo()
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
        videoDetailsView.superPlayerView.resetPlayer()
        DispatchQueue.global().async {
            let url = self.model.allPlayerSourceSeriesUrls?[self.model.currentPlayerSourceIndex ?? 0][self.model.currentPlayIndex ?? 0] ?? ""
            if url.contains(".m3u8") || url.contains(".mp4") {
                self.directPlay(url: url)
            } else {
                CZHUD.showError("此格式无法播放")
//                CZNetwork.cz_request(target: VideoDataApi.straightChainVideoAnalysis(baseUrl: "http://js.voooe.cn/", path: "1787799317json", url: url), model: ParsingPlayModel.self, max: 1) {[weak self] (result) in
//                    switch result {
//                    case .success(let model):
//                        if model.url != nil, model.url?.isEmpty == false {
//                            self?.directPlay(url: model.url ?? "")
//                        } else {
//                            self?.webParsingPlay(url: url)
//                        }
//                        break
//                    case .failure(_):
//                        self?.webParsingPlay(url: url)
//                        break
//                    }
//                }
                
            }
            // 更新历史记录
            self.model.browseTime = Date().string(withFormat: "yyyy-MM-dd HH:mm:ss")
            _ = CZObjectStore.standard.cz_archiver(object: self.model!, filePath: "\(videoBrowsingRecordFolderPath)/\(self.model.readShadowVideoResourceModel?.name ?? "")-\(self.model.name ?? "").plist")
        }
    }
    
    /// 直接播放
    func directPlay(url: String) {
        DispatchQueue.main.async {
            self.videoDetailsView.switchParsingButton.isHidden = true
            self.videoDetailsView.switchParsingLabel.isHidden = true
           // self.videoDetailsView.wkWebView.load(URLRequest(url: URL(string: self.parsingInterfaceModels[self.model.currentPlayerParsingIndex ?? 0].parsingInterface)!))
         //   self.videoDetailsView.wkWebView.isHidden = true
            self.videoDetailsView.superPlayerView.isHidden = false
            self.videoDetailsView.superPlayerView.startTime = self.model.allPlayerSourceSeriesCurrentTimes?[self.model.currentPlayerSourceIndex ?? 0][self.model.currentPlayIndex ?? 0] ?? 0.0
            // 设置播放名称
            if self.model.allPlayerSourceSeriesNames?[self.model.currentPlayerSourceIndex ?? 0].count ?? 0 > 1 {
                self.videoDetailsView.superPlayerView.controlView.title = "\(self.model.name ?? "")\(self.model.allPlayerSourceSeriesNames?[self.model.currentPlayerSourceIndex ?? 0][self.model.currentPlayIndex ?? 0] ?? "")"
            } else {
                self.videoDetailsView.superPlayerView.controlView.title = self.model.name
            }
            let orginalUrl = URL.init(string: url)
            let parsedUrl = CBP2pEngine.sharedInstance().parse(streamURL: orginalUrl!)
            self.superPlayerModel.videoURL = parsedUrl.absoluteString
            self.videoDetailsView.superPlayerView.play(with: self.superPlayerModel)
        }
    }
    
    /// 网页解析播放
    func webParsingPlay(url: String) {
        guard parsingInterfaceModels.count > 0 else {
            CZHUD.showError("您还未添加解析接口")
            return
        }
        if (try? String(contentsOf: URL(string: parsingInterfaceModels[model.currentPlayerParsingIndex ?? 0].parsingInterface)!)) != nil {
            DispatchQueue.main.async {
                self.videoDetailsView.switchParsingButton.isHidden = false
                self.videoDetailsView.switchParsingLabel.isHidden = false
                self.videoDetailsView.superPlayerView.resetPlayer()
                self.videoDetailsView.superPlayerView.isHidden = true
              //  self.videoDetailsView.wkWebView.isHidden = false
              //  self.videoDetailsView.wkWebView.load(URLRequest(url: URL(string: "\(self.parsingInterfaceModels[self.model.currentPlayerParsingIndex ?? 0].parsingInterface ?? "")\(url)")!))
            }
        } else {
            CZHUD.showError("无效的解析接口")
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return statusBarHidden
    }

    deinit {
        self.videoDetailsView.superPlayerView.resetPlayer()
    }
    
//    // MARK: - 设置所有控制器的默认竖屏
//    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
//        return .all
//    }
//
//    override var shouldAutorotate: Bool {
//        return true
//    }
    

}

// MARK: - UITableViewDataSource
extension VideoDetailsController: UITableViewDataSource, UITableViewDelegate  {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: VideoEpisodeTableViewCell.identifier, for: indexPath) as! VideoEpisodeTableViewCell
            cell.segmentedDataSource.titles = model.allPlayerSourceSeriesNames?[model.currentPlayerSourceIndex ?? 0] ?? []
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
        guard model.currentPlayIndex != (self.model.allPlayerSourceSeriesUrls?[self.model.currentPlayerSourceIndex ?? 0].count ?? 0) - 1 else { return }
        model.currentPlayIndex! += 1
        let url = self.model.allPlayerSourceSeriesUrls?[self.model.currentPlayerSourceIndex ?? 0][self.model.currentPlayIndex ?? 0] ?? ""
        if url.contains(".m3u8") == false, url.contains(".mp4") == false {
            if player.isFullScreen == true {
                player.isFullScreen = false
            }
        }
            
        playerVideo()
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

//extension VideoDetailsController: SuperPlayerControlViewDelegate {
//
//}

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
