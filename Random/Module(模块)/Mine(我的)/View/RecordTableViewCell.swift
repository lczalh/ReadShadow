//
//  RecordTableViewCell.swift
//  Random
//
//  Created by yu mingming on 2020/6/5.
//  Copyright © 2020 刘超正. All rights reserved.
//

import UIKit

class RecordTableViewCell: BaseTableViewCell {
    
    static var identifier = "RecordTableViewCell"
    
    lazy var layout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
            .cz
            .itemSize(CGSize(width: CZCommon.cz_dynamicFitWidth(100), height: CZCommon.cz_dynamicFitHeight(80)))
            .minimumLineSpacing(5)
            .minimumInteritemSpacing(5)
            .scrollDirection(.horizontal)
            .sectionInset(top: 0, left: 15, bottom: 0, right: 15)
            .build
        return layout
    }()
    
    private var collectionView: UICollectionView!
    
    /// 数据模型
    var recordTableViewModels: Array<RecordTableViewModel> = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    
    /// 点击item回调
    var didSelectItemBlock: ((_ indexPath: IndexPath) -> Void)?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        collectionView = UICollectionView(frame: .zero,
                          collectionViewLayout: layout)
            .cz
            .addSuperView(self)
            .makeConstraints({ (make) in
                make.edges.equalToSuperview()
            })
            .backgroundColor(cz_backgroundColor)
            .register(RecordMineCollectionViewCell.self,
                      forCellWithReuseIdentifier: RecordMineCollectionViewCell.identifier)
            .dataSource(self)
            .delegate(self)
            .showsHorizontalScrollIndicator(false)
            .build
        
        let _ = UIView()
        .cz
        .addSuperView(self)
        .makeConstraints { (make) in
            make.right.bottom.equalToSuperview()
            make.left.equalToSuperview().offset(15)
            make.height.equalTo(1)
        }
        .backgroundColor(cz_dividerColor)
        .build
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    

}

extension RecordTableViewCell: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return recordTableViewModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecordMineCollectionViewCell.identifier, for: indexPath) as! RecordMineCollectionViewCell
        let recordTableViewModel = recordTableViewModels[indexPath.row]
        cell.videoImageView.kf.indicatorType = .activity
        cell.videoImageView.kf.setImage(with: URL(string: recordTableViewModel.imageUrlString), placeholder: UIImage(named: "Icon_Placeholder"))
        cell.videoTitleLabel.text = recordTableViewModel.titleName
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if didSelectItemBlock != nil {
            didSelectItemBlock!(indexPath)
        }
    }
    
}
