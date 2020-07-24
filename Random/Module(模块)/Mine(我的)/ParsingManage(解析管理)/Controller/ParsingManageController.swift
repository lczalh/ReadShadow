//
//  ParsingManageController.swift
//  Random
//
//  Created by yu mingming on 2020/7/24.
//  Copyright © 2020 刘超正. All rights reserved.
//

import UIKit

class ParsingManageController: BaseController {
    
    lazy var parsingManageView: ParsingManageView = {
        let view = ParsingManageView()
        view.tableView.dataSource = self
        view.tableView.delegate = self
        return view
    }()
    
    /// 所有解析接口
    var parsingInterfaceModels: Array<ParsingInterfaceModel> {
        do {
            var models: Array<ParsingInterfaceModel> = []
            let files = try FileManager().contentsOfDirectory(atPath: parsingInterfaceFolderPath).filter{ $0.pathExtension == "plist" }
            for file in files {
                let model = CZObjectStore.standard.cz_unarchiver(filePath: "\(parsingInterfaceFolderPath)/\(file)") as? ParsingInterfaceModel
                models.append(model!)
            }
            return models
        } catch  {
            return []
        }
    }
    
    override func setupNavigationItems() {
        titleView?.title = "影源解析"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "添加", style: .done, target: nil, action: nil)
        navigationItem.rightBarButtonItem?.rx.tap.subscribe(onNext: {[weak self] () in
            DispatchQueue.main.async {
                let dialogTextFieldViewController = QMUIDialogTextFieldViewController()
                dialogTextFieldViewController.titleView?.title = "添加影源"
                dialogTextFieldViewController.addTextField(withTitle: "解析名称") { (label, textField, layer) in

                }
                dialogTextFieldViewController.addTextField(withTitle: "解析接口") { (label, textField, layer) in

                }
                dialogTextFieldViewController.addCancelButton(withText: "取消") { _ in }
                dialogTextFieldViewController.addSubmitButton(withText: "添加") { (viewController) in
                    dialogTextFieldViewController.hideWith(animated: true) { _ in
                        let name = dialogTextFieldViewController.textFields?[0].text ?? ""
                        let address = dialogTextFieldViewController.textFields?[1].text ?? ""
                        let parsingInterfaceModel = ParsingInterfaceModel()
                        parsingInterfaceModel.parsingName = name
                        parsingInterfaceModel.parsingInterface = address.cz_encoded()
                        let _ = CZObjectStore.standard.cz_archiver(object: parsingInterfaceModel, filePath: parsingInterfaceFolderPath + "/" + (parsingInterfaceModel.parsingName ?? "") + ".plist")
                        DispatchQueue.main.async {
                            CZHUD.showSuccess("添加成功")
                            self?.parsingManageView.tableView.reloadData()
                        }
                    }
                }
                dialogTextFieldViewController.show()
            }
        }).disposed(by: rx.disposeBag)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        parsingManageView.cz.addSuperView(view).makeConstraints { (make) in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        // Do any additional setup after loading the view.
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

extension ParsingManageController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return parsingInterfaceModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: VideoResourceTableViewCell.identifier, for: indexPath) as! VideoResourceTableViewCell
        let model = parsingInterfaceModels[indexPath.row]
        cell.titleLabel.text = model.parsingName
        cell.delegate = self
        return cell
    }
}

// MARK: - SwipeTableViewCellDelegate
extension ParsingManageController: SwipeTableViewCellDelegate {
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        if orientation == .left {
            return nil
        } else {
            // 创建“删除”事件按钮
            let parsingInterfaceModel = parsingInterfaceModels[indexPath.row]
            let deleteAction = SwipeAction(style: .destructive, title: "删除") { action, indexPath in
                UIAlertController.cz_showAlertController("提示", "确定删除\(parsingInterfaceModel.parsingName ?? "")？", .alert, self, "确定", { (action) in
                    do {
                        try FileManager().removeItem(atPath: parsingInterfaceFolderPath + "/" + (parsingInterfaceModel.parsingName ?? "") + ".plist")
                        DispatchQueue.main.async {
                            CZHUD.showSuccess("删除成功")
                            tableView.reloadData()
                        }
                    } catch  {
                        DispatchQueue.main.async {
                            CZHUD.showError("删除失败")
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
