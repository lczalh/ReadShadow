//
//  VideoSourceManageController.swift
//  Random
//
//  Created by yu mingming on 2020/6/24.
//  Copyright © 2020 刘超正. All rights reserved.
//

import UIKit
import CryptoSwift

class VideoSourceManageController: BaseController {
    
    lazy var videoSourceManageView: VideoSourceManageView = {
        let view = VideoSourceManageView()
        view.tableView.dataSource = self
        view.tableView.delegate = self
        return view
    }()
    
    /// 影源
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
    
//    /// 所有影源模型
//    private lazy var readShadowVideoResourceModels: Array<ReadShadowVideoResourceModel> = {
//        return getApplicationConfigModel()?.videoResources ?? []
//    }()
    
    override func setupNavigationItems() {
        titleView?.title = "我的影源"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "添加", style: .done, target: nil, action: nil)
        navigationItem.rightBarButtonItem?.rx.tap.subscribe(onNext: {[weak self] () in
            DispatchQueue.main.async {
                let dialogTextFieldViewController = QMUIDialogTextFieldViewController()
                dialogTextFieldViewController.titleView?.title = "添加影源"
                dialogTextFieldViewController.submitButton?.isEnabled = true
                dialogTextFieldViewController.addTextField(withTitle: "影源名称") { (label, textField, layer) in

                }
                dialogTextFieldViewController.addTextField(withTitle: "影源地址") { (label, textField, layer) in

                }
                dialogTextFieldViewController.addCancelButton(withText: "取消") { _ in }
                dialogTextFieldViewController.addSubmitButton(withText: "添加") { (viewController) in
                    let videoSourceName = dialogTextFieldViewController.textFields?[0].text ?? ""
                    let videoSourceAddress = dialogTextFieldViewController.textFields?[1].text ?? ""
                    DispatchQueue.main.async { CZHUD.show("影源匹配中") }
                    // 匹配路径
                    let path = self?.videoSourcePathMatching(baseUrl: videoSourceAddress)
                    guard path != nil else {
                        DispatchQueue.main.async { CZHUD.show("影源匹配失败") }
                        return
                    }
                    // 匹配下载地址
                    let downloadPath = self?.videoSourceDownloadPathMatching(baseUrl: videoSourceAddress)
                    let mushroomCloud = ReadShadowVideoResourceModel()
                    mushroomCloud.name = videoSourceName
                    mushroomCloud.baseUrl = videoSourceAddress
                    mushroomCloud.path = path
                    mushroomCloud.downloadPath = downloadPath
                    let _ = CZObjectStore.standard.cz_archiver(object: mushroomCloud, filePath: videoResourceFolderPath + "/" + (mushroomCloud.name ?? "") + ".plist")
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
                        CZHUD.dismiss()
                        dialogTextFieldViewController.hideWith(animated: true) { _ in
                            let tabBarController = MainTabBarController()
                            let transtition = CATransition()
                            transtition.duration = 0.5
                            transtition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
                            UIApplication.shared.delegate?.window??.layer.add(transtition, forKey: "animation")
                            UIApplication.shared.delegate?.window??.rootViewController = tabBarController
                        }
                    }
                }
                dialogTextFieldViewController.show()
            }
        }).disposed(by: rx.disposeBag)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        videoSourceManageView.cz.addSuperView(view).makeConstraints { (make) in
            if #available(iOS 11.0, *) {
                make.edges.equalTo(view.safeAreaLayoutGuide)
            } else {
                make.edges.equalToSuperview().inset(UIEdgeInsets(top: CZCommon.cz_navigationHeight + CZCommon.cz_statusBarHeight, left: 0, bottom: 0, right: 0))
            }
        }
        
    }
    
    
    /// 影源路径匹配
    /// - Parameter baseUrl: 影源地址
    /// - Returns: 影源路径
    func videoSourcePathMatching(baseUrl: String) -> String? {
        if let _ = try? String(contentsOf: URL(string: "\(baseUrl)/api.php/provide/vod")!) {
            return "/api.php/provide/vod"
        }
        if let _ = try? String(contentsOf: URL(string: "\(baseUrl)/inc/s_feifeikkm3u8")!) {
            return "/inc/s_feifeikkm3u8"
        }
        if let _ = try? String(contentsOf: URL(string: "\(baseUrl)/inc/s_feifei3zuidam3u8")!) {
            return "/inc/s_feifei3zuidam3u8"
        }
        if let _ = try? String(contentsOf: URL(string: "\(baseUrl)/inc/s_feifei3")!) {
            return "/inc/s_feifei3"
        }
        if let _ = try? String(contentsOf: URL(string: "\(baseUrl)/inc/feifei3ckm3u8s")!) {
            return "/inc/feifei3ckm3u8s"
        }
        if let _ = try? String(contentsOf: URL(string: "\(baseUrl)/inc/feifei3")!) {
            return "/inc/feifei3"
        }
        if let _ = try? String(contentsOf: URL(string: "\(baseUrl)/inc/feifei3.4s")!) {
            return "/inc/feifei3.4s"
        }
        return nil
    }
    
    /// 影源下载路径匹配
    /// - Parameter baseUrl: 影源地址
    /// - Returns: 影源下载路径
    func videoSourceDownloadPathMatching(baseUrl: String) -> String? {
        if let _ = try? String(contentsOf: URL(string: "\(baseUrl)/inc/feifei3down")!) {
            return "/inc/feifei3down"
        }
        if let _ = try? String(contentsOf: URL(string: "\(baseUrl)/inc/feifeidown")!) {
            return "/inc/feifeidown"
        }
        return nil
    }
}

extension VideoSourceManageController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return readShadowVideoResourceModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: VideoResourceTableViewCell.identifier, for: indexPath) as! VideoResourceTableViewCell
        let model = readShadowVideoResourceModels[indexPath.row]
        cell.titleLabel.text = model.name
        return cell
    }
}

//// MARK: - SwipeTableViewCellDelegate
//extension VideoSourceManageController: SwipeTableViewCellDelegate {
//    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
//        if orientation == .left {
//            return nil
//        } else {
//            // 创建“删除”事件按钮
//            let deleteAction = SwipeAction(style: .destructive, title: "删除") { action, indexPath in
//                UIAlertController.cz_showAlertController("提示", "确定删除此影源？", .alert, self, "确定", { (action) in
//                    var models = self.videoSourceModels
//                    models.remove(at: indexPath.row)
//                    _ = CZObjectStore.standard.cz_objectWritePlist(object: models, filePath: bookSourceRulePath, key: bookSourceRuleKey)
//                    DispatchQueue.main.async { tableView.reloadData() }
//                }, "取消", nil)
//            }
//            //返回右侧事件按钮
//            return [deleteAction]
//        }
//    }
//
//    //自定义滑动过渡行为（可选）
//    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeTableOptions {
//        var options = SwipeTableOptions()
//        options.transitionStyle = .reveal
//        return options
//    }
//}
