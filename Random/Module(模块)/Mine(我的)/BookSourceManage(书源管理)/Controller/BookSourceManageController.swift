//
//  BookSourceManageController.swift
//  Random
//
//  Created by yu mingming on 2020/6/12.
//  Copyright © 2020 刘超正. All rights reserved.
//

import UIKit

class BookSourceManageController: BaseController {
    
    lazy var bookSourceManageView: BookSourceManageView = {
        let view = BookSourceManageView()
        view.tableView.dataSource = self
        view.tableView.delegate = self
        return view
    }()
    
    /// 书源模型
    var readShadowBookRuleResourceModels: Array<ReadShadowBookRuleResourceModel> {
        do {
            var models: Array<ReadShadowBookRuleResourceModel> = []
            let files = try FileManager().contentsOfDirectory(atPath: bookSourceRuleFolderPath).filter{ $0.pathExtension == "plist" }
            for file in files {
                let model = CZObjectStore.standard.cz_unarchiver(filePath: "\(bookSourceRuleFolderPath)/\(file)") as? ReadShadowBookRuleResourceModel
                models.append(model!)
            }
            return models
        } catch  {
            return []
        }
    }
    
//    /// 所有书源模型数组
//    lazy var readShadowBookRuleResourceModels: Array<ReadShadowBookRuleResourceModel> = {
//        return getApplicationConfigModel()?.bookRuleResources ?? []
//    }()
//
    override func setupNavigationItems() {
        titleView?.title = "我的书源"
//        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "添加", style: .done, target: nil, action: nil)
//        navigationItem.rightBarButtonItem?.rx.tap.subscribe(onNext: {[weak self] () in
//            DispatchQueue.main.async {
//                let addBookSourceController = AddBookSourceController()
//                addBookSourceController.type = "0"
//                addBookSourceController.superiorPageUpdateBlock = {[weak self] in
//                    DispatchQueue.main.async {
//                        self?.bookSourceManageView.tableView.reloadData()
//                    }
//                }
//                self?.navigationController?.pushViewController(addBookSourceController, animated: true)
//            }
//        }).disposed(by: rx.disposeBag)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        bookSourceManageView.cz.addSuperView(view).makeConstraints { (make) in
            if #available(iOS 11.0, *) {
                make.edges.equalTo(view.safeAreaLayoutGuide)
            } else {
                make.edges.equalToSuperview().inset(UIEdgeInsets(top: CZCommon.cz_navigationHeight + CZCommon.cz_statusBarHeight, left: 0, bottom: 0, right: 0))
            }
        }
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension BookSourceManageController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return readShadowBookRuleResourceModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: VideoResourceTableViewCell.identifier, for: indexPath) as! VideoResourceTableViewCell
       // cell.delegate = self
        let model = readShadowBookRuleResourceModels[indexPath.row]
        cell.titleLabel.text = model.bookSourceName
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let model = readShadowBookRuleResourceModels[indexPath.row]
//        DispatchQueue.main.async {
//            let bookSourceDetailController = BookSourceDetailController()
//            bookSourceDetailController.bookReadParsingRuleModel = model
//            self.navigationController?.pushViewController(bookSourceDetailController, animated: true)
//        }
    }
}

// MARK: - SwipeTableViewCellDelegate
//extension BookSourceManageController: SwipeTableViewCellDelegate {
//    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
//        if orientation == .left {
//            return nil
//        } else {
//            // 创建“删除”事件按钮
//            let deleteAction = SwipeAction(style: .destructive, title: "删除") { action, indexPath in
//                UIAlertController.cz_showAlertController("提示", "确定删除此书源？", .alert, self, "确定", { (action) in
//                    let model = self.bookReadParsingRuleModels[indexPath.row]
//                    do {
//                        // 删除书源
//                        try FileManager().removeItem(atPath: bookSourceRuleFolderPath + "/\(model.bookSourceName ?? "").plist")
//                        DispatchQueue.main.async {
//                            tableView.reloadData()
//                            CZHUD.showSuccess("已移除")
//                        }
//                    } catch  {
//                        DispatchQueue.main.async {
//                            CZHUD.showError("移除失败")
//                        }
//
//                    }
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


