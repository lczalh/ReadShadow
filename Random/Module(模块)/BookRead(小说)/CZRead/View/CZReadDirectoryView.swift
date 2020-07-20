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
    
    /// 书阅读模型
    var bookReadModel: BookReadModel? {
        didSet {
            titleLabel.text = "\(bookReadModel?.bookSerialState ?? "")  \(bookReadModel?.bookName ?? "")"
            tableView.reloadData()
        }
    }
    
    /// 点击章节回调
    var tapChapterBlock: (() -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        let navigationView = UIView(frame: CGRect(x: 0, y: 0, width: bounds.width, height: CZCommon.cz_navigationHeight)).cz.addSuperView(self).build
        titleLabel = UILabel()
            .cz
            .addSuperView(navigationView)
            .makeConstraints({ (make) in
                make.left.equalToSuperview().offset(15)
                make.centerY.equalToSuperview()
                make.right.equalToSuperview().offset(-15)
            })
            .font(UIFont.cz_boldSystemFont(16))
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
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension CZReadDirectoryView: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bookReadModel?.bookReadChapter?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: VideoResourceTableViewCell.identifier, for: indexPath) as! VideoResourceTableViewCell
        let model = bookReadModel?.bookReadChapter?[indexPath.row]
        cell.titleLabel.text = model?.chapterName
        if bookReadModel?.bookLastReadChapterIndex == indexPath.row {
            cell.titleLabel.textColor = cz_selectedColor
        } else {
            if model?.chapterPaging == nil || model?.chapterPaging?.count ?? 0 == 0 { // 章节没有加载
                cell.titleLabel.textColor = cz_unselectedColor
            } else { // 章节已加载过
                cell.titleLabel.textColor = cz_standardTextColor
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tapChapterBlock != nil {
            let cell = tableView.cellForRow(at: indexPath)
            // 修正偏移位置
            var offsetPoint = tableView.contentOffset;
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
            
            bookReadModel?.bookLastReadChapterPagingIndex = 0
            bookReadModel?.bookLastReadChapterIndex = indexPath.row
            tapChapterBlock!()
            tableView.reloadData()
        }
    }
}
