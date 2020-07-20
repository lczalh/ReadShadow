//
//  VideoDownloadManageListController.swift
//  Random
//
//  Created by yu mingming on 2019/12/6.
//  Copyright © 2019 刘超正. All rights reserved.
//

import UIKit

class VideoDownloadController: BaseController {
    
    lazy var videoDownloadView: VideoDownloadView = {
        let view = VideoDownloadView()
        view.tableView.delegate = self
        view.tableView.dataSource = self
        return view
    }()
    
    /// 所有视频下载地址
    var urlStrings: [String] {
        appDelegate.sessionManager.tasks.map({ $0.url.absoluteString })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        videoDownloadView.tableView.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        videoDownloadView.cz.addSuperView(view).makeConstraints { (make) in
            if #available(iOS 11.0, *) {
                make.edges.equalTo(view.safeAreaLayoutGuide)
            } else {
                make.edges.equalToSuperview()
            }
        }
    }

}

// MARK: - UITableViewDataSource
extension VideoDownloadController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.urlStrings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: VideoDownloadTableViewCell.identifier, for: indexPath) as! VideoDownloadTableViewCell
        cell.delegate = self
        return cell
    }
    
    // 每个cell中的状态更新，应该在willDisplay中执行
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let task = appDelegate.sessionManager.tasks.safeObject(at: indexPath.row),
        let cell = cell as? VideoDownloadTableViewCell else { return }
        cell.titleLabel.text = task.fileName.removingPercentEncoding
        cell.downloadProgressView.progress = Float((task.progress.fractionCompleted) )
        cell.downloadAndTotalSizeLabel.text = "\(task.progress.completedUnitCount.tr.convertBytesToString()) / \(task.progress.totalUnitCount.tr.convertBytesToString())"
        cell.downloadSpeedLabel.text = task.speed.tr.convertSpeedToString()
        cell.timeLabel.text = task.timeRemaining.tr.convertTimeToString()
        switch task.status {
            case .running:
                cell.playAndPauseButton.isSelected = true
                break
            case .waiting, .suspended, .failed:
                cell.playAndPauseButton.isSelected = false
                break
            default:
                cell.playAndPauseButton.isSelected = false
                break
        }
        task.progress {  (task) in
            cell.playAndPauseButton.isSelected = true
            cell.downloadProgressView.progress = Float(task.progress.fractionCompleted)
            cell.downloadAndTotalSizeLabel.text = "\(task.progress.completedUnitCount.tr.convertBytesToString()) / \(task.progress.totalUnitCount.tr.convertBytesToString())"
            cell.downloadSpeedLabel.text = task.speed.tr.convertSpeedToString()
            cell.timeLabel.text = task.timeRemaining.tr.convertTimeToString()
        }.success {  (task) in
            // 下载任务成功了
            appDelegate.sessionManager.remove(task.url, completely: false) { (task) in
                DispatchQueue.main.async { tableView.reloadData() }
            }
        }.failure { (task) in
            cell.playAndPauseButton.isSelected = false
            cell.downloadProgressView.progress = Float(task.progress.fractionCompleted)
            cell.downloadAndTotalSizeLabel.text = "\(task.progress.completedUnitCount.tr.convertBytesToString())/\(task.progress.totalUnitCount.tr.convertBytesToString())"
            cell.downloadSpeedLabel.text = task.speed.tr.convertSpeedToString()
            cell.timeLabel.text = task.timeRemaining.tr.convertTimeToString()
        }
        cell.playAndPauseButton.addTarget(self, action: #selector(playAndPauseButtonAction), for: .touchUpInside)
    }
    
    // 由于cell是循环利用的，不在可视范围内的cell，不应该去更新cell的状态
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let task = appDelegate.sessionManager.tasks.safeObject(at: indexPath.row) else { return }
        task.progress { _ in }.success { _ in } .failure { _ in }
    }
    
    /// 开始和暂停的响应事件
    /// - Parameter sender: sender description
    @objc func playAndPauseButtonAction(sender: UIButton) {
        let cell = sender.cz_superView(seekSuperView: VideoDownloadTableViewCell.self)
        let indexPath = videoDownloadView.tableView.indexPath(for: cell!)
        guard let task = appDelegate.sessionManager.tasks.safeObject(at: indexPath!.row) else { return }
        let maxConcurrentTasksLimit = appDelegate.sessionManager.configuration.maxConcurrentTasksLimit
        let runningTasks = appDelegate.sessionManager.tasks.filter{ $0.status == .running }
        switch task.status {
            case .running:
                appDelegate.sessionManager.suspend(task.url)
                cell?.playAndPauseButton.isSelected = false
                break
            case .waiting, .suspended, .failed:
                if runningTasks.count < maxConcurrentTasksLimit {
                    appDelegate.sessionManager.start(task.url)
                    cell?.playAndPauseButton.isSelected = true
                } else {
                    cell?.playAndPauseButton.isSelected = false
                    CZHUD.showError("不可超过系统最大下载并发数，请稍后再试")
                }
                break
            default:
                CZHUD.showError("当前状态不可操作，请稍后再试")
                break
        }
    }
}

// MARK: - UITableViewDelegate
extension VideoDownloadController: UITableViewDelegate {
    
}

// MARK: - SwipeTableViewCellDelegate
extension VideoDownloadController: SwipeTableViewCellDelegate {
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        if orientation == .left {
            // 创建“删除所有”事件按钮
            let deleteAction = SwipeAction(style: .destructive, title: "删除所有任务") { action, indexPath in
                UIAlertController.cz_showAlertController("提示", "确定删除所有进行中的任务？", .alert, self, "确定", { (action) in
                    appDelegate.sessionManager.totalCancel(onMainQueue: false) { (manage) in
                        DispatchQueue.main.async { tableView.reloadData() }
                    }
                }, "取消", nil)
            }
             
            //返回右侧事件按钮
            return [deleteAction]
        } else {
            // 创建“删除”事件按钮
            let deleteAction = SwipeAction(style: .destructive, title: "删除") { action, indexPath in
                UIAlertController.cz_showAlertController("提示", "确定删除此任务？", .alert, self, "确定", { (action) in
                    let urlString = self.urlStrings.safeObject(at: indexPath.row)
                    appDelegate.sessionManager.cancel(urlString!, onMainQueue: false) { (task) in
                        DispatchQueue.main.async { tableView.reloadData() }
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
extension VideoDownloadController: JXSegmentedListContainerViewListDelegate {
    func listView() -> UIView {
        return view
    }
}
