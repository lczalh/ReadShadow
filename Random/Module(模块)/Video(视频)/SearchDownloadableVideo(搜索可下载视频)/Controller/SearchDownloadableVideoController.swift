//
//  SearchDownloadableVideoController.swift
//  Random
//
//  Created by yu mingming on 2020/7/15.
//  Copyright © 2020 刘超正. All rights reserved.
//

import UIKit

class SearchDownloadableVideoController: BaseController {
    
    lazy var searchDownloadableVideoView: SearchDownloadableVideoView = {
        let view = SearchDownloadableVideoView()
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
    
    /// 搜索的视频名称
    var vodName: String = ""
    
    /// 可下载视频名称数组
    private var downloadableVideoTitles: Array<Array<String>> = []
    
    /// 可下载视频URL数组
    private var downloadableVideoUrls: Array<Array<String>> = []
    
    /// 可下载视频资源站名称数组
    private var downloadableVideoResourceNames: Array<String> = []
    
    /// 所有可下载资源
    var allReadShadowVideoModelAry: Array<ReadShadowVideoModel> = []
    
    override func setupNavigationItems() {
        super.setupNavigationItems()
        navigationController?.setNavigationBarHidden(false, animated: false)
        titleView?.title = vodName
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchDownloadableVideoView.cz.addSuperView(view).makeConstraints { (make) in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        // Do any additional setup after loading the view.
        getDownloadableVideoModels()
    }
    
    func getDownloadableVideoModels() {
        // 获取可下载的资源站
        let downloadReadShadowVideoResourceModels = readShadowVideoResourceModels.filter{ $0.downloadPath != nil && $0.downloadPath?.isEmpty == false }
        guard downloadReadShadowVideoResourceModels.count > 0 else {
            CZHUD.showError("暂无下载资源站")
            return
        }
        let semaphore = DispatchSemaphore(value: 0)
        DispatchQueue.global().async {
            for downloadReadShadowVideoResourceModel in downloadReadShadowVideoResourceModels{
                DispatchQueue.main.async { CZHUD.show("\(downloadReadShadowVideoResourceModel.name ?? "")搜索中") }
                CZNetwork.cz_request(target: VideoDataApi.getVideoDownData(baseUrl: downloadReadShadowVideoResourceModel.baseUrl ?? "", downloadPath: downloadReadShadowVideoResourceModel.downloadPath ?? "", wd: self.vodName, p: nil, cid: nil),
                                     model: ReadShadowVideoRootModel.self) {[weak self] (result) in
                    switch result {
                    case .success(let downModel):
                        if let videoModels = downModel.data, videoModels.count > 0 {
                            for videoModel in videoModels {
                                guard filterVideoCategorys.filter({ videoModel.category == $0 }).first == nil else { continue }
                                // 默认播放首集
                                videoModel.currentPlayIndex = 0
                                videoModel.readShadowVideoResourceModel = downloadReadShadowVideoResourceModel
                                self?.allReadShadowVideoModelAry.append(videoModel)
                            }
                            
                        }
                        DispatchQueue.main.async {
                            CZHUD.dismiss()
                            self?.searchDownloadableVideoView.tableView.reloadData()
                            semaphore.signal()
                        }
                        break
                    case .failure(let error):
                        DispatchQueue.main.async {
                            CZHUD.showError(error.localizedDescription)
                            semaphore.signal()
                        }
                        break
                    }
                }
                semaphore.wait()
            }
        }
        
    }
    

}

extension SearchDownloadableVideoController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return allReadShadowVideoModelAry.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allReadShadowVideoModelAry[section].allPlayerSourceSeriesNames?.first?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let readShadowVideoModel = allReadShadowVideoModelAry[indexPath.section]
        let cell = tableView.dequeueReusableCell(withIdentifier: VideoSearchTableViewCell.identifier) as! VideoSearchTableViewCell
        cell.videoNameLabel.text = "\(readShadowVideoModel.name ?? "")\(readShadowVideoModel.allPlayerSourceSeriesNames?.first?[indexPath.row] ?? "")"
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let readShadowVideoModel = allReadShadowVideoModelAry[section]
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: BookReadHeaderView.identifier) as! BookReadHeaderView
        headerView.bookSourceNameLabel.text = readShadowVideoModel.readShadowVideoResourceModel?.name
        return headerView
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CZCommon.cz_dynamicFitHeight(30)
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let readShadowVideoModel = allReadShadowVideoModelAry[indexPath.section]
        let seriesName = readShadowVideoModel.allPlayerSourceSeriesNames?.first?[indexPath.row] ?? ""
        let seriesUrl = readShadowVideoModel.allPlayerSourceSeriesUrls?.first?[indexPath.row] ?? ""
        // 中文转码
        let videoName = "\(readShadowVideoModel.name ?? "")\(seriesName)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        // 下载
        DispatchQueue.main.async {
            appDelegate.sessionManager.download(seriesUrl, fileName: "\(readShadowVideoModel.readShadowVideoResourceModel?.name ?? "")-\(videoName ?? "").\(seriesUrl.pathExtension)")
            CZHUD.showSuccess("下载任务添加成功")
        }
    }
}
