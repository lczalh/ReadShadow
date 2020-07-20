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
        DispatchQueue.global().asyncAfter(deadline: DispatchTime.now() + 1) {
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
    func getBookcaseModels() -> Array<BookReadModel> {
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
        cell.bookTitleLabel.text = model.bookName
        cell.updateBookButton.addTarget(self, action: #selector(updateBookButtonAction), for: .touchUpInside)
        cell.removeBookButton.addTarget(self, action: #selector(removeBookButtonAction), for: .touchUpInside)
        return cell
    }
    
    /// 更新
    @objc func updateBookButtonAction(sender: UIButton) {
        let cell = sender.cz_superView(seekSuperView: BookcaseCollectionViewCell.self)
        let indexPath = bookReadView.collectionView.indexPath(for: cell!)
        let bookcaseModel = bookcaseModels[indexPath!.row]
        CZHUD.show("更新中")
        BookReadParsing.bookReadDetailParsing(bookReadModel: bookcaseModel) {[weak self] (model) in
            if model == nil {
                DispatchQueue.main.async { CZHUD.showError("更新失败") }
            } else {
                let state = CZObjectStore.standard.cz_archiver(object: bookcaseModel, filePath: "\(bookcaseFolderPath)/\(bookcaseModel.bookName ?? "").plist")
                guard state == true else {
                    CZHUD.showError("更新失败")
                    return
                }
                DispatchQueue.main.async {
                    CZHUD.showSuccess("更新成功")
                    self?.bookReadView.collectionView.reloadData()
                }
            }
        }
    }
    
    /// 移除
    @objc func removeBookButtonAction(sender: UIButton) {
        let cell = sender.cz_superView(seekSuperView: BookcaseCollectionViewCell.self)
        let indexPath = bookReadView.collectionView.indexPath(for: cell!)
        let model = bookcaseModels[indexPath!.row]
        do {
            try FileManager().removeItem(atPath: bookcaseFolderPath + "/\(model.bookName ?? "").plist")
            DispatchQueue.main.async {
                self.bookReadView.collectionView.reloadData()
                CZHUD.showSuccess("已移除")
            }
        } catch  {
            DispatchQueue.main.async {
                CZHUD.showError("移除失败")
            }
            
        }
        
    }
    
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
