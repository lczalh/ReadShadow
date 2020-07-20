//
//  MoreBrilliantTableViewCell.swift
//  Random
//
//  Created by yu mingming on 2019/11/11.
//  Copyright © 2019 刘超正. All rights reserved.
//

import UIKit

class MoreBrilliantTableViewCell: BaseTableViewCell {
    
    public static var identifier = "MoreBrilliantTableViewCell"
    
    /// 点击CollectionViewCell回调
    var tapCollectionViewCell: (() -> ())?
    
    private var itemHeight: CGFloat {
        if CZCommon.cz_isIphone {
            return CZCommon.cz_dynamicFitHeight(180)
        } else {
            return CZCommon.cz_dynamicFitHeight(220)
        }
    }
    
    /// 所有视频模型数据
    var models: Array<ReadShadowVideoModel> = [] {
        didSet {
            // 计算行
            let line = CGFloat(models.count).truncatingRemainder(dividingBy: 3.0) == 0 ? CGFloat(models.count / 3) : CGFloat((models.count + 1) / 3)
            let height = itemHeight * line + line * 10
            collectionView.cz.remakeConstraints { (make) in
                make.top.equalTo(moreWonderfulLabel.snp.bottom).offset(5)
                make.right.left.bottom.equalToSuperview()
                make.height.equalTo(height)
            }
            collectionView.reloadData()
        }
    }
    
    private lazy var layout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
            .cz
            .itemSize(CGSize(width: (CZCommon.cz_screenWidth - 20) / 3, height: itemHeight))
            .minimumLineSpacing(10)
            .minimumInteritemSpacing(5)
            .sectionInset(top: 0, left: 5, bottom: 0, right: 5)
            .build
        return layout
    }()
    
    private lazy var collectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero,
                                  collectionViewLayout: layout)
            .cz
            .backgroundColor(cz_backgroundColor)
            .register(VideoListCollectionViewCell.self,
                      forCellWithReuseIdentifier: VideoListCollectionViewCell.identifier)
            .delegate(self)
            .dataSource(self)
            .isScrollEnabled(false)
            .build
        return view
    }()
    
    /// 更多精彩
    private var moreWonderfulLabel: UILabel!

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
        moreWonderfulLabel = UILabel()
            .cz
            .addSuperView(contentView)
            .makeConstraints({ (make) in
                make.left.equalToSuperview().offset(10)
                make.top.equalToSuperview().offset(10)
            })
            .text("更多精彩")
            .font(.cz_boldSystemFont(14))
            .build
        
        collectionView.cz.addSuperView(contentView).makeConstraints({ (make) in
            make.top.equalTo(moreWonderfulLabel.snp.bottom).offset(10)
            make.right.left.bottom.equalToSuperview()
        })
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - UICollectionViewDelegate
extension MoreBrilliantTableViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return models.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: VideoListCollectionViewCell.identifier, for: indexPath) as! VideoListCollectionViewCell
        let model = models[indexPath.row]
        cell.videoImageView.kf.indicatorType = .activity
        cell.videoImageView.kf.setImage(with: URL(string: model.pic), placeholder: UIImage(named: "Icon_Placeholder"))
        cell.titleLabel.text = model.name
        if model.continu == nil || model.continu?.isEmpty == true {
            cell.continuLabel.text = model.year
        } else {
            cell.continuLabel.text = model.continu
        }
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension MoreBrilliantTableViewCell: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let vc = cz_superController(seekViewController: VideoDetailsController.self) else { return }
        let model = models[indexPath.row]
        DispatchQueue.main.async {
            let videoDetailsController = VideoDetailsController()
            videoDetailsController.model = model
            vc.navigationController?.pushViewController(videoDetailsController, animated: true)
        }
    }
}
