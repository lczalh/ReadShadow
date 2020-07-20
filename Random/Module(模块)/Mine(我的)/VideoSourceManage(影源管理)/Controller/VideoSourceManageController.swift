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
//        if videoSourceModels.count == 0 {
//            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "添加", style: .done, target: nil, action: nil)
//        }
//        navigationItem.rightBarButtonItem?.rx.tap.subscribe(onNext: {[weak self] () in
//            DispatchQueue.main.async {
//                let dialogTextFieldViewController = QMUIDialogTextFieldViewController()
//                dialogTextFieldViewController.titleView?.title = "添加影源"
//                dialogTextFieldViewController.submitButton?.isEnabled = true
//                dialogTextFieldViewController.addTextField(withTitle: "影源路径") { (label, textField, layer) in
//
//                }
//                dialogTextFieldViewController.addCancelButton(withText: "取消") { _ in }
//                dialogTextFieldViewController.addSubmitButton(withText: "添加") { (viewController) in
//                    dialogTextFieldViewController.hideWith(animated: true) {[weak self] _ in
//                        let value = dialogTextFieldViewController.textFields![0].text!
//                        let md5Key = "824092805" + UIDevice.vkKeychainIDFV() + "824092805"
////                        guard md5Key.md5() == value else {
////                            CZHUD.showError("影源路径有误!")
////                            return
////                        }
//                        // 添加视频资源
//                        let videoResources = [
//                            VideoSourceModel(name: "酷云资源", address: "http://caiji.kuyun98.com", allDataPath: "/inc/s_feifeikkm3u8", downloadDataPath: "/inc/feifei3down"),
//                            VideoSourceModel(name: "OK资源", address: "https://cj.okzy.tv", allDataPath: "/inc/feifei3ckm3u8s", downloadDataPath: "/inc/feifei3down"),
//                            VideoSourceModel(name: "最大资源", address: "http://www.zdziyuan.com", allDataPath: "/inc/s_feifei3zuidam3u8", downloadDataPath: "/inc/feifeidown"),
//                            VideoSourceModel(name: "酷播资源", address: "http://api.kbzyapi.com", allDataPath: "/inc/s_feifei3.4", downloadDataPath: ""),
//                            VideoSourceModel(name: "最新资源", address: "http://api.zuixinapi.com", allDataPath: "/inc/feifei3", downloadDataPath: ""),
//                           // VideoSourceModel(name: "卧龙云资源", address: "https://cj.wlzy.tv", allDataPath: "/api/ffs/vod", downloadDataPath: ""),
//                            VideoSourceModel(name: "135资源", address: "http://cj.zycjw1.com", allDataPath: "/inc/feifei3", downloadDataPath: ""),
//                            VideoSourceModel(name: "永久云资源", address: "http://www.yongjiuzy1.com", allDataPath: "/inc/s_feifei3", downloadDataPath: ""),
//                            VideoSourceModel(name: "麻花云资源", address: "https://www.mhapi123.com", allDataPath: "/inc/feifei3", downloadDataPath: ""),
//                            VideoSourceModel(name: "速播资源", address: "https://www.subo988.com", allDataPath: "/inc/feifei3.4", downloadDataPath: "")
//                        ]
//                        // 创建影源文件夹
//                        let _ = CZObjectStore.standard.cz_createFolder(folderPath: videoResourceFolderPath)
//
//                        // 存储所有视频资源
//                        for videoResource in videoResources {
//                            _ = CZObjectStore.standard.cz_archiver(object: videoResource, filePath: videoResourceFolderPath + "/" + (videoResource.name ?? "") + ".plist")
//                        }
//
//                        DispatchQueue.main.async {
//                            self?.videoSourceManageView.tableView.reloadData()
//                            // 动态创建 视频控制器
//                            let navigationController = BaseNavigationController(rootViewController: VideoHomeController())
//                            let tabbarItem = UITabBarItem()
//                            tabbarItem.title = "视频"
//                            tabbarItem.image = UIImage(named: "Icon_Video")
//                            tabbarItem.tag = 2
//                            tabbarItem.selectedImage = UIImage(named: "Icon_Video")
//                            navigationController.tabBarItem = tabbarItem
//                            self?.tabBarController?.viewControllers?.insert(navigationController, at: 1)
//                        }
//                    }
//                }
//                dialogTextFieldViewController.show()
//            }
//        }).disposed(by: rx.disposeBag)
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
