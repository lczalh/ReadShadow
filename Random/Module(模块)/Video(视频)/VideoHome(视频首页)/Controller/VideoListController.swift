//
//  VideoListController.swift
//  Random
//
//  Created by 刘超正 on 2019/11/7.
//  Copyright © 2019 刘超正. All rights reserved.
//

import UIKit

class VideoListController: BaseController {
    
    /// 页面索引
    var index: Int!
    
    /// 当前页码
    var currentPage: Int = 1
    
    /// 列表数据
    var models: Array<ReadShadowVideoModel> = []
    
    /// 轮播图数据
    var shufflingFigureModels: Array<ReadShadowVideoModel> = []
    
    /// 影源模型
    var readShadowVideoResourceModel: ReadShadowVideoResourceModel!
    
    lazy var videoListView: VideoListView = {
        let view = VideoListView()
        view.collectionView.dataSource = self
        view.collectionView.delegate = self
        //设置头部刷新控件
        let header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(downRefresh))
        view.collectionView.mj_header = header
        //设置尾部刷新控件
        let footer = MJRefreshBackNormalFooter(refreshingTarget: self, refreshingAction: #selector(pullRefresh))
        view.collectionView.mj_footer = footer
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        videoListView.cz.addSuperView(view).makeConstraints { (make) in
            if #available(iOS 11.0, *) {
                make.edges.equalTo(view.safeAreaLayoutGuide)
            } else {
                make.edges.equalToSuperview()
            }
        }
        
        videoListView.collectionView.mj_header?.beginRefreshing()
        
    }
    
    @objc func downRefresh() {
        currentPage = 1
        models.removeAll()
        getVideoData()
    }

    @objc func pullRefresh() {
        currentPage += 1
        getVideoData()
    }
    
    // MARK: - 获取视频数据
    @objc func getVideoData() {
        CZNetwork.cz_request(target: VideoDataApi.getReadShadowVideoData(baseUrl: readShadowVideoResourceModel.baseUrl!, path: readShadowVideoResourceModel.path!, ac: "detail", categoryId: index, pg: currentPage, wd: nil), model: ReadShadowVideoRootModel.self) {[weak self] (result) in
            switch result {
            case .success(let model):
                if let videoModels = model.data, videoModels.count > 0 {
                    var videos: [ReadShadowVideoModel] = []
                    for videoModel in videoModels.filter({ $0.url != nil && $0.url?.isEmpty == false }) {
                        guard filterVideoCategorys.filter({ videoModel.category == $0 }).first == nil else { continue }
                        // 默认播放首集
                        videoModel.currentPlayIndex = 0
                        videoModel.readShadowVideoResourceModel = self?.readShadowVideoResourceModel
                        videos.append(videoModel)
                    }
                    // 过滤空数组
                    guard videos.count > 0 else { return }
                    for (index, data) in videos.enumerated() {
                        data.readShadowVideoResourceModel = self?.readShadowVideoResourceModel
                        if index < 3 && self?.shufflingFigureModels.count != 3 { // 轮播图数据
                            self?.shufflingFigureModels.append(data)
                        } else { // 列表数据
                            self?.models.append(data)
                        }
                    }
                }
                DispatchQueue.main.async {
                    self?.videoListView.collectionView.reloadData()
                    if self?.videoListView.collectionView.mj_header?.isRefreshing == true {
                        self?.videoListView.collectionView.mj_header?.endRefreshing()
                        self?.videoListView.collectionView?.performBatchUpdates({
                            UIView.animate(views: (self?.videoListView.collectionView!.orderedVisibleCells)!,
                                       animations: [AnimationType.random()], options: [.curveEaseInOut], completion: {})
                        }, completion: nil)
                    }
                    if self?.videoListView.collectionView.mj_footer?.isRefreshing == true {
                        self?.videoListView.collectionView.mj_footer?.endRefreshing()
                    }
                    self?.showOrHideEmptyView(text: "暂无数据")
                }
                break
            case .failure(let error):
                DispatchQueue.main.async {
                    if self?.videoListView.collectionView.mj_header?.isRefreshing == true {
                        self?.videoListView.collectionView.mj_header?.endRefreshing()
                    }
                    if self?.videoListView.collectionView.mj_footer?.isRefreshing == true {
                        self?.videoListView.collectionView.mj_footer?.endRefreshing()
                    }
                    self?.showOrHideEmptyView(text: error.localizedDescription)
                }
                break
            }
        }
    }
    
    // MARK: - 显示或隐藏空视图
    func showOrHideEmptyView(text: String?) {
        models.count == 0 ? showEmptyView(withText: text, detailText: nil, buttonTitle: "重新加载", buttonAction: #selector(self.getVideoData)) : hideEmptyView()
    }


}


