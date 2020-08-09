//
//  BookReadSearchController.swift
//  Random
//
//  Created by yu mingming on 2020/7/9.
//  Copyright © 2020 刘超正. All rights reserved.
//

import UIKit

class BookReadSearchController: BaseController {
    
    private lazy var bookReadSearchView: BookReadSearchView = {
        let view = BookReadSearchView()
        view.searchResultTableView.delegate = self
        view.searchResultTableView.dataSource = self
        view.searchResultTableView.emptyDataSetSource = self
        view.searchResultTableView.emptyDataSetDelegate = self
        return view
    }()
    
    /// 所有书源模型
    private var readShadowBookRuleResourceModels: Array<ReadShadowBookRuleResourceModel> {
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
    
//    private let bookSearchQueue = DispatchQueue.init(label: "bookSearch")
//
//    private let bookSearchGroup = DispatchGroup()
    
    /// 搜索内容
    private var searchName: String?
    
    /// 小说搜索结果模型数组
    private var bookReadSearchResultModels: Array<[BookReadModel]> = []
    
    
    override func setupNavigationItems() {
        super.setupNavigationItems()
        navigationController?.setNavigationBarHidden(true, animated: false)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        bookReadSearchView.cz.addSuperView(view).makeConstraints { (make) in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        bookReadSearchView.searchTextField.becomeFirstResponder()
        
        bookReadSearchView.searchTextField.rx.value.orEmpty.throttle(DispatchTimeInterval.seconds(1), scheduler: MainScheduler.instance)
            .asObservable().subscribe(onNext: {[weak self] _ in
                guard self?.bookReadSearchView.searchTextField.markedTextRange == nil else { return }
                guard self?.bookReadSearchView.searchTextField.text?.isEmpty == false && self?.bookReadSearchView.searchTextField.text != nil else { return }
                guard self?.searchName != self?.bookReadSearchView.searchTextField.text else { return }
                self?.searchName = self?.bookReadSearchView.searchTextField.text
                self?.searchBooksData()
            }).disposed(by: rx.disposeBag)
        
        bookReadSearchView.cancelButton.rx.tap.subscribe(onNext: {[weak self] () in
            DispatchQueue.main.async {
                self?.bookReadSearchView.searchTextField.text = nil
                self?.navigationController?.popViewController(animated: true, nil)
            }
        }).disposed(by: rx.disposeBag)
    }
    

    @objc func searchBooksData() {
        DispatchQueue.global().async {
            for bookParsingRuleModel in self.readShadowBookRuleResourceModels {
                autoreleasepool {
                    var encoding: String.Encoding
                    var url = "\(bookParsingRuleModel.bookSearchUrl ?? "")\(self.searchName ?? "")"
                    if bookParsingRuleModel.bookSearchEncoding == "0" {
                        encoding = .utf8
                        url = url.cz_encoded()
                    } else {
                        encoding = .cz_gb_18030_2000
                        url = url.cz_chineseTurnGbkString
                    }
                    if let html = try? HTML(url: URL(string: url)!, encoding: encoding) {
                        var bookReadModels: Array<BookReadModel> = []
                        cz_print(html.body?.toHTML)
                        // 解析书名
                        if let bookNames = html.body?.xpath("\(bookParsingRuleModel.bookSearchListNameRule ?? "")") {
                            for name in bookNames {
                                autoreleasepool {
                                    let bookReadModel = BookReadModel()
                                    // 默认章节正序
                                    bookReadModel.bookReadChapterSortState = "0"
                                    // 默认章节index
                                    bookReadModel.bookLastReadChapterIndex = 0
                                    // 默认章节分页索引
                                    bookReadModel.bookLastReadChapterPagingIndex = 0
                                    // 解析规则
                                    bookReadModel.bookReadParsingRule = bookParsingRuleModel
                                    // 书名
                                    bookReadModel.bookName = name.text?.cz_removeHeadAndTailSpacePro
                                    bookReadModels.append(bookReadModel)
                                }
                                cz_print(name.text?.cz_removeHeadAndTailSpacePro)
                            }
                            
                        } else {
                            cz_print("书名解析失败")
                        }
                        
                        if bookReadModels.count != 0 {
                            // 解析书详情地址
                            if let bookDetailUrs = html.body?.xpath("\(bookParsingRuleModel.bookSearchListDetailUrlRule ?? "")") {
                                for (index, detailUr) in bookDetailUrs.enumerated() {
                                    autoreleasepool {
                                        let bookReadModel = bookReadModels[index]
                                        // 详情地址
                                        if detailUr["href"]?.contains("http://") == false && detailUr["href"]?.contains("https://") == false {
                                            if detailUr["href"]?.first == "/" {
                                                bookReadModel.bookDetailUrl = "\(bookParsingRuleModel.bookSourceUrl ?? "")\(detailUr["href"] ?? "")"
                                            } else {
                                                bookReadModel.bookDetailUrl = "\(bookParsingRuleModel.bookSourceUrl ?? "")/\(detailUr["href"] ?? "")"
                                            }
                                        } else {
                                            bookReadModel.bookDetailUrl = detailUr["href"] ?? ""
                                        }
                                    }
                                }
                            } else {
                                cz_print("书详情地址解析失败")
                            }
                            
                            // 解析最新章节
                            if let latestChapterNames = html.body?.xpath("\(bookParsingRuleModel.bookSearchListLatestChapterNameRule ?? "")") {
                                for (index, latestChapterName) in latestChapterNames.enumerated() {
                                    autoreleasepool {
                                        let bookReadModel = bookReadModels[index]
                                        bookReadModel.bookLatestChapter = latestChapterName.text?.cz_removeHeadAndTailSpacePro
                                        cz_print(bookReadModel.bookLatestChapter)
                                    }
                                }
                            } else {
                                cz_print("解析最新章节")
                            }
                            
                            // 解析类别
                            if let bookCategorys = html.body?.xpath(bookParsingRuleModel.bookSearchListCategoryNameRule ?? "") {
                                for (index, bookCategory) in bookCategorys.enumerated() {
                                    autoreleasepool {
                                        let bookReadModel = bookReadModels[index]
                                        bookReadModel.bookCategory = bookCategory.text?.cz_removeHeadAndTailSpacePro
                                        cz_print(bookCategory.text)
                                    }
                                }
                            } else {
                                cz_print("类别解析失败")
                            }
                            
                            // 解析连载状态
                            if let bookSerialStates = html.body?.xpath(bookParsingRuleModel.bookSearchListSerialStateRule ?? "") {
                                for (index, bookSerialState) in bookSerialStates.enumerated() {
                                    autoreleasepool {
                                        let bookReadModel = bookReadModels[index]
                                        bookReadModel.bookSerialState = bookSerialState.text?.cz_removeHeadAndTailSpacePro
                                        cz_print(bookReadModel.bookSerialState)
                                    }
                                }
                            } else {
                                cz_print("连载状态解析失败")
                            }
                            self.bookReadSearchResultModels.append(bookReadModels)
                        }
                    } else {
                        cz_print("小说搜索失败")
                    }
                    DispatchQueue.main.async {
                        self.bookReadSearchView.searchResultTableView.reloadData()
                    }
                }
            }
        }
    }

}

extension BookReadSearchController: UITableViewDataSource, UITableViewDelegate {

    func numberOfSections(in tableView: UITableView) -> Int {
        return bookReadSearchResultModels.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bookReadSearchResultModels[section].count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = bookReadSearchResultModels[indexPath.section][indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: VideoSearchTableViewCell.identifier) as! VideoSearchTableViewCell
        cell.videoNameLabel.text = model.bookName
        cell.rightLabel.text = model.bookLatestChapter
        return cell
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: BookReadHeaderView.identifier) as! BookReadHeaderView
        headerView.bookSourceNameLabel.text = bookReadSearchResultModels[section].first?.bookReadParsingRule?.bookSourceName
        return headerView
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CZCommon.cz_dynamicFitHeight(30)
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = bookReadSearchResultModels[indexPath.section][indexPath.row]
        DispatchQueue.main.async {
            let bookReadDetailsController = BookReadDetailsController()
            bookReadDetailsController.bookReadModel = model
            bookReadDetailsController.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(bookReadDetailsController, animated: true)
        }
    }
}


extension BookReadSearchController: DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    
//    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
//        return UIImage(named: "Icon_Placeholder")
//    }
    
}
