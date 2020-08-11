//
//  HaveDownloadedController.swift
//  Random
//
//  Created by yu mingming on 2019/12/10.
//  Copyright © 2019 刘超正. All rights reserved.
//

import UIKit

class HaveDownloadedController: BaseController {
    
    lazy var haveDownloadedView: HaveDownloadedView = {
        let view = HaveDownloadedView()
        view.tableView.delegate = self
        view.tableView.dataSource = self
        return view
    }()
    
    let fileManager = FileManager.default
    
    /// 所有已下载的文件
    var files: Array<String> {
        do {
            return try fileManager.contentsOfDirectory(atPath: downloadFilePath).sorted(by: { $0 < $1 })
        } catch {
            return []
        }
    }
    
    /// 已下载文件夹的路径
    var downloadFilePath = appDelegate.sessionManager.cache.downloadFilePath
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        haveDownloadedView.tableView.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        haveDownloadedView.cz.addSuperView(view).makeConstraints { (make) in
            if #available(iOS 11.0, *) {
                make.edges.equalTo(view.safeAreaLayoutGuide)
            } else {
                make.edges.equalToSuperview()
            }
        }
    }
    

}

// MARK: - UITableViewDataSource
extension HaveDownloadedController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return files.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: HaveDownloadedTableViewCell.identifier, for: indexPath) as! HaveDownloadedTableViewCell
        let file = files[indexPath.row]
        cell.titleLabel.text = file.removingPercentEncoding
        cell.delegate = self
        return cell
    }
    
    
}

// MARK: - UITableViewDelegate
extension HaveDownloadedController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let file = files[indexPath.row]
        let path = downloadFilePath + "/" + file
        let fullscreenPlayController = FullscreenPlayController()
        fullscreenPlayController.videoURL = path
       // fullscreenPlayController.videoName = file.removingPercentEncoding
        self.navigationController?.pushViewController(fullscreenPlayController, animated: false)
    }
}

// MARK: - SwipeTableViewCellDelegate
extension HaveDownloadedController: SwipeTableViewCellDelegate {
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        if orientation == .left {
            // 创建“删除所有”事件按钮
            let deleteAction = SwipeAction(style: .destructive, title: "删除所有视频") { action, indexPath in
                UIAlertController.cz_showAlertController("提示", "确定删除所有视频？", .alert, self, "确定", { (action) in
                    CZHUD.show("删除中")
                    DispatchQueue.global().async {
                        do {
                            // 删除存储下载文件的文件夹
                            try self.fileManager.removeItem(atPath: self.downloadFilePath)
                            // 重新创建一个文件夹
                            try self.fileManager.createDirectory(atPath: self.downloadFilePath, withIntermediateDirectories: true,
                            attributes: nil)
                            DispatchQueue.main.async {
                                CZHUD.showSuccess("删除成功")
                                tableView.reloadData()
                            }
                        } catch {
                            DispatchQueue.main.async {
                                CZHUD.showError("删除失败")
                            }
                        }
                    }
                }, "取消", nil)
            }
             
            //返回右侧事件按钮
            return [deleteAction]
        } else {
            let file = files[indexPath.row]
            let path = downloadFilePath + "/" + file
            // 创建“删除”事件按钮
            let deleteAction = SwipeAction(style: .destructive, title: "删除") { action, indexPath in
                UIAlertController.cz_showAlertController("提示", "确定删除此视频？", .alert, self, "确定", { (action) in
                    CZHUD.show("删除中")
                    DispatchQueue.global().async {
                        do {
                            try self.fileManager.removeItem(atPath: path)
                            DispatchQueue.main.async {
                                CZHUD.showSuccess("删除成功")
                                tableView.reloadData()
                            }
                        } catch {
                            DispatchQueue.main.async {
                                CZHUD.showError("删除失败")
                            }
                        }
                    }
                }, "取消", nil)
            }
             
            //返回右侧事件按钮
            return [deleteAction]
        }
    }
    
    //自定义滑动过渡行为（可选）
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeTableOptions {
        var options = SwipeTableOptions()
        options.transitionStyle = .reveal
        return options
    }
}

// MARK: - JXSegmentedListContainerViewListDelegate
extension HaveDownloadedController: JXSegmentedListContainerViewListDelegate {
    func listView() -> UIView {
        return view
    }
}
