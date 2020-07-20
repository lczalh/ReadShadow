//
//  TelevisionSearchController.swift
//  Random
//
//  Created by yu mingming on 2020/7/9.
//  Copyright © 2020 刘超正. All rights reserved.
//

import UIKit

class TelevisionSearchController: BaseController {
    
    private lazy var televisionSearchView: TelevisionSearchView = {
        let view = TelevisionSearchView()
        view.searchResultTableView.delegate = self
        view.searchResultTableView.dataSource = self
        return view
    }()
    
    /// 电视模型
    var televisionRootModels: [TelevisionRootModel] = []
    
    /// 存储搜索到的数据模型
    private var searchTelevisionRootModels: [TelevisionRootModel] = []
    
    override func setupNavigationItems() {
        super.setupNavigationItems()
        navigationController?.setNavigationBarHidden(true, animated: false)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        televisionSearchView.cz.addSuperView(view).makeConstraints { (make) in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        televisionSearchView.searchTextField.becomeFirstResponder()
        // 输入框值改变事件
        televisionSearchView.searchTextField.rx.text.orEmpty
            .asObservable().subscribe(onNext: {[weak self] text in
                guard self?.televisionSearchView.searchTextField.markedTextRange == nil else { return }
                self?.searchTelevisionRootModels = self?.televisionRootModels.filter{ $0.name?.contains(text) == true } ?? []
                DispatchQueue.main.async {
                    self?.televisionSearchView.searchResultTableView.reloadData()
                }
            }).disposed(by: rx.disposeBag)
        
        televisionSearchView.cancelButton.rx.tap.subscribe(onNext: {[weak self] () in
            DispatchQueue.main.async {
                self?.navigationController?.popViewController(animated: true, nil)
            }
        }).disposed(by: rx.disposeBag)
    }
    

}


extension TelevisionSearchController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchTelevisionRootModels.count 
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let searchTelevisionRootModel = searchTelevisionRootModels[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: VideoSearchTableViewCell.identifier) as! VideoSearchTableViewCell
        cell.videoNameLabel.text = searchTelevisionRootModel.name
        cell.rightLabel.text = searchTelevisionRootModel.country?.name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let searchTelevisionRootModel = searchTelevisionRootModels[indexPath.row]
        DispatchQueue.main.async {
            let fullscreenPlayController = FullscreenPlayController()
            fullscreenPlayController.videoURL = searchTelevisionRootModel.url ?? ""
            fullscreenPlayController.videoName = searchTelevisionRootModel.name
            self.navigationController?.pushViewController(fullscreenPlayController, animated: true)
        }
    }
}
