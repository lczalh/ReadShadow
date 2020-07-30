//
//  BookReadController.swift
//  Random
//
//  Created by yu mingming on 2020/6/9.
//  Copyright © 2020 刘超正. All rights reserved.
//

import UIKit

class BookReadController: BaseController {
    
    
    lazy var bookReadView: BookReadView = {
        let view = BookReadView()
        view.collectionView.dataSource = self
        view.collectionView.delegate = self
        return view
    }()
    
    /// 书架列表model
    var bookcaseModels: Array<BookReadModel> = [] {
        didSet {
            DispatchQueue.main.async {
                self.bookReadView.collectionView.reloadData()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DispatchQueue.global().async {
            self.bookcaseModels = self.getBookcaseModels()
        }
    }
    
    override func setupNavigationItems() {
        super.setupNavigationItems()
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        emptyView?.backgroundColor = UIColor.white
        bookReadView.cz.addSuperView(view).makeConstraints { (make) in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        bookReadView.tapSearchLabelBlock = {[weak self] recognizer in
            DispatchQueue.main.async {
                let bookReadSearchController = BookReadSearchController()
                bookReadSearchController.hidesBottomBarWhenPushed = true
                self?.navigationController?.pushViewController(bookReadSearchController, animated: true)
            }
        }
    }
    
    /// 获取书架模型数组
    /// - Returns: 书架模型数组
    private func getBookcaseModels() -> Array<BookReadModel> {
        do {
            var models: Array<BookReadModel> = []
            let files = try FileManager().contentsOfDirectory(atPath: bookcaseFolderPath).filter{ $0.pathExtension == "plist" }
            for file in files {
                let model = CZObjectStore.standard.cz_unarchiver(filePath: "\(bookcaseFolderPath)/\(file)") as? BookReadModel
                models.append(model!)
            }
            return models
        } catch {
            return []
        }
    }

}

extension BookReadController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return bookcaseModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BookcaseCollectionViewCell.identifier, for: indexPath) as! BookcaseCollectionViewCell
        let model = bookcaseModels[indexPath.row]
        cell.bookImageView.kf.indicatorType = .activity
        cell.bookImageView.kf.setImage(with: URL(string: model.bookImageUrl), placeholder: UIImage(named: "Icon_Book_Placeholder"))
        cell.bookTitleLabel.text = "\(model.bookReadParsingRule?.bookSourceName ?? "")-\(model.bookName ?? "")"
        let longPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(cellLongPressGestureRecognizerAction))
        cell.contentView.addGestureRecognizer(longPressGestureRecognizer)
        return cell
    }
    
    @objc private func cellLongPressGestureRecognizerAction(recognizer: UILongPressGestureRecognizer) {
        guard recognizer.state == .began else { return }
        let cell = recognizer.view?.cz_superView(seekSuperView: BookcaseCollectionViewCell.self)
        let indexPath = bookReadView.collectionView.indexPath(for: cell!)
        let bookcaseModel = bookcaseModels[indexPath!.row]
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
        let updateAction = UIAlertAction(title: "更新", style: .default) { (action) in
            CZHUD.show("更新中")
            BookReadParsing.bookReadDetailParsing(bookReadModel: bookcaseModel) {[weak self] (model) in
                guard model != nil else {
                    DispatchQueue.main.async { CZHUD.showError("更新失败") }
                    return
                }
                if bookcaseModel.bookReadChapter?.count ?? 0 < model?.bookReadChapter?.count ?? 0 { // 存在新章节
                    let _ = CZObjectStore.standard.cz_archiver(object: bookcaseModel, filePath: "\(bookcaseFolderPath)/\(bookcaseModel.bookReadParsingRule?.bookSourceName ?? "")-\(bookcaseModel.bookName ?? "").plist")
                    DispatchQueue.main.async {
                        CZHUD.showSuccess("成功更新至最新章节")
                        self?.bookcaseModels = self?.getBookcaseModels() ?? []
                    }
                } else { // 无须更新
                    DispatchQueue.main.async {
                        CZHUD.showError("当前已是最新章节")
                    }
                }
            }
        }
        let removeAction = UIAlertAction(title: "删除", style: .default) { (action) in
            do {
                try FileManager().removeItem(atPath: bookcaseFolderPath + "/\(bookcaseModel.bookReadParsingRule?.bookSourceName ?? "")-\(bookcaseModel.bookName ?? "").plist")
                DispatchQueue.main.async {
                    CZHUD.showSuccess("删除成功")
                    self.bookcaseModels = self.getBookcaseModels()
                }
            } catch  {
                DispatchQueue.main.async {
                    CZHUD.showError("删除失败")
                }
                
            }
        }
        let infoAction = UIAlertAction(title: "信息", style: .default) { (action) in
            DispatchQueue.main.async {
                let bookReadDetailsController = BookReadDetailsController()
                bookReadDetailsController.bookReadModel = bookcaseModel
                bookReadDetailsController.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(bookReadDetailsController, animated: true)
            }
        }
        let cancelAction = UIAlertAction(title: "取消", style: .default) { (action) in }
        alertController.addAction(updateAction)
        alertController.addAction(removeAction)
        alertController.addAction(infoAction)
        alertController.addAction(cancelAction)
        DispatchQueue.main.async { self.present(alertController, animated: true, completion: nil) }
    }
    
//    /// 更新
//    @objc func updateBookButtonAction(sender: UIButton) {
//        let cell = sender.cz_superView(seekSuperView: BookcaseCollectionViewCell.self)
//        let indexPath = bookReadView.collectionView.indexPath(for: cell!)
//        let bookcaseModel = bookcaseModels[indexPath!.row]
//        CZHUD.show("更新中")
//        BookReadParsing.bookReadDetailParsing(bookReadModel: bookcaseModel) {[weak self] (model) in
//            if model == nil {
//                DispatchQueue.main.async { CZHUD.showError("更新失败") }
//            } else {
//                let state = CZObjectStore.standard.cz_archiver(object: bookcaseModel, filePath: "\(bookcaseFolderPath)/\(bookcaseModel.bookReadParsingRule?.bookSourceName ?? "")-\(bookcaseModel.bookName ?? "").plist")
//                guard state == true else {
//                    CZHUD.showError("更新失败")
//                    return
//                }
//                DispatchQueue.main.async {
//                    CZHUD.showSuccess("更新成功")
//                    self?.bookReadView.collectionView.reloadData()
//                }
//            }
//        }
//    }
//    
//    /// 移除
//    @objc func removeBookButtonAction(sender: UIButton) {
//        let cell = sender.cz_superView(seekSuperView: BookcaseCollectionViewCell.self)
//        let indexPath = bookReadView.collectionView.indexPath(for: cell!)
//        let model = bookcaseModels[indexPath!.row]
//        do {
//            try FileManager().removeItem(atPath: bookcaseFolderPath + "/\(model.bookName ?? "").plist")
//            DispatchQueue.main.async {
//                self.bookReadView.collectionView.reloadData()
//                CZHUD.showSuccess("已移除")
//            }
//        } catch  {
//            DispatchQueue.main.async {
//                CZHUD.showError("移除失败")
//            }
//            
//        }
//        
//    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let model = bookcaseModels[indexPath.row]
        DispatchQueue.main.async {
            let czReadController = CZReadController()
            czReadController.hidesBottomBarWhenPushed = true
            czReadController.bookReadModel = model
            self.navigationController?.pushViewController(czReadController, animated: true)
        }
    }
    
}
