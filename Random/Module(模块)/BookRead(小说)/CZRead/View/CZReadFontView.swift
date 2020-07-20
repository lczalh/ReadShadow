//
//  CZReadFontView.swift
//  Random
//
//  Created by yu mingming on 2020/6/16.
//  Copyright © 2020 刘超正. All rights reserved.
//

import UIKit

class CZReadFontView: BaseView {

    /// 标题
    var titleLabel: UILabel!
    
    var tableView: UITableView!
    
    /// 书阅读模型
    var bookReadModel: BookReadModel? {
        didSet {
            tableView.reloadData()
        }
    }
    
    private lazy var familyNames: Array<String> = {
        var names: Array<String> = []
        for familyName in UIFont.familyNames
        {
            let fontNames = UIFont.fontNames(forFamilyName: familyName)
            for fontName in fontNames
            {
                cz_print(fontName)
                names.append(fontName)
            }
        }
        return names
    }()
    
    /// 点击字体名称回调
    var tapFamilyNameBlock: (() -> Void)?

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
            .font(UIFont.cz_systemFont(16))
            .textColor(cz_standardTextColor)
            .text("字体")
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

extension CZReadFontView: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return familyNames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: VideoResourceTableViewCell.identifier, for: indexPath) as! VideoResourceTableViewCell
        let familyName = familyNames[indexPath.row]
        cell.titleLabel.text = familyName
        if bookReadFamilyName == familyName {
            cell.titleLabel.textColor = cz_selectedColor
        } else {
            cell.titleLabel.textColor = cz_standardTextColor
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        CZObjectStore.standard.cz_objectWriteUserDefault(object: familyNames[indexPath.row], key: "bookReadFamilyName")
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
        tableView.reloadData()
        if tapFamilyNameBlock != nil {
            tapFamilyNameBlock!()
        }
    }
}
