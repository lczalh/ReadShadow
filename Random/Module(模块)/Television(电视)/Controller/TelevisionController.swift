//
//  TelevisionController.swift
//  Random
//
//  Created by yu mingming on 2020/3/6.
//  Copyright © 2020 刘超正. All rights reserved.
//

import UIKit

class TelevisionController: BaseController {
    
    lazy var televisionView: TelevisionView = {
        let view = TelevisionView()
        return view
    }()
    
    lazy var listContainerView: JXSegmentedListContainerView = {
        let view = JXSegmentedListContainerView(dataSource: self)
        televisionView.segmentedView.listContainer = view
        return view
    }()
    
    /// 电视模型
    var televisionRootModels: [TelevisionRootModel] = []
    
    /// 存储搜索到的数据模型
    var searchTelevisionRootModels: [TelevisionRootModel] = []
    
    /// 电视国家编号数组
    var televisionCountryCodes: [String] = []
    
    override func setupNavigationItems() {
        super.setupNavigationItems()
        titleView?.title = "电视"
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        televisionView.cz.addSuperView(view).makeConstraints { (make) in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        listContainerView.cz.addSuperView(televisionView).makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(televisionView.segmentedView.snp.bottom)
        }
        
        televisionView.tapSearchLabelBlock = {[weak self] recognizer in
            DispatchQueue.main.async {
                let televisionSearchController = TelevisionSearchController()
                televisionSearchController.hidesBottomBarWhenPushed = true
                televisionSearchController.televisionRootModels = self?.televisionRootModels ?? []
                self?.navigationController?.pushViewController(televisionSearchController, animated: true)
            }
//            DispatchQueue.main.async {
//                let czSearchController = CZSearchController()
//                czSearchController.placeholder = "请输入频道名称"
//                czSearchController.searchTextFieldTextDidChangeBlock = {[weak self] tableView, textField in
//                    guard textField.markedTextRange == nil else { return }
//                    self?.searchTelevisionRootModels = self?.televisionRootModels.filter{ $0.name?.contains(textField.text!) == true } ?? []
//                    tableView.reloadData()
//                }
//                czSearchController.searchResultTableViewNumberOfRowsInSectionBlcok = {[weak self] tableView, section -> Int in
//                    return (self?.searchTelevisionRootModels.count ?? 0)
//                }
//                czSearchController.searchResultTableViewCellForRowBlcok = {[weak self] tableView, indexPath -> UITableViewCell in
//                    let cell = tableView.dequeueReusableCell(withIdentifier: TelevisionSearchTableViewCell.identifier, for: indexPath) as! TelevisionSearchTableViewCell
//                    let searchTelevisionModel = self?.searchTelevisionRootModels[indexPath.row]
//                    cell.nameLabel.text = searchTelevisionModel?.name
//                    return cell
//                }
//                czSearchController.searchResultTableViewDidSelectRowAtBlcok = {[weak self] tableView, indexPath in
//                    let televisionModel = self?.searchTelevisionRootModels[indexPath.row]
//                    DispatchQueue.main.async {
//                        let fullscreenPlayController = FullscreenPlayController()
//                        fullscreenPlayController.videoURL = televisionModel?.url ?? ""
//                        fullscreenPlayController.videoName = televisionModel?.name
//                        self?.navigationController?.pushViewController(fullscreenPlayController, animated: true)
//                    }
//                }
//                czSearchController.hidesBottomBarWhenPushed = true
//                self?.navigationController?.pushViewController(czSearchController, animated: true)
//            }
        }
        
        getTvData()
    }
    
    @objc func getTvData() {
        showEmptyViewWithLoading()
        DispatchQueue.global().async {
            do {
                let tvJsonString = try String(contentsOf: URL(string: "https://iptv-org.github.io/iptv/channels.json")!)
                self.televisionRootModels = Mapper<TelevisionRootModel>().mapArray(JSONString: tvJsonString)!
                // 获取所有国家 并去重复
                self.televisionCountryCodes = Array(Set(self.televisionRootModels.map{ $0.country?.code ?? "" }))
                DispatchQueue.main.async {
                    self.televisionView.segmentedDataSource.titles = self.televisionCountryCodes
                    self.televisionView.segmentedView.defaultSelectedIndex = 0
                    self.televisionView.segmentedView.reloadData()
                    self.showOrHideEmptyView(text: "暂无数据")
                }
            } catch {
                DispatchQueue.main.async {
                    self.showOrHideEmptyView(text: "数据解析失败")
                }
            }
        }
    }
    
    // MARK: - 显示或隐藏空视图
    func showOrHideEmptyView(text: String?) {
        televisionRootModels.count == 0 ? showEmptyView(withText: text, detailText: nil, buttonTitle: "重新加载", buttonAction: #selector(self.getTvData)) : hideEmptyView()
    }
}

extension TelevisionController: JXSegmentedListContainerViewDataSource {
    func numberOfLists(in listContainerView: JXSegmentedListContainerView) -> Int {
        return televisionRootModels.count
    }

    func listContainerView(_ listContainerView: JXSegmentedListContainerView, initListAt index: Int) -> JXSegmentedListContainerViewListDelegate {
        let televisionListController = TelevisionListController()
        // 获取当前国家
        let televisionCountry = self.televisionCountryCodes[index]
        // 获取当前国家所有频道
        televisionListController.televisionRootModels = self.televisionRootModels.filter{ $0.country?.code == televisionCountry }
        return televisionListController
    }
    
    
}
