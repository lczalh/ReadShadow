//
//  BookSourceDetailController.swift
//  Random
//
//  Created by yu mingming on 2020/6/29.
//  Copyright © 2020 刘超正. All rights reserved.
//

import UIKit

class BookSourceDetailController: BaseController {
    
    lazy var bookSourceDetailView: BookSourceDetailView = {
        let view = BookSourceDetailView()
        view.tableView.dataSource = self
        view.tableView.delegate = self
        return view
    }()
    
    var sectionTitles: Array<String>{
        return [
            "基础信息",
            "搜索列表页规则",
            "书本详情页规则",
            "书本章节详情页规则"
        ]
    }
    
    var cellTitles: Array<Array<String>> {
        return [
            [
                "书源名称",
                "书源地址",
                "编码格式",
                "搜索地址"
            ],
            [
                "书本名称",
                "书本详情地址",
                "书本最新章节",
                "书本类别",
                "书本连载状态"
            ],
            [
                "书本图片地址",
                "书本类别",
                "书本作者",
                "书本简介",
                "书本连载状态",
                "书本推荐阅读",
                "书本章节列表页地址",
                "章节详情地址"
            ],
            [
                "书本章节详情内容",
                "书本章节下一页详情内容地址"
            ]
        ]
    }
    
    var bookReadParsingRuleModel: BookReadParsingRuleModel?
    
    override func setupNavigationItems() {
        titleView?.title = "书源详情"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "修改", style: .done, target: nil, action: nil)
        navigationItem.rightBarButtonItem?.rx.tap.subscribe(onNext: {[weak self] () in
            DispatchQueue.main.async {
                let addBookSourceController = AddBookSourceController()
                addBookSourceController.type = "1"
                addBookSourceController.bookReadParsingRuleModel = self!.bookReadParsingRuleModel!
                addBookSourceController.superiorPageUpdateBlock = {[weak self] in
                    DispatchQueue.main.async {
                        self?.bookSourceDetailView.tableView.reloadData()
                    }
                }
                self?.navigationController?.pushViewController(addBookSourceController, animated: true)
            }
        }).disposed(by: rx.disposeBag)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        bookSourceDetailView.cz.addSuperView(view).makeConstraints { (make) in
            if #available(iOS 11.0, *) {
                make.edges.equalTo(view.safeAreaLayoutGuide)
            } else {
                make.edges.equalToSuperview().inset(UIEdgeInsets(top: CZCommon.cz_navigationHeight + CZCommon.cz_statusBarHeight, left: 0, bottom: 0, right: 0))
            }
        }
    }


}

extension BookSourceDetailController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitles.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellTitles[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: LeftTitleRightLabelTableViewCell.identifier, for: indexPath) as! LeftTitleRightLabelTableViewCell
        let sectionTitle = sectionTitles[indexPath.section]
        let cellTitle = cellTitles[indexPath.section][indexPath.row]
        cell.titleLabel.text = cellTitle
        if sectionTitle == "基础信息" {
            if cellTitle == "书源名称" {
                cell.rightLabel.text = bookReadParsingRuleModel?.bookSourceName
            } else if cellTitle == "书源地址" {
                cell.rightLabel.text = bookReadParsingRuleModel?.bookSourceUrl
            } else if cellTitle == "编码格式" {
                cell.rightLabel.text = bookReadParsingRuleModel?.bookSearchEncoding == .utf8 ? "UTF-8" : "GBK"
            } else if cellTitle == "搜索地址" {
                cell.rightLabel.text = bookReadParsingRuleModel?.bookSearchUrl
            }
        } else if sectionTitle == "搜索列表页规则" {
            if cellTitle == "书本名称" {
                cell.rightLabel.text = bookReadParsingRuleModel?.bookSearchListNameRule
            } else if cellTitle == "书本详情地址" {
                cell.rightLabel.text = bookReadParsingRuleModel?.bookSearchListDetailUrlRule
            } else if cellTitle == "书本最新章节" {
                cell.rightLabel.text = bookReadParsingRuleModel?.bookSearchListLatestChapterNameRule
            } else if cellTitle == "书本类别" {
                cell.rightLabel.text = bookReadParsingRuleModel?.bookSearchListCategoryNameRule
            } else if cellTitle == "书本连载状态" {
                cell.rightLabel.text = bookReadParsingRuleModel?.bookSearchListSerialStateRule
            }
        } else if sectionTitle == "书本详情页规则" {
            if cellTitle == "书本图片地址" {
                cell.rightLabel.text = bookReadParsingRuleModel?.bookDetailImageUrlRule
            } else if cellTitle == "书本类别" {
                cell.rightLabel.text = bookReadParsingRuleModel?.bookDetailCategoryNameRule
            } else if cellTitle == "书本作者" {
                cell.rightLabel.text = bookReadParsingRuleModel?.bookDetailAuthorRule
            } else if cellTitle == "书本简介" {
                cell.rightLabel.text = bookReadParsingRuleModel?.bookDetailIntroductionRule
            } else if cellTitle == "书本连载状态" {
                cell.rightLabel.text = bookReadParsingRuleModel?.bookDetailSerialStateRule
            } else if cellTitle == "书本推荐阅读" {
                cell.rightLabel.text = bookReadParsingRuleModel?.bookDetailRecommendReadRule
            } else if cellTitle == "章节详情地址" {
                cell.rightLabel.text = bookReadParsingRuleModel?.bookChapterDetailUrlRule
            } else if cellTitle == "书本章节列表页地址" {
                cell.rightLabel.text = bookReadParsingRuleModel?.bookChapterListPageUrlRule
            }
        } else if sectionTitle == "书本章节详情页规则" {
            if cellTitle == "书本章节详情内容" {
                cell.rightLabel.text = bookReadParsingRuleModel?.bookChapterDetailContentRule
            } else if cellTitle == "书本章节下一页详情内容地址" {
                cell.rightLabel.text = bookReadParsingRuleModel?.bookChapterDetailNextPageContentUrlRule
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: BookReadHeaderView.identifier) as! BookReadHeaderView
        let title = sectionTitles[section]
        headerView.bookSourceNameLabel.text = title
        return headerView
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CZCommon.cz_dynamicFitHeight(40)
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    
}
