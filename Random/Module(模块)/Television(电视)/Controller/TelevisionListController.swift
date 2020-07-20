//
//  TelevisionListController.swift
//  Random
//
//  Created by yu mingming on 2020/7/8.
//  Copyright © 2020 刘超正. All rights reserved.
//

import UIKit

class TelevisionListController: BaseController {

    lazy var televisionListView: TelevisionListView = {
        let view = TelevisionListView()
        view.tableView.dataSource = self
        view.tableView.delegate = self
        return view
    }()
        
    /// 电视模型
    var televisionRootModels: [TelevisionRootModel] = []
    
    override func setupNavigationItems() {
        super.setupNavigationItems()
        titleView?.title = "电视"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        televisionListView.cz.addSuperView(view).makeConstraints { (make) in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }

}

extension TelevisionListController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return televisionRootModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TelevisionTableViewCell.identifier, for: indexPath) as! TelevisionTableViewCell
        let televisionRootModel = televisionRootModels[indexPath.row]
        cell.logoImageView?.kf.indicatorType = .activity
        cell.logoImageView?.kf.setImage(with: URL(string: televisionRootModel.logo), placeholder: UIImage(named: "Icon_Placeholder"))
        cell.televisionNameLabel.text = televisionRootModel.name
        cell.countryLabel.text = televisionRootModel.country?.name
        return cell
    }

}

extension TelevisionListController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let televisionRootModel = televisionRootModels[indexPath.row]
        let fullscreenPlayController = FullscreenPlayController()
        fullscreenPlayController.videoURL = televisionRootModel.url ?? ""
        fullscreenPlayController.videoName = televisionRootModel.name
        fullscreenPlayController.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(fullscreenPlayController, animated: true)
    }
}


// MARK: - JXSegmentedListContainerViewListDelegate
extension TelevisionListController: JXSegmentedListContainerViewListDelegate {
    func listView() -> UIView {
        return view
    }
}
