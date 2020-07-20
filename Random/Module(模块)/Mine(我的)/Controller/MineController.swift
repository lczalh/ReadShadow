//
//  MineController.swift
//  Random
//
//  Created by yu mingming on 2020/6/1.
//  Copyright © 2020 刘超正. All rights reserved.
//

import UIKit
import StoreKit

class MineController: BaseController {
    
    lazy var mineView: MineView = {
        let view = MineView()
        view.tableView.dataSource = self
        view.tableView.delegate = self
        return view
    }()
    
    lazy var sectionTitles: Array<String> = {
        return [
            "书源管理",
            "影源管理",
            "观影记录",
            "阅读记录",
            "给个好评",
            "免责声明",
            "隐私政策",
            "设备标识",
            "免广告特权"
        ]
    }()
    
    lazy var sectionImages: Array<String> = {
        return [
            "Icon_VideoResourceManage",
            "Icon_VideoResourceManage",
            "Icon_Record",
            "Icon_Record",
            "Icon_HighPraise",
            "Icon_Disclaimer",
            "Icon_PrivacyPolicy",
            "Icon_PrivacyPolicy",
            "Icon_PrivacyPolicy"
        ]
    }()
    
    /// 观影记录模型 并排序
    private var videoRecordModels: Array<ReadShadowVideoModel> = [] {
        didSet {
            DispatchQueue.main.async {
                self.mineView.tableView.reloadData()
            }
        }
    }
    
    /// 书浏览记录模型 并排序
    private var bookReadRecordModels: Array<BookReadModel> = [] {
        didSet {
            DispatchQueue.main.async {
                self.mineView.tableView.reloadData()
            }
        }
    }
    
    var videoRecordTableViewModels: Array<RecordTableViewModel> {
        return videoRecordModels.map { (model) -> RecordTableViewModel in
            let recordTableViewModel = RecordTableViewModel()
            recordTableViewModel.imageUrlString = model.pic ?? ""
            recordTableViewModel.titleName = model.name ?? ""
            return recordTableViewModel
        }
    }
    
    var bookReadTableViewModels: Array<RecordTableViewModel> {
        return bookReadRecordModels.map { (model) -> RecordTableViewModel in
            let recordTableViewModel = RecordTableViewModel()
            recordTableViewModel.imageUrlString = model.bookImageUrl ?? ""
            recordTableViewModel.titleName = model.bookName ?? ""
            return recordTableViewModel
        }
    }
    
    /// 广告对象
    var gadRewardedAd: GADRewardedAd?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DispatchQueue.global().async {
            self.videoRecordModels = self.getVideoRecordModels()
            self.bookReadRecordModels = self.getBookReadRecordModels()
        }
    }
    
    override func setupNavigationItems() {
        navigationController?.setNavigationBarHidden(false, animated: false)
        titleView?.title = "我的"
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        gadRewardedAd = createAndLoadRewardedAd(adUnitId: "ca-app-pub-7194032995143004/6203349728")
        mineView.cz.addSuperView(view).makeConstraints { (make) in
            if #available(iOS 11.0, *) {
                make.edges.equalTo(view.safeAreaLayoutGuide)
            } else {
                make.edges.equalToSuperview().inset(UIEdgeInsets(top: CZCommon.cz_navigationHeight + CZCommon.cz_statusBarHeight, left: 0, bottom: 0, right: 0))
            }
        }
    }
    
    /// 获取广告
    /// - Parameter adUnitId: 广告id
    /// - Returns: 广告对象
    func createAndLoadRewardedAd(adUnitId: String) -> GADRewardedAd {
        let gadRewardedAd = GADRewardedAd(adUnitID: adUnitId)
        gadRewardedAd.load(GADRequest()) { error in
            if let error = error {
                cz_print("广告加载失败\(error.localizedDescription)")
            } else {
                cz_print("广告加载成功")
            }
        }
        return gadRewardedAd
    }
    
    /// 获取视频浏览记录
    /// - Returns: 视频浏览记录模型数组
    private func getVideoRecordModels() -> Array<ReadShadowVideoModel> {
        do {
            var models: Array<ReadShadowVideoModel> = []
            let files = try FileManager().contentsOfDirectory(atPath: videoBrowsingRecordFolderPath).filter{ $0.pathExtension == "plist" }
            for file in files {
                let model = CZObjectStore.standard.cz_unarchiver(filePath: "\(videoBrowsingRecordFolderPath)/\(file)") as? ReadShadowVideoModel
                models.append(model!)
            }
            return models.sorted { (modelOne, modelTwo) -> Bool in
                let oneDate = modelOne.browseTime?.date(withFormat: "yyyy-MM-dd HH:mm:ss")
                let twoDate = modelTwo.browseTime?.date(withFormat: "yyyy-MM-dd HH:mm:ss")
                return oneDate!.compare(twoDate!) == .orderedDescending
            }
        } catch  {
            return []
        }
    }
    
    private func getBookReadRecordModels() -> Array<BookReadModel> {
        do {
            var models: Array<BookReadModel> = []
            let files = try FileManager().contentsOfDirectory(atPath: bookBrowsingRecordFolderPath).filter{ $0.pathExtension == "plist" }
            for file in files {
                let model = CZObjectStore.standard.cz_unarchiver(filePath: "\(bookBrowsingRecordFolderPath)/\(file)") as? BookReadModel
                models.append(model!)
            }
            return models.sorted { (modelOne, modelTwo) -> Bool in
                let oneDate = modelOne.browseTime?.date(withFormat: "yyyy-MM-dd HH:mm:ss")
                let twoDate = modelTwo.browseTime?.date(withFormat: "yyyy-MM-dd HH:mm:ss")
                return oneDate!.compare(twoDate!) == .orderedDescending
            }
        } catch  {
            return []
        }
    }
}

