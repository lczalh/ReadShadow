//
//  File.swift
//  Random
//
//  Created by yu mingming on 2020/7/20.
//  Copyright © 2020 刘超正. All rights reserved.
//

import Foundation

class VideoEpisodeTableViewCell: BaseTableViewCell {
    
    static var identifier = "VideoEpisodeTableViewCell"

    private lazy var layout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
            .cz
            .estimatedItemSize(width: CZCommon.cz_dynamicFitWidth(30), height: CZCommon.cz_dynamicFitWidth(30))
            .minimumLineSpacing(5)
            .minimumInteritemSpacing(5)
            .sectionInset(top: 0, left: 10, bottom: 0, right: 10)
            .scrollDirection(.horizontal)
            .build
        return layout
    }()
    
    var episodeTitles: Array<String> = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    
    /// 选择的索引
    var selectorIndex: Int = 0
    
    /// 点击剧集的回调
    var didSelectItemBlock: ((Int) -> Void)?
    
    private lazy var collectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero,
                                  collectionViewLayout: layout)
            .cz
            .backgroundColor(cz_backgroundColor)
            .register(VideoEpisodeCollectionViewCell.self,
                      forCellWithReuseIdentifier: VideoEpisodeCollectionViewCell.identifier)
            .delegate(self)
            .dataSource(self)
            .showsHorizontalScrollIndicator(false)
            .build
        return view
    }()

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        collectionView.cz.addSuperView(contentView).makeConstraints({ (make) in
            make.edges.equalToSuperview()
        })
        
        let _ = UIView()
            .cz
            .addSuperView(contentView)
            .makeConstraints { (make) in
                make.right.left.bottom.equalToSuperview()
                make.height.equalTo(1)
            }
            .backgroundColor(cz_dividerColor)
            .build
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension VideoEpisodeTableViewCell: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return episodeTitles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: VideoEpisodeCollectionViewCell.identifier, for: indexPath) as! VideoEpisodeCollectionViewCell
        cell.titleLabel.text = episodeTitles[indexPath.row]
        if selectorIndex == indexPath.row {
            cell.titleLabel.textColor = cz_selectedColor
        } else {
            cell.titleLabel.textColor = cz_standardTextColor
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if didSelectItemBlock != nil {
            let cell = collectionView.cellForItem(at: indexPath)
            // 修正偏移位置
            var offsetPoint = collectionView.contentOffset
            offsetPoint.x = (cell?.center.x)! - collectionView.frame.width / 2
            //顶边超出处理
            if (offsetPoint.x < 0) {
                offsetPoint.x = 0
            }
            let maxX = abs(collectionView.contentSize.width - collectionView.frame.width)
            //底边超出处理
            if (offsetPoint.x > maxX) {
                offsetPoint.x = maxX
            }
            //设置滚动视图偏移量
            collectionView.setContentOffset(offsetPoint, animated: true)
            didSelectItemBlock!(indexPath.row)
        }
    }
    
}
