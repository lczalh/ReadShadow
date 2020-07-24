//
//  FeedReaderViewController.swift
//  Random
//
//  Created by yu mingming on 2019/11/5.
//  Copyright © 2019 刘超正. All rights reserved.
//

import UIKit

class VideoHomeController: BaseController {
    
    lazy var videoHomeView: VideoHomeView = {
        let view = VideoHomeView()
        return view
    }()
    
    lazy var listContainerView: JXSegmentedListContainerView = {
        let view = JXSegmentedListContainerView(dataSource: self)
        videoHomeView.segmentedView.listContainer = view
        return view
    }()
    
    /// 分类
    var titles: Array<String> = []
    
    /// 分类id
    var ids: Array<Int> = []
    
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
    
    override func setupNavigationItems() {
        super.setupNavigationItems()
        DispatchQueue.main.async { self.navigationController?.setNavigationBarHidden(true, animated: false) }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        videoHomeView.cz.addSuperView(view).makeConstraints { (make) in
            if #available(iOS 11.0, *) {
                make.edges.equalTo(view.safeAreaLayoutGuide)
            } else {
                make.edges.equalToSuperview().inset(UIEdgeInsets(top: 0, left: 0, bottom: CZCommon.cz_tabbarHeight, right: 0))
            }
        }
        listContainerView.cz.addSuperView(videoHomeView).makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(videoHomeView.segmentedView.snp.bottom)
        }
        
        // 搜索
        videoHomeView.videoSearchFeatureView.tapSearchLabelBlock = {[weak self] tap in
            DispatchQueue.main.async {
                let videoSearchDetailsController = VideoSearchController()
                videoSearchDetailsController.hidesBottomBarWhenPushed = true
                self?.navigationController?.pushViewController(videoSearchDetailsController, animated: true)
            }
        }
        
        // 下载
        videoHomeView.videoSearchFeatureView.cacheButton.rx.tap.subscribe(onNext: {[weak self] in
            DispatchQueue.main.async {
                let videoDownloadManageController = VideoDownloadManageController()
                videoDownloadManageController.hidesBottomBarWhenPushed = true
                self?.navigationController?.pushViewController(videoDownloadManageController, animated: true)
            }
        }).disposed(by: rx.disposeBag)
        
        getVideoData()
        
    }
    
    // MARK: - 获取视频分类
    @objc func getVideoData() {
        showEmptyViewWithLoading()
        let readShadowVideoResourceModel = readShadowVideoResourceModels.first!
        
        CZNetwork.cz_request(target: VideoDataApi.getReadShadowVideoData(baseUrl: readShadowVideoResourceModel.baseUrl!, path: readShadowVideoResourceModel.path!, ac: "list", categoryId: 1, pg: nil, wd: nil), model: ReadShadowVideoRootModel.self) {[weak self] (result) in
            switch result {
                case .success(let model):
                    if let videoModels = model.category, videoModels.count > 0 {
                        self?.titles.removeAll()
                        self?.ids.removeAll()
                        for list in videoModels {
                            // 数据过滤
                            guard let listName = list.categoryName, filterVideoCategorys.filter({ listName == $0 }).first == nil else { continue }
                            self?.titles.append(listName)
                            if let categoryId = list.categoryId as? Int {
                                self?.ids.append(categoryId)
                            } else if let categoryId = list.categoryId as? String {
                                self?.ids.append(Int(categoryId)!)
                            }
                            
                        }
                        self?.titles.reverse()
                        self?.ids.reverse()
                        DispatchQueue.main.async {
                            self?.videoHomeView.segmentedDataSource.titles = self!.titles
                            self?.videoHomeView.segmentedView.defaultSelectedIndex = 0
                            self?.videoHomeView.segmentedView.reloadData()
                        }
                    }
                    self?.showOrHideEmptyView(text: "暂无数据")
                    break
                case .failure(let error):
                    self?.showOrHideEmptyView(text: error.localizedDescription)
                    break
            }
        }
        
    }
    
    // MARK: - 显示或隐藏空视图
    func showOrHideEmptyView(text: String?) {
        titles.count == 0 ? showEmptyView(withText: text, detailText: nil, buttonTitle: "重新加载", buttonAction: #selector(self.getVideoData)) : hideEmptyView()
    }
}

extension VideoHomeController: JXSegmentedListContainerViewDataSource {
    func numberOfLists(in listContainerView: JXSegmentedListContainerView) -> Int {
        return titles.count
    }

    func listContainerView(_ listContainerView: JXSegmentedListContainerView, initListAt index: Int) -> JXSegmentedListContainerViewListDelegate {
        let videoListController = VideoListController()
        videoListController.index = ids[index]
        videoListController.readShadowVideoResourceModel = readShadowVideoResourceModels.first
        return videoListController
    }
    
    
}