extension MineController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitles.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionTitle = sectionTitles[section]
        switch sectionTitle {
            case "观影记录":
                return 1
            case "阅读记录":
                return 1
            default:
                return 0
            }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let sectionTitle = sectionTitles[indexPath.section]
        switch sectionTitle {
            case "观影记录":
                let cell = tableView.dequeueReusableCell(withIdentifier: RecordTableViewCell.identifier, for: indexPath) as! RecordTableViewCell
                cell.recordTableViewModels = videoRecordTableViewModels
                cell.didSelectItemBlock = {[weak self] indexPath in
                    DispatchQueue.main.async {
                        let viewingRecordModel = self?.videoRecordModels[indexPath.row]
                        let videoDetailsController = VideoDetailsController()
                        videoDetailsController.hidesBottomBarWhenPushed = true
                        videoDetailsController.model = viewingRecordModel
                        self?.navigationController?.pushViewController(videoDetailsController, animated: true)
                    }
                }
                return cell
            case "阅读记录":
                let cell = tableView.dequeueReusableCell(withIdentifier: RecordTableViewCell.identifier, for: indexPath) as! RecordTableViewCell
                cell.recordTableViewModels = bookReadTableViewModels
                cell.didSelectItemBlock = {[weak self] indexPath in
                    DispatchQueue.main.async {
                        let bookReadModel = self?.bookReadRecordModels[indexPath.row]
                        let bookReadDetailsController = BookReadDetailsController()
                        bookReadDetailsController.bookReadModel = bookReadModel
                        bookReadDetailsController.hidesBottomBarWhenPushed = true
                        self?.navigationController?.pushViewController(bookReadDetailsController, animated: true)
                    }
                }
                return cell
            default:
                return UITableViewCell()
            }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let sectionTitle = sectionTitles[indexPath.section]
        switch sectionTitle {
            case "观影记录":
                return videoRecordTableViewModels.count == 0 ? 0 : CZCommon.cz_dynamicFitHeight(100)
            case "阅读记录":
                return bookReadRecordModels.count == 0 ? 0 : CZCommon.cz_dynamicFitHeight(100)
            default:
                return CZCommon.cz_dynamicFitHeight(40)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CZCommon.cz_dynamicFitHeight(40)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionTitle = sectionTitles[section]
        let sectionImage = sectionImages[section]
        if sectionTitle == "设备标识" {
            let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: DeviceIdentifierTabelHeaderView.identifier) as! DeviceIdentifierTabelHeaderView
            headerView.titleLabel.text = sectionTitle
            headerView.leftImageView.image = UIImage(named: sectionImage)
            return headerView
        } else {
            let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: MineTableHeaderView.identifier) as! MineTableHeaderView
            headerView.titleLabel.text = sectionTitle
            headerView.leftImageView.image = UIImage(named: sectionImage)
            headerView.tapBlock = {[weak self] recognizer in
                if sectionTitle == "书源管理" {
                    let bookSourceManageController = BookSourceManageController()
                    bookSourceManageController.hidesBottomBarWhenPushed = true
                    DispatchQueue.main.async {
                        self?.navigationController?.pushViewController(bookSourceManageController, animated: true)
                    }
                } else if sectionTitle == "影源管理" {
                    DispatchQueue.main.async {
                        let videoSourceManageController = VideoSourceManageController()
                        videoSourceManageController.hidesBottomBarWhenPushed = true
                        self?.navigationController?.pushViewController(videoSourceManageController, animated: true)
                    }
                } else if sectionTitle == "观影记录" {
                    DispatchQueue.main.async {
                        let browsingHistoryController = BrowsingHistoryController()
                        browsingHistoryController.type = "0"
                        browsingHistoryController.hidesBottomBarWhenPushed = true
                        self?.navigationController?.pushViewController(browsingHistoryController, animated: true)
                    }
                } else if sectionTitle == "阅读记录" {
                    DispatchQueue.main.async {
                        let browsingHistoryController = BrowsingHistoryController()
                        browsingHistoryController.type = "1"
                        browsingHistoryController.hidesBottomBarWhenPushed = true
                        self?.navigationController?.pushViewController(browsingHistoryController, animated: true)
                    }
                } else if sectionTitle == "给个好评" {
                    DispatchQueue.main.async { SKStoreReviewController.requestReview() }
                } else if sectionTitle == "免责声明" {
                   let privacyPolicyController = PrivacyPolicyController()
                   privacyPolicyController.titleView?.title = sectionTitle
                   privacyPolicyController.fileURLWithPath = Bundle.main.path(forResource: "Disclaimer", ofType: "txt")
                   privacyPolicyController.hidesBottomBarWhenPushed = true
                   DispatchQueue.main.async { self?.navigationController?.pushViewController(privacyPolicyController, animated: true) }
                } else if sectionTitle == "隐私政策" {
                    let privacyPolicyController = PrivacyPolicyController()
                    privacyPolicyController.titleView?.title = sectionTitle
                    privacyPolicyController.fileURLWithPath = Bundle.main.path(forResource: "PrivacyPolicy", ofType: "txt")
                    privacyPolicyController.hidesBottomBarWhenPushed = true
                    DispatchQueue.main.async { self?.navigationController?.pushViewController(privacyPolicyController, animated: true) }
                } else if sectionTitle == "免广告特权" {
                    DispatchQueue.main.async {
                        if self!.gadRewardedAd?.isReady == true {
                            self!.gadRewardedAd?.present(fromRootViewController: self!, delegate:self!)
                        } else {
                            CZHUD.showError("广告加载中，请稍后再试!")
                        }
                    }
                }
            }
            return headerView
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
}

