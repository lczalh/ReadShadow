//
//  CZReadDirectoryView.swift
//  Random
//
//  Created by yu mingming on 2020/5/13.
//  Copyright © 2020 刘超正. All rights reserved.
//

import UIKit

class CZReadDirectoryView: BaseView {
    
    /// 标题
    var titleLabel: UILabel!
    
    var tableView: UITableView!
    
//    /// 书阅读模型
//    var bookReadModel: BookReadModel? {
//        didSet {
//            titleLabel.text = "\(bookReadModel?.bookSerialState ?? "")  \(bookReadModel?.bookName ?? "")"
//            tableView.reloadData()
//        }
//    }
    
    /// 连载状态
    var bookSerialState: String? {
        didSet {
            titleLabel.text = bookSerialState
        }
    }
    
    /// 所有章节模型
    var bookReadChapter: Array<BookReadChapterModel>? {
        didSet {
            tableView.reloadData()
        }
    }
    
    /// 点击章节回调
    var tapChapterBlock: ((_ index: Int, _ isDetermineChangeOrdering: Bool) -> Void)?
    
    /// 排序按钮
    private var sortButton: UIButton!
    
    /// 排序状态 默认是正序 0:正序 1:倒叙
    private var sortState: String = "0"
    
    /// 记录当前排序状态  0:正序 1:倒叙
    var bookReadChapterSortState: String = "0" {
        didSet {
            sortState = bookReadChapterSortState
        }
    }


    override init(frame: CGRect) {
        super.init(frame: frame)
        let navigationView = UIView(frame: CGRect(x: 0, y: 0, width: bounds.width, height: CZCommon.cz_navigationHeight)).cz.addSuperView(self).build
        
        sortButton = UIButton()
            .cz
            .addSuperView(navigationView)
            .makeConstraints({ (make) in
                make.right.equalToSuperview().offset(-15)
                make.centerY.equalToSuperview()
            })
            .image(UIImage(named: "Icon_BookRead_Sort"), for: .normal)
            .contentMode(.scaleAspectFit)
            .setContentHuggingPriority(.required, for: .horizontal)
            .setContentCompressionResistancePriority(.required, for: .horizontal)
            .build
        
        titleLabel = UILabel()
            .cz
            .addSuperView(navigationView)
            .makeConstraints({ (make) in
                make.left.equalToSuperview().offset(15)
                make.centerY.equalToSuperview()
                make.right.equalTo(sortButton.snp.left).offset(-10)
            })
            .font(UIFont.cz_boldSystemFont(12))
            .textColor(cz_standardTextColor)
            .build
        let dividerView = UIView(frame: CGRect(x: 0, y: CZCommon.cz_navigationHeight + 1, width: bounds.width, height: 1)).cz.addSuperView(self).backgroundColor(cz_dividerColor).build
        
        tableView = UITableView(frame: .zero, style: .plain)
            .cz
            .addSuperView(self)
            .makeConstraints({ (make) in
                make.top.equalTo(dividerView.snp.bottom)
                make.left.right.bottom.equalToSuperview()
            })
            .rowHeight(CZCommon.cz_dynamicFitHeight(40))
            .register(VideoResourceTableViewCell.self, forCellReuseIdentifier: VideoResourceTableViewCell.identifier)
            .separatorStyle(.none)
            .dataSource(self)
            .delegate(self)
            .build
        
        // 目录排序
        sortButton.rx.tap.subscribe(onNext: {[weak self] () in
            self?.bookReadChapter = self?.bookReadChapter?.reversed()
            self?.sortState = self?.sortState == "0" ? "1" : "0"
        }).disposed(by: rx.disposeBag)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension CZReadDirectoryView: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bookReadChapter?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: VideoResourceTableViewCell.identifier, for: indexPath) as! VideoResourceTableViewCell
        let model = bookReadChapter?[indexPath.row]
        cell.titleLabel.text = model?.chapterName
        if model?.chapterPaging == nil || model?.chapterPaging?.count ?? 0 == 0 { // 章节没有加载
            cell.titleLabel.textColor = cz_unselectedColor
        } else { // 章节已加载过
            cell.titleLabel.textColor = cz_standardTextColor
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tapChapterBlock != nil {
            var isDetermineChangeOrdering: Bool = false
            if bookReadChapterSortState != sortState {
              //  bookReadChapterSortState = sortState
                isDetermineChangeOrdering = true
            }
            
            let cell = tableView.cellForRow(at: indexPath)
            // 修正偏移位置
            var offsetPoint = tableView.contentOffset
            offsetPoint.y = (cell?.center.y)! - tableView.frame.height / 2
            //顶边超出处理
            if (offsetPoint.y < 0) {
                offsetPoint.y = 0
            }
            let maxX = tableView.contentSize.height - tableView.frame.height
            //底边超出处理
            if (offsetPoint.y > maxX) {
                offsetPoint.y = maxX
            }
            //设置滚动视图偏移量
            tableView.setContentOffset(offsetPoint, animated: true)
            tapChapterBlock!(indexPath.row, isDetermineChangeOrdering)
        }
    }
}
