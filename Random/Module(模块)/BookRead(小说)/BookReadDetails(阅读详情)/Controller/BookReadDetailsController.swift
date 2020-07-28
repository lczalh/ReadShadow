//
//  BookReadDetailsController.swift
//  Random
//
//  Created by yu mingming on 2020/6/9.
//  Copyright © 2020 刘超正. All rights reserved.
//

import UIKit

class BookReadDetailsController: BaseController {
    
    lazy var bookReadDetailsView: BookReadDetailsView = {
        let view = BookReadDetailsView()
        view.tableView.delegate = self
        view.tableView.dataSource = self
        return view
    }()
    
    /// 书阅读模型
    var bookReadModel: BookReadModel?
    
    /// 插页式广告
    var gadInterstitial: GADInterstitial!
    
    //获取导航栏背景视图
    var barImageView: UIView? {
        navigationController?.navigationBar.subviews.first
    }
    
    /// 广告特权
    lazy var isAdvertisingPrivilege: Bool = {
        return isGetAdvertisingPrivilege()
    }()
    
    override func setupNavigationItems() {
        super.setupNavigationItems()
        barImageView?.alpha = 0
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if isAdvertisingPrivilege == false {
            requestAdvertising(adUnitId: "ca-app-pub-7194032995143004/5520274708")
        }
        bookReadDetailsView.cz.addSuperView(view).makeConstraints { (make) in
            make.top.equalToSuperview()
            make.right.left.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        // 创建书架文件夹
        _ = CZObjectStore.standard.cz_createFolder(folderPath: bookcaseFolderPath)
        // 创建历史浏览记录文件夹
        _ = CZObjectStore.standard.cz_createFolder(folderPath: bookBrowsingRecordFolderPath)
        
        bookReadDetailsView.isHidden = true
        
        if bookReadModel?.bookReadChapter?.count ?? 0 > 0 { // 存在章节数据了
            updateRecordsAndUi()
        } else {
            CZHUD.show("解析中")
            BookReadParsing.bookReadDetailParsing(bookReadModel: bookReadModel!) {[weak self] (model) in
                if model == nil {
                    DispatchQueue.main.async { CZHUD.showError("解析失败") }
                } else {
                    self?.updateRecordsAndUi()
                }
            }
        }
        
        
        // 开始阅读
        bookReadDetailsView.readButton.rx.tap.subscribe(onNext: {[weak self] () in
            DispatchQueue.main.async {
                let czReadController = CZReadController()
                czReadController.bookReadModel = self?.bookReadModel
                self?.navigationController?.pushViewController(czReadController, animated: true)
            }
        }).disposed(by: rx.disposeBag)
        
        // 添加书架
        bookReadDetailsView.addBookcaseButton.rx.tap.subscribe(onNext: {[weak self] () in
            let state = CZObjectStore.standard.cz_archiver(object: self!.bookReadModel!, filePath: "\(bookcaseFolderPath)/\(self!.bookReadModel?.bookReadParsingRule?.bookSourceName ?? "")-\(self!.bookReadModel?.bookName ?? "").plist")
            guard state == true else {
                CZHUD.showError("添加失败")
                return
            }
            DispatchQueue.main.async {
                self?.bookReadDetailsView.addBookcaseButton.cz_textAndPictureLocation(image: UIImage(named: "Icon_BookRead_Bookcase")?.cz_alterColor(color: cz_unselectedColor), title: "在书架", titlePosition: .right, additionalSpacing: 5, state: .normal)
                self?.bookReadDetailsView.addBookcaseButton.setTitleColor(cz_unselectedColor, for: .normal)
                self?.bookReadDetailsView.addBookcaseButton.isEnabled = false
            }
        }).disposed(by: rx.disposeBag)
    }
    
    /// 更新记录和UI
    func updateRecordsAndUi() {
       // self.bookReadModel?.bookReadChapter = self.bookReadModel?.bookReadChapterSortState == "0" ? self.bookReadModel?.bookReadChapter : self.bookReadModel?.bookReadChapter?.reversed()
        // 记录浏览时间
        self.bookReadModel?.browseTime = Date().string(withFormat: "yyyy-MM-dd HH:mm:ss")
        // 更新记录
        _ = CZObjectStore.standard.cz_archiver(object: self.bookReadModel!, filePath: "\(bookBrowsingRecordFolderPath)/\(self.bookReadModel?.bookReadParsingRule?.bookSourceName ?? "")-\(self.bookReadModel?.bookName ?? "").plist")
        
        DispatchQueue.main.async {
            CZHUD.dismiss()
            // 判断对象是否存在
            let bookcaseModel = CZObjectStore.standard.cz_unarchiver(filePath: "\(bookcaseFolderPath)/\(self.bookReadModel?.bookReadParsingRule?.bookSourceName ?? "")-\(self.bookReadModel?.bookName ?? "").plist") as? BookReadModel
            if bookcaseModel == nil {
                self.bookReadDetailsView.addBookcaseButton.cz_textAndPictureLocation(image: UIImage(named: "Icon_BookRead_Bookcase")?.cz_alterColor(color: cz_selectedColor), title: "加书架", titlePosition: .right, additionalSpacing: 5, state: .normal)
                self.bookReadDetailsView.addBookcaseButton.setTitleColor(cz_selectedColor, for: .normal)
                self.bookReadDetailsView.addBookcaseButton.isEnabled = true
            } else {
                if bookcaseModel?.bookReadChapter?.count ?? 0 >= self.bookReadModel?.bookReadChapter?.count ?? 0 { // 无须更新
                    self.bookReadDetailsView.addBookcaseButton.cz_textAndPictureLocation(image: UIImage(named: "Icon_BookRead_Bookcase")?.cz_alterColor(color: cz_unselectedColor), title: "在书架", titlePosition: .right, additionalSpacing: 5, state: .normal)
                    self.bookReadDetailsView.addBookcaseButton.setTitleColor(cz_unselectedColor, for: .normal)
                    self.bookReadDetailsView.addBookcaseButton.isEnabled = false
                } else {
                    self.bookReadDetailsView.addBookcaseButton.cz_textAndPictureLocation(image: UIImage(named: "Icon_BookRead_Bookcase")?.cz_alterColor(color: .red), title: "更新书架", titlePosition: .right, additionalSpacing: 5, state: .normal)
                    self.bookReadDetailsView.addBookcaseButton.setTitleColor(.red, for: .normal)
                    self.bookReadDetailsView.addBookcaseButton.isEnabled = true
                }
            }
            if self.bookReadModel?.bookLastReadChapterIndex == 0 {
                self.bookReadDetailsView.readButton.setTitle("开始阅读", for: .normal)
            } else {
                self.bookReadDetailsView.readButton.setTitle("继续阅读", for: .normal)
            }
            self.bookReadDetailsView.isHidden = false
            self.bookReadDetailsView.tableView.reloadData()
        }
    }
    
    /// 请求广告
    func requestAdvertising(adUnitId: String) {
        gadInterstitial = GADInterstitial(adUnitID: adUnitId)
        gadInterstitial.delegate = self
        gadInterstitial.load(GADRequest())
    }
}

extension BookReadDetailsController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if bookReadModel?.bookRecommendRead?.count == nil || bookReadModel?.bookRecommendRead?.count == 0 {
           return 1
        } else {
            return 2
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 4
        } else {
            return bookReadModel?.bookRecommendRead?.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: BookReadBasicInfoTableViewCell.identifier, for: indexPath) as! BookReadBasicInfoTableViewCell
                cell.bookImageView?.kf.indicatorType = .activity
                cell.bookImageView?.kf.setImage(with: URL(string: bookReadModel?.bookImageUrl), placeholder: UIImage(named: "Icon_Book_Placeholder"))
                cell.bookNameLabel.text = bookReadModel?.bookName
                cell.bookAuthorLabel.text = bookReadModel?.bookAuthor
                cell.bookCategoryLabel.text = bookReadModel?.bookCategory
                cell.bookBackImageView?.kf.setImage(with: URL(string: bookReadModel?.bookImageUrl), placeholder: UIImage(named: "Icon_Book_Placeholder"))
                return cell
            } else if indexPath.row == 1 {
                let cell = tableView.dequeueReusableCell(withIdentifier: BookReadIntroductionTableViewCell.identifier, for: indexPath) as! BookReadIntroductionTableViewCell
                cell.introductionLabel.text = bookReadModel?.bookIntroduction
                return cell
            } else if indexPath.row == 2 {
                let cell = tableView.dequeueReusableCell(withIdentifier: BookReadNewestTableViewCell.identifier, for: indexPath) as! BookReadNewestTableViewCell
                cell.leftImageView.image = UIImage(named: "Icon_Record")
                cell.titleLabel.text = "最新"
                cell.detailLabel.text = bookReadModel?.bookReadChapter?.last?.chapterName
                cell.tapBlock = {[weak self] recognizer in
                    guard self?.bookReadModel?.bookReadChapter?.count ?? 0 > 0 else { return  }
                    DispatchQueue.main.async { // 去阅读最后一章
                        let czReadController = CZReadController()
                        self?.bookReadModel?.bookLastReadChapterIndex = (self?.bookReadModel?.bookReadChapter?.count ?? 0) - 1
                        self?.bookReadModel?.bookLastReadChapterPagingIndex = 0
                        czReadController.bookReadModel = self?.bookReadModel
                        self?.navigationController?.pushViewController(czReadController, animated: true)
                    }
                }
                return cell
            } else if indexPath.row == 3 {
                let cell = tableView.dequeueReusableCell(withIdentifier: BookReadNewestTableViewCell.identifier, for: indexPath) as! BookReadNewestTableViewCell
                cell.leftImageView.image = UIImage(named: "Icon_BookRead_Directory")
                cell.titleLabel.text = "目录"
                cell.detailLabel.text = "共\(bookReadModel?.bookReadChapter?.count ?? 0)章"
                cell.tapBlock = {[weak self] recognizer in
                    DispatchQueue.main.async {
                        let bookReadDirectoryController = BookReadDirectoryController()
                        bookReadDirectoryController.bookReadModel = self?.bookReadModel
                        self?.navigationController?.pushViewController(bookReadDirectoryController, animated: true)
                    }
                }
                return cell
            } else {
                return BookReadNewestTableViewCell()
            }
        } else { // 推荐阅读
            let cell = tableView.dequeueReusableCell(withIdentifier: BookReadNewestTableViewCell.identifier, for: indexPath) as! BookReadNewestTableViewCell
            let model = bookReadModel?.bookRecommendRead?[indexPath.row]
            cell.leftImageView.image = UIImage(named: "Icon_BookRead_Book")
            cell.titleLabel.text = model?.bookName
            cell.tapBlock = {[weak self] recognizer in
                let model = self?.bookReadModel?.bookRecommendRead?[indexPath.row]
                DispatchQueue.main.async {
                   // self?.navigationController?.setNavigationBarHidden(true, animated: false)
                    let bookReadDetailsController = BookReadDetailsController()
                    bookReadDetailsController.bookReadModel = model
                    self?.navigationController?.pushViewController(bookReadDetailsController, animated: true)
                }
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: BookReadDetailsHeaderView.identifier) as! BookReadDetailsHeaderView
        if section == 0 {
            headerView.recommendReadLabel.text = ""
        } else {
            headerView.recommendReadLabel.text = "推荐阅读"
        }
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0.01
        } else {
            return CZCommon.cz_dynamicFitHeight(40)
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 0 {
            return CZCommon.cz_dynamicFitHeight(5)
        } else {
            return 0.01
        }
    }
    
    //视图滚动时触发
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let alpha = scrollView.contentOffset.y / (CZCommon.cz_navigationHeight + CZCommon.cz_statusBarHeight)
        if alpha < 1 {
            titleView?.title = nil
            barImageView?.alpha = alpha
        } else {
            titleView?.title = bookReadModel?.bookName
            barImageView?.alpha = 1
        }
    }
}

extension BookReadDetailsController: GADInterstitialDelegate {
    /// 广告加载成功
    func interstitialDidReceiveAd(_ ad: GADInterstitial) {
        DispatchQueue.main.async {
            ad.present(fromRootViewController: self)
        }
    }

    /// 广告加载失败
    func interstitial(_ ad: GADInterstitial, didFailToReceiveAdWithError error: GADRequestError) {
        requestAdvertising(adUnitId: "ca-app-pub-7194032995143004/1557527707")
    }

    /// 告知委托将显示一个间隙。
    func interstitialWillPresentScreen(_ ad: GADInterstitial) {
      print("interstitialWillPresentScreen")
    }

    /// 告诉委托该间隙将被动画移出屏幕。
    func interstitialWillDismissScreen(_ ad: GADInterstitial) {
      print("interstitialWillDismissScreen")
    }

    /// 告诉委托该间隙已被动画移出屏幕。
    func interstitialDidDismissScreen(_ ad: GADInterstitial) {
       
    }

    ///告诉委托用户单击将打开另一个应用程序
    ///(如App Store)，为当前应用设置后台。
    func interstitialWillLeaveApplication(_ ad: GADInterstitial) {
        
    }
}
