//
//  VideoDownloadManageController.swift
//  Random
//
//  Created by yu mingming on 2019/11/12.
//  Copyright © 2019 刘超正. All rights reserved.
//

import UIKit
import Tiercel

class VideoDownloadManageController: BaseController {
    
    lazy var videoDownloadManageView: VideoDownloadManageView = {
        let view = VideoDownloadManageView()
        return view
    }()
    
    lazy var listContainerView: JXSegmentedListContainerView = {
        let view = JXSegmentedListContainerView(dataSource: self)
        videoDownloadManageView.segmentedView.listContainer = view
        videoDownloadManageView.segmentedDataSource.titles = titles
        return view
    }()
    
    /// 标题
    var titles: Array<String> = ["下载中","已下载"]
    
    /// 下载管理
    var sessionManager: SessionManager = (UIApplication.shared.delegate as! AppDelegate).sessionManager
    
    /// 所有下载地址
    var downloadURLStrings: Array<String> = []
    
    override func setupNavigationItems() {
        super.setupNavigationItems()
        titleView?.title = "缓存"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "Icon_Home_Video_Input")?.cz_alterColor(color: cz_selectedColor), style: .done, target: self, action: nil)
        navigationItem.rightBarButtonItem?.rx.tap.subscribe(onNext: {[weak self] () in
            let dialogTextFieldViewController = QMUIDialogTextFieldViewController()
            dialogTextFieldViewController.titleView?.title = "下载/播放"
            dialogTextFieldViewController.submitButton?.isEnabled = true
            dialogTextFieldViewController.addTextField(withTitle: "影片名称") { (label, textField, layer) in
                
            }
            dialogTextFieldViewController.addTextField(withTitle: "影片地址") { (label, textField, layer) in
               
                textField.keyboardType = .URL
            }
            dialogTextFieldViewController.addCancelButton(withText: "取消") { _ in }
            let menuView = QMUIPopupMenuView()
            menuView.automaticallyHidesWhenUserTap = true
            menuView.preferLayoutDirection = .below
            menuView.maximumWidth = 100
            menuView.safetyMarginsOfSuperview = UIEdgeInsetsSetRight(menuView.safetyMarginsOfSuperview, 6)
            menuView.items = [
                QMUIPopupMenuButtonItem(image: nil, title: "播放URL", handler: { (item) in
                    item.menuView?.hideWith(animated: true, completion: { _ in
                        dialogTextFieldViewController.addSubmitButton(withText: "播放") { (viewController) in
                            dialogTextFieldViewController.hideWith(animated: true) { _ in
                                let textUrlString = (dialogTextFieldViewController.textFields![1].text!).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
                                DispatchQueue.main.async {
                                    let fullscreenPlayController = FullscreenPlayController()
                                    fullscreenPlayController.videoURL = textUrlString
                                    fullscreenPlayController.videoName = dialogTextFieldViewController.textFields![0].text
                                    self?.navigationController?.pushViewController(fullscreenPlayController, animated: true)
                                }
                            }
                        }
                        dialogTextFieldViewController.show()
                    })
                }),
                QMUIPopupMenuButtonItem(image: nil, title: "下载URL", handler: { (item) in
                    item.menuView?.hideWith(animated: true, completion: { _ in
                        dialogTextFieldViewController.addSubmitButton(withText: "下载") { (viewController) in
                            dialogTextFieldViewController.hideWith(animated: true) { _ in
                                let textUrlString = (dialogTextFieldViewController.textFields![1].text!).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
                                guard let url = URL(string: textUrlString), url.host != nil else {
                                    CZHUD.showError("影片地址有误")
                                    return
                                }
                                DispatchQueue.main.async {
                                    // 中文转码
                                    let videoName = "\(dialogTextFieldViewController.textFields![0].text ?? "")".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
                                    // 下载
                                    appDelegate.sessionManager.download(url, fileName: "\(videoName ?? "").\(url.pathExtension)")
                                }
                            }
                        }
                        dialogTextFieldViewController.show()
                    })
                })
            ]
            menuView.sourceBarItem = self?.navigationItem.rightBarButtonItem
            menuView.showWith(animated: true)
        }).disposed(by: rx.disposeBag)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DispatchQueue.main.async { self.navigationController?.setNavigationBarHidden(false, animated: false) }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        videoDownloadManageView.cz.addSuperView(view).makeConstraints { (make) in
            if #available(iOS 11.0, *) {
                make.edges.equalTo(view.safeAreaLayoutGuide)
            } else {
                make.edges.equalToSuperview().inset(UIEdgeInsets(top: 0, left: 0, bottom: CZCommon.cz_tabbarHeight, right: 0))
            }
        }
        
        listContainerView.cz.addSuperView(videoDownloadManageView).makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.top.equalToSuperview().offset(CZCommon.cz_screenWidthScale * CZCommon.cz_navigationHeight)
        }

    }

}

extension VideoDownloadManageController: JXSegmentedListContainerViewDataSource {
    func numberOfLists(in listContainerView: JXSegmentedListContainerView) -> Int {
        return titles.count
    }

    func listContainerView(_ listContainerView: JXSegmentedListContainerView, initListAt index: Int) -> JXSegmentedListContainerViewListDelegate {
        if index == 0 {
            let videoDownloadController = VideoDownloadController()
            return videoDownloadController
        } else {
            let haveDownloadedController = HaveDownloadedController()
            return haveDownloadedController
        }
        
    }
    
}