extension VideoListController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return models.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: VideoListCollectionViewCell.identifier, for: indexPath) as! VideoListCollectionViewCell
        let model = models[indexPath.row]
        cell.videoImageView.kf.indicatorType = .activity
        cell.videoImageView.kf.setImage(with: URL(string: model.pic), placeholder: UIImage(named: "Icon_Placeholder"))
        cell.titleLabel.text = model.name
        if model.continu == nil || model.continu?.isEmpty == true {
            cell.continuLabel.text = model.year
        } else {
            cell.continuLabel.text = model.continu
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: VideoListCollectionHeaderView.identifier, for: indexPath) as! VideoListCollectionHeaderView
            headerView.shufflingFigureView.fsPageControl.numberOfPages = shufflingFigureModels.count
            headerView.shufflingFigureView.fsPagerView.dataSource = self
            headerView.shufflingFigureView.fsPagerView.delegate = self
            headerView.shufflingFigureView.fsPagerView.reloadData()
            return headerView
        } else {
            return UIView() as! UICollectionReusableView
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let model = self.models[indexPath.row]
        DispatchQueue.main.async {
            let videoDetailsController = VideoDetailsController()
            videoDetailsController.hidesBottomBarWhenPushed = true
            videoDetailsController.model = model
            self.navigationController?.pushViewController(videoDetailsController, animated: true)
        }
    }

}

extension VideoListController: UICollectionViewDelegate {
    
}

// MARK: - FSPagerViewDataSource
extension VideoListController: FSPagerViewDataSource{
    func numberOfItems(in pagerView: FSPagerView) -> Int {
        return shufflingFigureModels.count
    }
    
    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "FSPagerViewCell", at: index)
        let model = shufflingFigureModels[index]
        cell.imageView?.kf.indicatorType = .activity
        cell.imageView?.kf.setImage(with: URL(string: model.pic), placeholder: UIImage(named: "Icon_Placeholder"))
        cell.imageView?.contentMode = .scaleAspectFill
        cell.imageView?.clipsToBounds = true
        cell.textLabel?.text = model.name
        return cell
    }
}

// MARK: - FSPagerViewDelegate
extension VideoListController: FSPagerViewDelegate {
    func pagerView(_ pagerView: FSPagerView, didSelectItemAt index: Int) {
        pagerView.deselectItem(at: index, animated: true)
        pagerView.scrollToItem(at: index, animated: true)
        let model = shufflingFigureModels[index]
        let videoDetailsController = VideoDetailsController()
        videoDetailsController.hidesBottomBarWhenPushed = true
        videoDetailsController.model = model
        DispatchQueue.main.async { self.navigationController?.pushViewController(videoDetailsController, animated: true) }
    }
    
    func pagerViewWillEndDragging(_ pagerView: FSPagerView, targetIndex: Int) {
        let headerView = videoListView.collectionView.cz_subView(seekSubView: VideoListCollectionHeaderView.self)
        headerView?.shufflingFigureView.fsPageControl.currentPage = targetIndex
    }
    
    func pagerViewDidEndScrollAnimation(_ pagerView: FSPagerView) {
        let headerView = videoListView.collectionView.cz_subView(seekSubView: VideoListCollectionHeaderView.self)
        headerView?.shufflingFigureView.fsPageControl.currentPage = pagerView.currentIndex
    }
}

// MARK: - JXSegmentedListContainerViewListDelegate
extension VideoListController: JXSegmentedListContainerViewListDelegate {
    func listView() -> UIView {
        return view
    }
}
