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
    private var downloadableVideoUrls: Array<Array<URL>> = []
    
    /// 可下载视频资源站名称数组
    private var downloadableVideoResourceNames: Array<String> = []
    
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
        CZHUD.show("搜索中")
        // 获取可下载的资源站
        let downloadReadShadowVideoResourceModels = readShadowVideoResourceModels.filter{ $0.downloadPath != nil && $0.downloadPath?.isEmpty == false }
        guard downloadReadShadowVideoResourceModels.count > 0 else {
            CZHUD.showError("暂无下载资源站")
            return
        }
        for downloadReadShadowVideoResourceModel in downloadReadShadowVideoResourceModels{
            CZNetwork.cz_request(target: VideoDataApi.getVideoDownData(baseUrl: downloadReadShadowVideoResourceModel.baseUrl ?? "", downloadPath: downloadReadShadowVideoResourceModel.downloadPath ?? "", wd: vodName, p: nil, cid: nil),
                                 model: ReadShadowVideoRootModel.self) {[weak self] (result) in
                switch result {

                case .success(let downModel):
                    if let videoModels = downModel.data, videoModels.count > 0 {
                        var videoTitles: Array<String> = []
                        var videoUrls: Array<URL> = []
                        if downModel.data!.count > 0, let video = downModel.data?.first { // 下载地址解析
                            if video.url?.count ?? 0 > 0 {
                                let videos = video.url?.components(separatedBy: CharacterSet(charactersIn: "\r\n"))
                                let titleAndUrls = videos?.filter{ $0.count > 0 }
                                for titleAndUrl in titleAndUrls ?? [] {
                                    let titleAndUrlAry = titleAndUrl.components(separatedBy: CharacterSet(charactersIn: "$"))
                                    guard titleAndUrlAry.count == 2 else { break }
                                    // 播放地址有效才添加
                                    if let url = URL(string: titleAndUrlAry[1].addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!) {
                                        videoTitles.append(titleAndUrlAry[0])
                                        videoUrls.append(url)
                                    }
                                }
                            }
                        }
                        guard videoTitles.count > 0, videoUrls.count > 0 else {
                            return
                        }
                        self?.downloadableVideoTitles.append(videoTitles)
                        self?.downloadableVideoUrls.append(videoUrls)
                        self?.downloadableVideoResourceNames.append(downloadReadShadowVideoResourceModel.name ?? "")
                        DispatchQueue.main.async {
                            CZHUD.dismiss()
                            self?.searchDownloadableVideoView.tableView.reloadData()
                        }
                    } else {
                        DispatchQueue.main.async { CZHUD.dismiss() }
                    }
                    break
                case .failure(let error):
                    CZHUD.showError(error.localizedDescription)
                    break
                }
            }
        }
    }
    

}

extension SearchDownloadableVideoController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return downloadableVideoTitles.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return downloadableVideoTitles[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let title = downloadableVideoTitles[indexPath.section][indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: VideoSearchTableViewCell.identifier) as! VideoSearchTableViewCell
        cell.videoNameLabel.text = title
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: BookReadHeaderView.identifier) as! BookReadHeaderView
        headerView.bookSourceNameLabel.text = downloadableVideoResourceNames[section]
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
        let title = downloadableVideoTitles[indexPath.section][indexPath.row]
        let url = downloadableVideoUrls[indexPath.section][indexPath.row]
        // 中文转码
        let videoName = "\(vodName)\(title)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        // 下载
        DispatchQueue.main.async {
            appDelegate.sessionManager.download(url, fileName: "\(videoName ?? "").\(url.pathExtension)")
            CZHUD.showSuccess("下载任务添加成功")
        }
    }
}
