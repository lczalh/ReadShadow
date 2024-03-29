//
//  BookReadDirectoryController.swift
//  Random
//
//  Created by yu mingming on 2020/6/10.
//  Copyright © 2020 刘超正. All rights reserved.
//

import UIKit

class BookReadDirectoryController: BaseController {
    
    lazy var bookReadDirectoryView: BookReadDirectoryView = {
        let view = BookReadDirectoryView()
        view.tableView.delegate = self
        view.tableView.dataSource = self
        view.chapterNumberLabel.text = "共\(bookReadModel?.bookReadChapter?.count ?? 0)章"
        view.serialStateLabel.text = bookReadModel?.bookSerialState
        return view
    }()
    
    /// 书阅读模型
    var bookReadModel: BookReadModel?
    
    override func setupNavigationItems() {
        super.setupNavigationItems()
        titleView?.title = bookReadModel?.bookName
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        bookReadDirectoryView.cz.addSuperView(view).makeConstraints { (make) in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        bookReadDirectoryView.sortButton.rx.tap.subscribe(onNext: {[weak self] () in
            self?.bookReadModel?.bookReadChapter = self?.bookReadModel?.bookReadChapter?.reversed()
            self?.bookReadDirectoryView.tableView.reloadData()
        }).disposed(by: rx.disposeBag)
    }

}

extension BookReadDirectoryController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bookReadModel?.bookReadChapter?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: BookReadDirectoryTableViewCell.identifier, for: indexPath) as! BookReadDirectoryTableViewCell
        let bookReadChapterModel = bookReadModel?.bookReadChapter?[indexPath.row]
        cell.chapterNameLabel.text = bookReadChapterModel?.chapterName
        if bookReadChapterModel?.chapterPaging == nil || bookReadChapterModel?.chapterPaging?.count ?? 0 == 0 { // 章节没有加载
            cell.chapterNameLabel.textColor = cz_unselectedColor
        } else { // 章节已加载过
            cell.chapterNameLabel.textColor = cz_standardTextColor
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        DispatchQueue.main.async {
            let czReadController = CZReadController()
            self.bookReadModel?.bookLastReadChapterIndex = indexPath.row
            self.bookReadModel?.bookLastReadChapterPagingIndex = 0
            czReadController.bookReadModel = self.bookReadModel
            czReadController.readBackActionBlock = {
                DispatchQueue.main.async { tableView.reloadData() }
            }
            self.navigationController?.pushViewController(czReadController, animated: true)
        }
    }
}
