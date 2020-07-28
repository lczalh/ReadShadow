//
//  AddBookSourceController.swift
//  Random
//
//  Created by yu mingming on 2020/6/12.
//  Copyright © 2020 刘超正. All rights reserved.
//

import UIKit

class AddBookSourceController: BaseController {
    
    lazy var addBookSourceView: AddBookSourceView = {
        let view = AddBookSourceView()
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
                "书源名称*",
                "书源地址*",
                "搜索地址*"
            ],
            [
                "搜索页编码格式*",
                "书本名称*",
                "书本详情地址*",
                "书本最新章节",
                "书本类别",
                "书本连载状态"
            ],
            [
                "书详情页编码格式*",
                "书本图片地址",
                "书本类别",
                "书本作者",
                "书本简介",
                "书本连载状态",
                "书本推荐阅读",
                "书本章节列表页地址",
                "章节详情地址*"
            ],
            [
                "书本章节详情内容*",
                "书本章节下一页详情内容地址"
            ]
        ]
    }
    
    /// 书源规则
    var bookReadParsingRuleModel: ReadShadowBookRuleResourceModel = ReadShadowBookRuleResourceModel()
    
    /// 上级页面更新回调
    var superiorPageUpdateBlock: (() -> Void)?
    
    /// 0: 新增 1:修改
    var type: String?
    
    override func setupNavigationItems() {
        titleView?.title = type == "0" ? "添加书源" : "修改书源"
        DispatchQueue.main.async { self.navigationController?.setNavigationBarHidden(false, animated: false) }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        addBookSourceView.cz.addSuperView(view).makeConstraints { (make) in
            if #available(iOS 11.0, *) {
                make.edges.equalTo(view.safeAreaLayoutGuide)
            } else {
                make.edges.equalToSuperview().inset(UIEdgeInsets(top: CZCommon.cz_navigationHeight + CZCommon.cz_statusBarHeight, left: 0, bottom: 0, right: 0))
            }
        }
        
        addBookSourceView.addButton.rx.tap.subscribe(onNext: {[weak self] () in
            if self?.bookReadParsingRuleModel.bookSourceName == nil || self?.bookReadParsingRuleModel.bookSourceName?.isEmpty == true {
                CZHUD.showError("还未输入书源名称")
                return
            }
            if self?.bookReadParsingRuleModel.bookSourceUrl == nil || self?.bookReadParsingRuleModel.bookSourceUrl?.isEmpty == true {
                CZHUD.showError("还未输入书源地址")
                return
            }
            if self?.bookReadParsingRuleModel.bookSearchEncoding == nil || self?.bookReadParsingRuleModel.bookSearchEncoding?.isEmpty == true {
                CZHUD.showError("还未输入搜索页编码格式")
                return
            }
            if self?.bookReadParsingRuleModel.bookSearchUrl == nil || self?.bookReadParsingRuleModel.bookSearchUrl?.isEmpty == true {
                CZHUD.showError("还未输入搜索地址")
                return
            }
            if self?.bookReadParsingRuleModel.bookSearchListNameRule == nil || self?.bookReadParsingRuleModel.bookSearchListNameRule?.isEmpty == true {
                CZHUD.showError("还未输入搜索列表书本名称规则")
                return
            }
            if self?.bookReadParsingRuleModel.bookSearchListDetailUrlRule == nil || self?.bookReadParsingRuleModel.bookSearchListDetailUrlRule?.isEmpty == true {
                CZHUD.showError("还未输入搜索列表书本详情地址规则")
                return
            }
            if self?.bookReadParsingRuleModel.bookDetailPageEncoding == nil || self?.bookReadParsingRuleModel.bookDetailPageEncoding?.isEmpty == true {
                CZHUD.showError("还未输入详情页编码格式")
                return
            }
            if self?.bookReadParsingRuleModel.bookChapterDetailUrlRule == nil || self?.bookReadParsingRuleModel.bookChapterDetailUrlRule?.isEmpty == true {
                CZHUD.showError("还未输入书本章节详情地址规则")
                return
            }
            if self?.bookReadParsingRuleModel.bookChapterDetailContentRule == nil || self?.bookReadParsingRuleModel.bookChapterDetailContentRule?.isEmpty == true {
                CZHUD.showError("还未输入书本章节详情内容规则")
                return
            }
            let _ = CZObjectStore.standard.cz_archiver(object: self!.bookReadParsingRuleModel, filePath: bookSourceRuleFolderPath + "/" + (self?.bookReadParsingRuleModel.bookSourceName ?? "") + ".plist")
            DispatchQueue.main.async {
                if self?.type == "0" {
                    CZHUD.showSuccess("添加成功")
                } else {
                    CZHUD.showSuccess("修改成功")
                }
                self?.navigationController?.popViewController(animated: true, {
                    if self?.superiorPageUpdateBlock != nil {
                        self!.superiorPageUpdateBlock!()
                    }
                })
            }
        }).disposed(by: rx.disposeBag)
    }
    
}


