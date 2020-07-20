//
//  BrowsingHistoryController.swift
//  Random
//
//  Created by yu mingming on 2020/7/2.
//  Copyright © 2020 刘超正. All rights reserved.
//

import UIKit

class BrowsingHistoryController: BaseController {
    
    lazy var browsingHistoryView: BrowsingHistoryView = {
        let view = BrowsingHistoryView()
        view.tableView.dataSource = self
        view.tableView.delegate = self
        return view
    }()
    
    /// 观影记录模型 并排序
    private var videoRecordModels: Array<ReadShadowVideoModel> {
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
    
    /// 书浏览记录模型 并排序
    private var bookReadRecordModels: Array<BookReadModel> {
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
    
    /// 记录类型 0: 观影记录 1:阅读记录
    var type: String?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        browsingHistoryView.tableView.reloadData()
    }

    override func setupNavigationItems() {
        if type == "0" {
            titleView?.title = "观影记录"
        } else {
            titleView?.title = "阅读记录"
        }
        navigationController?.setNavigationBarHidden(false, animated: false)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        browsingHistoryView.cz.addSuperView(view).makeConstraints { (make) in
            if #available(iOS 11.0, *) {
                make.edges.equalTo(view.safeAreaLayoutGuide)
            } else {
                make.edges.equalToSuperview().inset(UIEdgeInsets(top: CZCommon.cz_navigationHeight + CZCommon.cz_statusBarHeight, left: 0, bottom: 0, right: 0))
            }
        }
    }
    

}

extension BrowsingHistoryController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if type == "0" {
            return videoRecordModels.count
        } else {
            return bookReadRecordModels.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: BrowsingHistoryTableViewCell.identifier, for: indexPath) as! BrowsingHistoryTableViewCell
        if type == "0" {
            let videoRecordModel = videoRecordModels[indexPath.row]
            cell.leftImageView.kf.setImage(with: URL(string: videoRecordModel.pic), placeholder: UIImage(named: "Icon_Placeholder"))
            cell.nameLabel.text = videoRecordModel.name
            cell.detailsLabel.text = "播放至：第\((videoRecordModel.currentPlayIndex ?? 0) + 1)集"
        } else {
            let bookReadRecordModel = bookReadRecordModels[indexPath.row]
            cell.leftImageView.kf.setImage(with: URL(string: bookReadRecordModel.bookImageUrl), placeholder: UIImage(named: "Icon_Book_Placeholder"))
            cell.nameLabel.text = bookReadRecordModel.bookName
            cell.detailsLabel.text = "阅读至：\(bookReadRecordModel.bookReadChapter?[bookReadRecordModel.bookLastReadChapterIndex ?? 0].chapterName ?? "")"
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if type == "0" {
            let videoRecordModel = videoRecordModels[indexPath.row]
            DispatchQueue.main.async {
                let videoDetailsController = VideoDetailsController()
                videoDetailsController.hidesBottomBarWhenPushed = true
                videoDetailsController.model = videoRecordModel
                self.navigationController?.pushViewController(videoDetailsController, animated: true)
            }
        } else {
            let bookReadRecordModel = bookReadRecordModels[indexPath.row]
            DispatchQueue.main.async {
                let bookReadDetailsController = BookReadDetailsController()
                bookReadDetailsController.bookReadModel = bookReadRecordModel
                bookReadDetailsController.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(bookReadDetailsController, animated: true)
            }
        }
    }
}