extension MineController: GADRewardedAdDelegate {
    /// 告诉委托用户获得了奖励。
    func rewardedAd(_ rewardedAd: GADRewardedAd, userDidEarn reward: GADAdReward) {
        // 计算到期时间
        let expirationTime = Date() + 1.days
        // 判断偏好设置中是否存在到期时间
        let existingExpirationTime = CZObjectStore.standard.cz_readObjectInUserDefault(key: "expirationTime")
        
        if existingExpirationTime == nil || (existingExpirationTime as! Date) < Date() { // 小于当前时间，本地时间过期\ 本地时间不存在，则重写写入
            CZObjectStore.standard.cz_objectWriteUserDefault(object: expirationTime, key: "expirationTime")
            CZHUD.showSuccess("已获得免广告特权，到期时间：\(expirationTime.string(withFormat: "yyyy-MM-dd HH:mm:ss"))")
        } else { // 本地时间有效
            CZHUD.showSuccess("已获得免广告特权，不可重复获取！到期时间：\(expirationTime.string(withFormat: "yyyy-MM-dd HH:mm:ss"))")
//            expirationTime = (existingExpirationTime as! Date) + 1.days
//            CZObjectStore.standard.cz_objectWriteUserDefault(object: expirationTime, key: "expirationTime")
        }
    }
    /// 告知委托已显示已奖励的广告。
    func rewardedAdDidPresent(_ rewardedAd: GADRewardedAd) {
      print("Rewarded ad presented.")
    }
    /// 告知委托已取消已奖励的广告。
    func rewardedAdDidDismiss(_ rewardedAd: GADRewardedAd) {
        gadRewardedAd = createAndLoadRewardedAd(adUnitId: "ca-app-pub-7194032995143004/4997530520")
    }
    /// 告知委托被奖励的广告未能呈现。
    func rewardedAd(_ rewardedAd: GADRewardedAd, didFailToPresentWithError error: Error) {
        
    }
}