extension AddBookSourceController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitles.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellTitles[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: LeftTitleRightTextFieldTableViewCell.identifier, for: indexPath) as! LeftTitleRightTextFieldTableViewCell
        let sectionTitle = sectionTitles[indexPath.section]
        let cellTitle = cellTitles[indexPath.section][indexPath.row]
        if cellTitle.contains("*") == true {
            let string = NSMutableAttributedString(string: cellTitle)
            string.addAttributes([NSAttributedString.Key.foregroundColor : UIColor.cz_hexColor("#D81D1D")], range: NSRange(location: cellTitle.count - 1, length: 1))
            cell.titleLabel.attributedText = string
        } else {
            cell.titleLabel.text = cellTitle
        }
        cell.textField.isEnabled = true
        if sectionTitle == "基础信息" {
            if cellTitle == "书源名称*" {
                if type == "0" {
                    cell.textField.isEnabled = true
                } else {
                    cell.textField.isEnabled = false
                }
                cell.textField.placeholder = "请输入书源名称"
                cell.textField.text = bookReadParsingRuleModel.bookSourceName
                cell.returnInputText = {[weak self] text in
                    self?.bookReadParsingRuleModel.bookSourceName = text
                }
                return cell
            } else if cellTitle == "书源地址*" {
                cell.textField.placeholder = "请输入书源地址"
                cell.textField.text = bookReadParsingRuleModel.bookSourceUrl
                cell.returnInputText = {[weak self] text in
                    self?.bookReadParsingRuleModel.bookSourceUrl = text
                }
            } else if cellTitle == "搜索地址*" {
                cell.textField.placeholder = "请输入搜索地址"
                cell.textField.text = bookReadParsingRuleModel.bookSearchUrl
                cell.returnInputText = {[weak self] text in
                    self?.bookReadParsingRuleModel.bookSearchUrl = text
                }
            }
        } else if sectionTitle == "搜索列表页规则" {
            if cellTitle == "搜索页编码格式*" {
                cell.textField.placeholder = "请输入搜索页编码格式"
                cell.textField.text = bookReadParsingRuleModel.bookSearchEncoding
                cell.returnInputText = {[weak self] text in
                    self?.bookReadParsingRuleModel.bookSearchEncoding = text
                }
            } else if cellTitle == "书本名称*" {
                cell.textField.placeholder = "请输入书本名称规则"
                cell.textField.text = bookReadParsingRuleModel.bookSearchListNameRule
                cell.returnInputText = {[weak self] text in
                    self?.bookReadParsingRuleModel.bookSearchListNameRule = text
                }
            } else if cellTitle == "书本详情地址*" {
                cell.textField.placeholder = "请输入书本详情地址规则"
                cell.textField.text = bookReadParsingRuleModel.bookSearchListDetailUrlRule
                cell.returnInputText = {[weak self] text in
                    self?.bookReadParsingRuleModel.bookSearchListDetailUrlRule = text
                }
            } else if cellTitle == "书本最新章节" {
                cell.textField.placeholder = "请输入书本最新章节规则"
                cell.textField.text = bookReadParsingRuleModel.bookSearchListLatestChapterNameRule
                cell.returnInputText = {[weak self] text in
                    self?.bookReadParsingRuleModel.bookSearchListLatestChapterNameRule = text
                }
            } else if cellTitle == "书本类别" {
                cell.textField.placeholder = "请输入书本类别规则"
                cell.textField.text = bookReadParsingRuleModel.bookSearchListCategoryNameRule
                cell.returnInputText = {[weak self] text in
                    self?.bookReadParsingRuleModel.bookSearchListCategoryNameRule = text
                }
            } else if cellTitle == "书本连载状态" {
                cell.textField.placeholder = "请输入书本连载状态规则"
                cell.textField.text = bookReadParsingRuleModel.bookSearchListSerialStateRule
                cell.returnInputText = {[weak self] text in
                    self?.bookReadParsingRuleModel.bookSearchListSerialStateRule = text
                }
            }
        } else if sectionTitle == "书本详情页规则" {
            if cellTitle == "书详情页编码格式*" {
                cell.textField.placeholder = "请输入详情页编码格式"
                cell.textField.text = bookReadParsingRuleModel.bookSearchEncoding
                cell.returnInputText = {[weak self] text in
                    self?.bookReadParsingRuleModel.bookDetailPageEncoding = text
                }
            } else if cellTitle == "书本图片地址" {
                cell.textField.placeholder = "请输入书本图片地址规则"
                cell.textField.text = bookReadParsingRuleModel.bookDetailImageUrlRule
                cell.returnInputText = {[weak self] text in
                    self?.bookReadParsingRuleModel.bookDetailImageUrlRule = text
                }
            } else if cellTitle == "书本类别" {
                cell.textField.placeholder = "请输入书本类别规则"
                cell.textField.text = bookReadParsingRuleModel.bookDetailCategoryNameRule
                cell.returnInputText = {[weak self] text in
                    self?.bookReadParsingRuleModel.bookDetailCategoryNameRule = text
                }
            } else if cellTitle == "书本作者" {
                cell.textField.placeholder = "请输入书本作者规则"
                cell.textField.text = bookReadParsingRuleModel.bookDetailAuthorRule
                cell.returnInputText = {[weak self] text in
                    self?.bookReadParsingRuleModel.bookDetailAuthorRule = text
                }
            } else if cellTitle == "书本简介" {
                cell.textField.placeholder = "请输入书本简介规则"
                cell.textField.text = bookReadParsingRuleModel.bookDetailIntroductionRule
                cell.returnInputText = {[weak self] text in
                    self?.bookReadParsingRuleModel.bookDetailIntroductionRule = text
                }
            } else if cellTitle == "书本连载状态" {
                cell.textField.placeholder = "请输入书本连载状态规则"
                cell.textField.text = bookReadParsingRuleModel.bookDetailSerialStateRule
                cell.returnInputText = {[weak self] text in
                    self?.bookReadParsingRuleModel.bookDetailSerialStateRule = text
                }
            } else if cellTitle == "书本推荐阅读" {
                cell.textField.placeholder = "请输入书本推荐阅读规则"
                cell.textField.text = bookReadParsingRuleModel.bookDetailRecommendReadRule
                cell.returnInputText = {[weak self] text in
                    self?.bookReadParsingRuleModel.bookDetailRecommendReadRule = text
                }
            } else if cellTitle == "章节详情地址*" {
                cell.textField.placeholder = "请输入章节详情地址规则"
                cell.textField.text = bookReadParsingRuleModel.bookChapterDetailUrlRule
                cell.returnInputText = {[weak self] text in
                    self?.bookReadParsingRuleModel.bookChapterDetailUrlRule = text
                }
            } else if cellTitle == "书本章节列表页地址" {
                cell.textField.placeholder = "请输入书本章节列表页地址规则"
                cell.textField.text = bookReadParsingRuleModel.bookChapterListPageUrlRule
                cell.returnInputText = {[weak self] text in
                    self?.bookReadParsingRuleModel.bookChapterListPageUrlRule = text
                }
            }
        } else if sectionTitle == "书本章节详情页规则" {
            if cellTitle == "书本章节详情内容*" {
                cell.textField.placeholder = "请输入书本章节详情内容规则"
                cell.textField.text = bookReadParsingRuleModel.bookChapterDetailContentRule
                cell.returnInputText = {[weak self] text in
                    self?.bookReadParsingRuleModel.bookChapterDetailContentRule = text
                }
            } else if cellTitle == "书本章节下一页详情内容地址" {
                cell.textField.placeholder = "请输入书本章节下一页详情内容地址规则"
                cell.textField.text = bookReadParsingRuleModel.bookChapterDetailNextPageContentUrlRule
                cell.returnInputText = {[weak self] text in
                    self?.bookReadParsingRuleModel.bookChapterDetailNextPageContentUrlRule = text
                }
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
