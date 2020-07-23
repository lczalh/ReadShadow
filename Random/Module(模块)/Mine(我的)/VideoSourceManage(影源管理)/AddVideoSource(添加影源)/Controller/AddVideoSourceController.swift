//
//  AddVideoSourceController.swift
//  Random
//
//  Created by yu mingming on 2020/7/23.
//  Copyright © 2020 刘超正. All rights reserved.
//

import UIKit

class AddVideoSourceController: BaseController {
    
    lazy var addVideoSourceView: AddVideoSourceView = {
        let view = AddVideoSourceView()
        view.tableView.dataSource = self
        view.tableView.delegate = self
        return view
    }()
    
    private var cellTitles: Array<String> = ["影源名称","影源地址"]

    override func viewDidLoad() {
        super.viewDidLoad()
        addVideoSourceView.cz.addSuperView(view).makeConstraints { (make) in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        // Do any additional setup after loading the view.
    }

}

extension AddVideoSourceController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellTitles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellTitle = cellTitles[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: LeftTitleRightTextFieldTableViewCell.identifier, for: indexPath) as! LeftTitleRightTextFieldTableViewCell
        if cellTitle == "影源名称" {
            cell.titleLabel.text = cellTitle
            cell.textField.placeholder = "请输入影源名称"
            cell.returnInputText = {[weak self] text in
               // self?.bookReadParsingRuleModel.bookSourceName = text
            }
            return cell
        } else if cellTitle == "影源地址" {
            cell.titleLabel.text = cellTitle
            cell.textField.placeholder = "请输入影源地址"
            cell.returnInputText = {[weak self] text in
               // self?.bookReadParsingRuleModel.bookSourceName = text
            }
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    
}
