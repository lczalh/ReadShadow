//
//  VideoSearchController.swift
//  Random
//
//  Created by yu mingming on 2020/6/3.
//  Copyright © 2020 刘超正. All rights reserved.
//

import UIKit

class VideoSearchController: BaseController {
    
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
    
    var videoModels: Array<Array<ReadShadowVideoModel>> = []
    
    /// 搜索内容
    var searchName: String?
    
    private let videoSearchQueue = DispatchQueue.init(label: "videoSearch")
    
    private let videoSearchGroup = DispatchGroup()
    
    private var sectionTitles: Array<String> = []
    
    lazy var videoSearchView: VideoSearchView = {
        let view = VideoSearchView()
        view.tableView.delegate = self
        view.tableView.dataSource = self
        return view
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
      //  DispatchQueue.main.async { self.navigationController?.setNavigationBarHidden(true, animated: false) }
    }
    
    override func setupNavigationItems() {
        super.setupNavigationItems()
        navigationController?.setNavigationBarHidden(true, animated: false)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        videoSearchView.cz.addSuperView(view).makeConstraints { (make) in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        // 取消事件
        videoSearchView.cancelButton.rx.tap.subscribe(onNext: {[weak self] () in
            DispatchQueue.main.async {
                self?.videoSearchView.searchTextField.text = nil
                self?.navigationController?.popViewController(animated: true, nil)
            }
        }).disposed(by: rx.disposeBag)
        
        videoSearchView.searchTextField.rx
            //.text.orEmpty.asObservable()
            .controlEvent([.editingDidEnd,.editingDidEndOnExit]) //状态可以组合
            .subscribe(onNext: {[weak self] in
            guard self?.videoSearchView.searchTextField.markedTextRange == nil else { return }
            guard self?.videoSearchView.searchTextField.text?.isEmpty == false && self?.videoSearchView.searchTextField.text != nil else { return }
            /// 搜索值相同则不重复请求
            guard self?.searchName != self?.videoSearchView.searchTextField.text else { return }
            self?.searchName = self?.videoSearchView.searchTextField.text
            if self?.searchName?.isEmpty == true {
                self?.videoModels.removeAll()
                self?.sectionTitles.removeAll()
                self?.videoSearchView.tableView.reloadData()
            } else {
                self?.searchVideoData()
            }
        }).disposed(by: rx.disposeBag)
    }
    

    @objc func searchVideoData() {
        CZHUD.show("视频搜索中")
        for videoSourceModel in readShadowVideoResourceModels {
            autoreleasepool{
                videoSearchQueue.async(group: videoSearchGroup, execute: {
                    if videoSourceModel.type == "0" {
                        CZNetwork.cz_request(target: VideoDataApi.getVideoData(baseUrl: videoSourceModel.baseUrl!, path: videoSourceModel.path!, wd: self.searchName, p: nil, cid: nil),
                                             model: VideoRootModel.self) {[weak self] (result) in
                            switch result {
                                case .success(let model):
                                    if let videoModels = model.data, videoModels.count > 0 {
                                        var videos: [ReadShadowVideoModel] = []
                                        for videoModel in videoModels {
                                            guard filterVideoCategorys.filter({ videoModel.listName == $0 }).first == nil else {
                                                continue
                                            }
                                            let readShadowVideoModel = ReadShadowVideoModel()
                                            readShadowVideoModel.name = videoModel.vodName
                                            readShadowVideoModel.actor = videoModel.vodActor
                                            readShadowVideoModel.area = videoModel.vodArea
                                            readShadowVideoModel.year = videoModel.vodYear
                                            readShadowVideoModel.introduction = videoModel.vodContent
                                            readShadowVideoModel.director = videoModel.vodDirector
                                            readShadowVideoModel.url = videoModel.vodUrl
                                            // 解析所有剧集名称和地址
                                            let m = VideoParsing.parsingResourceSiteM3U8Dddress(url: videoModel.vodUrl ?? "")
                                            readShadowVideoModel.seriesNames = m.0
                                            readShadowVideoModel.seriesUrls = m.1
                                            readShadowVideoModel.language = videoModel.vodLanguage
                                            readShadowVideoModel.type = videoModel.vodType
                                            readShadowVideoModel.category = videoModel.listName
                                            readShadowVideoModel.pic = videoModel.vodPic
                                            readShadowVideoModel.playerSource = videoModel.vodPlay
                                            readShadowVideoModel.continu = videoModel.vodContinu
                                            videos.append(readShadowVideoModel)
                                        }
                                        // 过滤空数组
                                        guard videos.count > 0 else {
                                            return
                                        }
                                        DispatchQueue.main.async {
                                            CZHUD.dismiss()
                                            self?.videoModels.append(videos)
                                            self?.sectionTitles.append(videoSourceModel.name!)
                                            self?.videoSearchView.tableView.reloadData()
                                        }
                                    } else {
                                        DispatchQueue.main.async { CZHUD.dismiss() }
                                    }
                                    break
                                case .failure(let error):
                                    DispatchQueue.main.async { CZHUD.dismiss() }
                                    cz_print(error.localizedDescription)
                                    break
                            }
                        }
                    } else { // 直链数据
                        CZNetwork.cz_request(target: VideoDataApi.getAppleCmsVideoListData(baseUrl: videoSourceModel.baseUrl!, path: videoSourceModel.path!, ac: "detail", ids: nil, t: nil, pg: nil, wd: self.searchName, h: nil), model: AppleCmsDetailsRootModel.self) {[weak self] (result) in
                            switch result {
                                
                            case .success(let model):
                                if let videoModels = model.list, videoModels.count > 0 {
                                    var videos: [ReadShadowVideoModel] = []
                                    for videoModel in videoModels {
                                        guard filterVideoCategorys.filter({ videoModel.category == $0 }).first == nil else {
                                            continue
                                        }
//                                        let readShadowVideoModel = ReadShadowVideoModel()
//                                        readShadowVideoModel.name = videoModel.vodName
//                                        readShadowVideoModel.actor = videoModel.vodActor
//                                        readShadowVideoModel.area = videoModel.vodArea
//                                        readShadowVideoModel.year = videoModel.vodYear
//                                        readShadowVideoModel.introduction = videoModel.vodContent
//                                        readShadowVideoModel.director = videoModel.vodDirector
//                                        readShadowVideoModel.url = videoModel.vodPlayUrl
//                                        // 解析所有剧集名称和地址
//                                        let m = VideoParsing.parsingResourceSitelLnearChainDddress(playerSource: videoModel.vodPlayFrom ?? "", url: videoModel.vodPlayUrl ?? "")
//                                        let seriesNames = m.0.first?.value.map{ $0.first?.key ?? "" } ?? []
//                                        let seriesUrls = m.0.first?.value.map{ $0.first?.value ?? "" } ?? []
//                                        readShadowVideoModel.seriesNames = seriesNames
//                                        readShadowVideoModel.seriesUrls = seriesUrls
//                                        readShadowVideoModel.playerSource = m.1.first
//                                       // readShadowVideoModel.language = videoModel.vodla
//                                        readShadowVideoModel.continu = videoModel.vodRemarks
//                                        readShadowVideoModel.playerSource = videoModel.vodPlayFrom
//                                        readShadowVideoModel.type = videoModel.vodClass
//                                        readShadowVideoModel.category = videoModel.typeName
//                                        readShadowVideoModel.pic = videoModel.vodPic
                                        videos.append(videoModel)
                                    }
                                    // 过滤空数组
                                    guard videos.count > 0 else {
                                        return
                                    }
                                    DispatchQueue.main.async {
                                        CZHUD.dismiss()
                                        self?.videoModels.append(videos)
                                        self?.sectionTitles.append(videoSourceModel.name!)
                                        self?.videoSearchView.tableView.reloadData()
                                    }
                                } else {
                                    DispatchQueue.main.async { CZHUD.dismiss() }
                                }
                                break
                            case .failure(let error):
                                DispatchQueue.main.async {
                                    CZHUD.dismiss()
                                }
                                cz_print(error.localizedDescription)
                                break
                            }
                        }
                    }
                })
            }
        }
    }

}

extension VideoSearchController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitles.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return videoModels[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = videoModels[indexPath.section][indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: VideoSearchTableViewCell.identifier) as! VideoSearchTableViewCell
        cell.videoNameLabel.text = model.name
        cell.rightLabel.text = model.continu
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: BookReadHeaderView.identifier) as! BookReadHeaderView
        headerView.bookSourceNameLabel.text = sectionTitles[section]
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
    
}

extension VideoSearchController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = videoModels[indexPath.section][indexPath.row]
        let videoDetailsController = VideoDetailsController()
        videoDetailsController.model = model
        DispatchQueue.main.async { self.navigationController?.pushViewController(videoDetailsController, animated: true) }
    }
}
